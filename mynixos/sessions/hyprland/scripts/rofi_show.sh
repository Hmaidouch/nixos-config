#!/usr/bin/env bash

# ==============================================================================
# Rofi Favorites Launcher - Final Fix
# ==============================================================================

set -euo pipefail

# --- Configuration ---
#readonly FAV_FILE="${HOME}/.config/rofi/favorites.txt"
readonly ROFI_THEME_FAV="${HOME}/.config/rofi/themes/Style_fav_launcher.rasi"
readonly ROFI_THEME_ALL="${HOME}/.config/rofi/themes/Style_all_applications.rasi"

# --- Functions ---

check_rofi_running() {
   # if pgrep -x "rofi" > /dev/null; then
   #     pkill -x rofi
   #     exit 0
  #  fi
    pkill -x rofi 2>/dev/null || true
}

#validate_files() {
#    if [[ ! -f "$FAV_FILE" ]]; then
#        mkdir -p "$(dirname "$FAV_FILE")"
#        touch "$FAV_FILE"
#   fi
#}

build_menu() {
    # --- التصحيح هنا ---
    # نستخدم echo -en مع \x00 لضمان الفصل التام بين الاسم والأيقونة
    # غيرت الأيقونة إلى view-app-grid لأنها أنسب لزر "كل التطبيقات"
    echo "All Apps\0icon\x1fview-app-grid"

echo "firefox\0display\x1fFirefox\x1ficon\x1ffirefox"
echo "nemo\0display\x1fNemo\x1ficon\x1fnemo"
echo "alacritty\0display\x1fTerminal\x1ficon\x1ffoot"
echo "code\0display\x1fVS Code\x1ficon\x1fcode"
echo "libreoffice --writer\0display\x1fWriter\x1ficon\x1flibreoffice-writer"
echo "libreoffice --calc\0display\x1fCalc\x1ficon\x1flibreoffice-calc"
echo "thunar\0display\x1fThunar\x1ficon\x1fthunar"
echo "onlyoffice-desktopeditors\0display\x1fOnlyOffice\x1ficon\x1fonlyoffice"
echo "gnome-calculator\0display\x1fCalculator\x1ficon\x1forg.gnome.Calculator"
echo "localsend\0display\x1fLocalSend\x1ficon\x1flocalsend"
echo "resources\0display\x1fResources\x1ficon\x1fresources"

#echo "waydroid show-full-ui\0display\x1fWaydroid\x1ficon\x1fwaydroid"
#echo "/run/current-system/sw/bin/waydroid show-full-ui\0display\x1fWaydroid\x1ficon\x1fwaydroid"


    
    # قراءة المفضلة
   # if [[ -s "$FAV_FILE" ]]; then
   #     cat "$FAV_FILE"
   # fi
}

launch_app() {
    local choice="$1"
    
    # تنظيف الاسم من أي رموز مخفية
    local app_name
    app_name=$(echo "$choice" | sed 's/\x00.*//')
    
    if [[ -n "$app_name" ]]; then
        nohup bash -c "$app_name" > /dev/null 2>&1 & 
        disown
    fi
}

show_all_apps() {
    if [[ -f "$ROFI_THEME_ALL" ]]; then
        rofi -show drun -theme "$ROFI_THEME_ALL"
    else
        rofi -show drun
    fi
}

show_favorites_menu() {
    local menu_content
    menu_content=$(build_menu)


    
    # عرض القائمة
    # -auto-select للتحميل بسرعة 
    local choice
    choice=$(echo -en "$menu_content" | rofi -dmenu \
        -theme "$ROFI_THEME_FAV" \
        -auto-select ) 
    
    local exit_code=$?
    
    if [[ $exit_code -ne 0 ]]; then
        exit 0
    fi
    
    # التحقق من الاختيار
    # نستخدم المطابقة الجزئية لأن النص قد يحتوي على رموز مخفية
    if [[ "$choice" == "All Apps"* ]]; then
      #  sleep 0.1
        show_all_apps
    else
        launch_app "$choice"
    fi
}

# --- Main Execution ---

main() {
    check_rofi_running
    #validate_files
    show_favorites_menu
}

main "$@"
