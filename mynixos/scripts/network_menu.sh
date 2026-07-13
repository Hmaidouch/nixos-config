#!/usr/bin/env bash

set -euo pipefail

ROFI_THEME="${HOME}/.config/rofi/themes/network.rasi"

wifi_enabled() {
    nmcli radio wifi | grep -qi '^enabled$'
}

get_saved_connection_for_ssid() {
    local ssid="$1"
    nmcli -t -f NAME,TYPE connection show \
        | awk -F: -v ssid="$ssid" '$2=="802-11-wireless" && $1==ssid {print $1; exit}'
}

list_wifi_entries() {
    nmcli -t -f IN-USE,SSID,SIGNAL,SECURITY dev wifi list --rescan auto \
    | while IFS=: read -r inuse ssid signal security; do
        [[ -n "${ssid// }" ]] || continue

        local icon lock mark sec_text
        mark=""
        [[ "$inuse" == "*" ]] && mark="󰖩 "

        if (( signal >= 80 )); then
            icon="󰤨"
        elif (( signal >= 60 )); then
            icon="󰤥"
        elif (( signal >= 40 )); then
            icon="󰤢"
        elif (( signal >= 20 )); then
            icon="󰤟"
        else
            icon="󰤯"
        fi

        if [[ -n "${security// }" && "$security" != "--" ]]; then
            lock=""
            sec_text=" ${security}"
        else
            lock=""
            sec_text=""
        fi

        printf "NET|%s%s  %s  %s%% %s\n" "$mark" "$ssid" "$icon" "$signal" "$lock"
    done
}

build_menu() {
    echo "ACTION|󰖪  Wi-Fi: Toggle"
    echo "ACTION|󰑐  Rescan"
    echo "ACTION|󰕒  Disconnect"
    echo "ACTION|󱂬  Connection Manager"
    echo "SEP|────────────────────────"
    list_wifi_entries
}

connect_to_network() {
    local ssid="$1"
    local saved

    saved="$(get_saved_connection_for_ssid "$ssid" || true)"

    if [[ -n "$saved" ]]; then
        nmcli connection up "$saved" >/dev/null
        exit 0
    fi

    local password
    password="$(rofi -dmenu \
        -p "Password for $ssid" \
        -password \
        -theme "$ROFI_THEME")"

    [[ -n "${password:-}" ]] || exit 0

    nmcli dev wifi connect "$ssid" password "$password" >/dev/null
}

main() {
    local choice
    choice="$(build_menu | rofi -dmenu -i -p "Networks" -theme "$ROFI_THEME")" || exit 0
    [[ -n "${choice:-}" ]] || exit 0

    local kind value
    kind="${choice%%|*}"
    value="${choice#*|}"

    case "$kind" in
        ACTION)
            case "$value" in
                "󰖪  Wi-Fi: Toggle")
                    if wifi_enabled; then
                        nmcli radio wifi off
                    else
                        nmcli radio wifi on
                    fi
                    ;;
                "󰑐  Rescan")
                    nmcli dev wifi rescan >/dev/null 2>&1 || true
                    ;;
                "󰕒  Disconnect")
                    nmcli device disconnect wlan0 >/dev/null 2>&1 || true
                    ;;
                "󱂬  Connection Manager")
                    nm-connection-editor &
                    ;;
            esac
            ;;
        NET)
            # نحذف الأيقونات من البداية ونستخرج اسم الشبكة
            local ssid
            ssid="$(printf '%s\n' "$value" \
                | sed -E 's/^󰖩[[:space:]]*//' \
                | sed -E 's/[[:space:]]+󰤨.*$//' \
                | sed -E 's/[[:space:]]+󰤥.*$//' \
                | sed -E 's/[[:space:]]+󰤢.*$//' \
                | sed -E 's/[[:space:]]+󰤟.*$//' \
                | sed -E 's/[[:space:]]+󰤯.*$//')"

            [[ -n "${ssid// }" ]] && connect_to_network "$ssid"
            ;;
    esac
}

main "$@"