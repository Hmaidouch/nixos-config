#!/usr/bin/env bash

set -euo pipefail

ROFI_THEME="${HOME}/.config/rofi/themes/network.rasi"

declare -a _ssid_map=()

notify() {
    notify-send -a "Network" "$1" "${2:-}" -i network-wireless
}

wifi_enabled() {
    nmcli radio wifi | grep -qi '^enabled$'
}

get_wlan_iface() {
    nmcli -t -f DEVICE,TYPE dev status | awk -F: '$2=="wifi"{print $1; exit}'
}

get_saved_connection_for_ssid() {
    local ssid="$1"
    nmcli -t -f NAME,TYPE connection show 2>/dev/null \
        | awk -F: -v s="$ssid" '$2=="802-11-wireless" && $1==s {print $1; exit}'
}

list_wifi_entries() {
    local idx=0
    while IFS=: read -r inuse ssid signal security; do
        [[ -n "${ssid// }" ]] || continue

        _ssid_map[$idx]="$ssid"

        local icon lock mark
        mark=""
        [[ "$inuse" == "*" ]] && mark="󰖩 "

        if (( signal >= 80 )); then icon="󰤨"
        elif (( signal >= 60 )); then icon="󰤥"
        elif (( signal >= 40 )); then icon="󰤢"
        elif (( signal >= 20 )); then icon="󰤟"
        else icon="󰤯"
        fi

        if [[ -n "${security// }" && "$security" != "--" ]]; then
            lock=""
        else
            lock=""
        fi

        printf "NET|%d|%s%s  %s  %s%% %s\n" "$idx" "$mark" "$ssid" "$icon" "$signal" "$lock"
        ((idx++))
    done < <(nmcli -t -f IN-USE,SSID,SIGNAL,SECURITY dev wifi list --rescan auto 2>/dev/null)
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
        if nmcli connection up "$saved" >/dev/null 2>&1; then
            notify "Connected" "$saved"
        else
            notify "Connection failed" "$saved"
        fi
        return
    fi

    local password
    password="$(rofi -dmenu \
        -p "Password for $ssid" \
        -password \
        -theme "$ROFI_THEME")"

    [[ -n "${password:-}" ]] || return

    if nmcli dev wifi connect "$ssid" password "$password" >/dev/null 2>&1; then
        notify "Connected" "$ssid"
    else
        notify "Connection failed" "Wrong password or out of range"
    fi
}

disconnect_network() {
    local iface
    iface="$(get_wlan_iface)"

    if [[ -z "$iface" ]]; then
        notify "No wireless interface found"
        return
    fi

    if nmcli device disconnect "$iface" >/dev/null 2>&1; then
        notify "Disconnected" "$iface"
    else
        notify "Disconnect failed" "$iface"
    fi
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
                        notify "Wi-Fi disabled"
                    else
                        nmcli radio wifi on
                        notify "Wi-Fi enabled"
                    fi
                    ;;
                "󰑐  Rescan")
                    nmcli dev wifi rescan >/dev/null 2>&1 || true
                    notify "Scanning..." "Finding available networks"
                    ;;
                "󰕒  Disconnect")
                    disconnect_network
                    ;;
                "󱂬  Connection Manager")
                    nm-connection-editor &
                    ;;
            esac
            ;;
        NET)
            local idx="${value%%|*}"
            local ssid="${_ssid_map[$idx]:-}"

            [[ -n "$ssid" ]] && connect_to_network "$ssid"
            ;;
    esac
}

main "$@"
