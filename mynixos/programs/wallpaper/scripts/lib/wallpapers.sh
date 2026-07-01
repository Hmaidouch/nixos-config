#!/usr/bin/env bash

set -euo pipefail

# ============================================================
# Wallpapers Library
# ============================================================

: "${WALLPAPER_DIR:=$HOME/Pictures/wallpapers}"

# ------------------------------------------------------------
# List wallpapers
# ------------------------------------------------------------

list_wallpapers() {

    find "$WALLPAPER_DIR" \
        -type f \
        \( \
            -iname "*.jpg"  -o \
            -iname "*.jpeg" -o \
            -iname "*.png"  -o \
            -iname "*.webp" \
        \) \
        | sort
}

# ------------------------------------------------------------
# Check if wallpaper exists
# ------------------------------------------------------------

wallpaper_exists() {

    local file="$1"

    [[ -f "$file" ]]
}


wallpaper_index() {

    local current="$1"

    mapfile -t wallpapers < <(list_wallpapers)

    for i in "${!wallpapers[@]}"
    do
        [[ "${wallpapers[$i]}" == "$current" ]] && {
            echo "$i"
            return 0
        }
    done

    return 1
}

# ------------------------------------------------------------
# Next wallpaper
# ------------------------------------------------------------

wallpaper_next() {

    local current="$1"

    mapfile -t wallpapers < <(list_wallpapers)

    [[ ${#wallpapers[@]} -eq 0 ]] && return 1

    local index

    index=$(wallpaper_index "$current") || index=-1

    ((index++))

    if (( index >= ${#wallpapers[@]} ))
    then
        index=0
    fi

    echo "${wallpapers[$index]}"
}

# ------------------------------------------------------------
# Previous wallpaper
# ------------------------------------------------------------

wallpaper_previous() {

    local current="$1"

    mapfile -t wallpapers < <(list_wallpapers)

    [[ ${#wallpapers[@]} -eq 0 ]] && return 1

    local index

    index=$(wallpaper_index "$current") || index=0

    ((index--))

    if (( index < 0 ))
    then
        index=$((${#wallpapers[@]}-1))
    fi

    echo "${wallpapers[$index]}"
}