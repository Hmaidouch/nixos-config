#!/usr/bin/env bash

set -euo pipefail

# ============================================================
# Wallpaper Picker Library
# ============================================================

# Directory containing wallpapers
WALLPAPER_DIR="${WALLPAPER_DIR:-$HOME/Pictures/wallpapers}"

# Supported image extensions
IMAGE_EXTENSIONS=(
    "*.jpg"
    "*.jpeg"
    "*.png"
    "*.webp"
    "*.bmp"
)

# ------------------------------------------------------------
# Build wallpaper list
# ------------------------------------------------------------

picker_list() {

    find "$WALLPAPER_DIR" \
        -type f \
        \( \
            -iname "*.jpg"  -o \
            -iname "*.jpeg" -o \
            -iname "*.png"  -o \
            -iname "*.webp" -o \
            -iname "*.bmp" \
        \) \
        | sort
}

# ------------------------------------------------------------
# Choose wallpaper
# ------------------------------------------------------------

picker_choose() {

    local files
    local names
    local choice

    mapfile -t files < <(picker_list)

    [[ ${#files[@]} -eq 0 ]] && return 1

    names=$(
        for file in "${files[@]}"
        do
            basename "$file"
        done
    )

    choice=$(
        printf "%s\n" "$names" |
        rofi \
            -dmenu \
            -i \
            -p "🖼 Wallpaper" \
            -config "$HOME/.config/rofi/themes/general_news.rasi"
    )

    [[ -z "$choice" ]] && return 1

    for file in "${files[@]}"
    do
        if [[ "$(basename "$file")" == "$choice" ]]
        then
            PICKED_WALLPAPER="$file"
            export PICKED_WALLPAPER
            return 0
        fi
    done

    return 1
}