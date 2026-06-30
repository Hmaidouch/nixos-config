#!/usr/bin/env bash

# ============================================================
# UI Library
# ============================================================

ROFI_THEME="$HOME/.config/rofi/themes/general_news.rasi"
ROFI_AI_THEME="$HOME/.config/rofi/themes/ai_news.rasi"

# ============================================================
# Main Menu
# ============================================================

ui_source_menu() {

    printf "%s\n" \
        "📰 Reddit" \
        "🚀 GitHub Releases" \
        "💬 GitHub Commits" \
        "🐞 GitHub Issues" |
    rofi -dmenu \
        -i \
        -p "$PROJECT_ICON $PROJECT_NAME" \
        -config "$ROFI_THEME"
}

# ============================================================
# Posts Menu
# ============================================================

ui_post_menu() {

    local prompt="$1"

    choice=$(printf "%s\n" "${titles[@]}" |
        rofi -dmenu \
            -i \
            -p "$prompt" \
            -kb-custom-1 MouseSecondary \
            -mesg "🖱 Left : Gemini Summary | Right : Open Link" \
            -config "$ROFI_THEME")

    exit_code=$?

    [[ -z "$choice" ]] && return 1

    for i in "${!titles[@]}"; do
        [[ "${titles[$i]}" == "$choice" ]] && {
            SELECTED_INDEX="$i"
            SELECTED_URL="${urls[$i]}"
            break
        }
    done

    return 0
}

# ============================================================
# Open Browser
# ============================================================

ui_open_url() {
    xdg-open "$1" >/dev/null 2>&1 &
    disown
}

# ============================================================
# Copy Summary
# ============================================================

ui_copy_summary() {
    printf "%s" "$1" | wl-copy
}

# ============================================================
# Summary Window
# ============================================================

ui_show_summary() {

    printf "%s" "$1" |
    zenity \
        --text-info \
        --title="$PROJECT_NAME AI" \
        --width=750 \
        --height=650 \
        --font="Vazirmatn 14"
}

# ============================================================
# Notifications
# ============================================================

ui_notify() {

    local title="$1"
    local body="$2"

    notify-send \
        -t 1500 \
        "$title" \
        "$body"
}

# ============================================================
# Error
# ============================================================

ui_error() {

    notify-send \
        -u critical \
        "$PROJECT_NAME" \
        "$1"
}