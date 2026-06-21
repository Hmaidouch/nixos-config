#!/usr/bin/env bash

# ==============================================================================
# Rofi Favorites Launcher - Final Wayland Fix (Hyprland & Niri)
# ==============================================================================

set -euo pipefail

# --- Configuration ---
readonly ROFI_THEME_FAV="${HOME}/.config/rofi/themes/Style_fav_launcher.rasi"
readonly ROFI_THEME_ALL="${HOME}/.config/rofi/themes/Style_all_applications.rasi"

# --- Functions ---

check_rofi_running() {
    # 🌟 حل المشكلة الأولى: إذا كان rofi مفتوحاً بالفعل، قم بإغلاقه واخرج فوراً
    if pgrep -x "rofi" > /dev/null; then
        pkill -x rofi
        exit 0
    fi
}

build_menu() {
    printf "All Apps\x00icon\x1fview-app-grid\n"
    printf "firefox\x00display\x1fFirefox\x1ficon\x1ffirefox\n"
    printf "nemo\x00display\x1fNemo\x1ficon\x1fnemo\n"
    printf "alacritty\x00display\x1fTerminal\x1ficon\x1ffoot\n"
    printf "code\x00display\x1fVS Code\x1ficon\x1fcode\n"
}

launch_app() {
    local choice="$1"
    local app_name
    
    app_name=$(echo "$choice" | sed 's/\x00.*//')
    
    if [[ -n "$app_name" ]]; then
        nohup bash -c "$app_name" > /dev/null 2>&1 & 
        disown
    fi
}

show_all_apps() {
    if [[ -f "$ROFI_THEME_ALL" ]]; then
        rofi -show drun -theme "$ROFI_THEME_ALL" -click-to-exit
    else
        rofi -show drun -click-to-exit
    fi
}

show_favorites_menu() {
    local choice
    
    # أضفنا خيار -click-to-exit وتأكدنا من إزالة الخيارات التي قد تتعارض مع Niri
    choice=$(build_menu | rofi -dmenu \
        -theme "$ROFI_THEME_FAV" \
        -auto-select \
        -click-to-exit) || exit 0
    
    if [[ -z "$choice" ]]; then
        exit 0
    fi
    
    if [[ "$choice" == "All Apps"* ]]; then
        show_all_apps
    else
        launch_app "$choice"
    fi
}

# --- Main Execution ---

main() {
    check_rofi_running
    show_favorites_menu
}

main "$@"