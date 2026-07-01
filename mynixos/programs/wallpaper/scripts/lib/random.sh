#!/usr/bin/env bash

set -euo pipefail

# ============================================================
# Random Wallpaper Library
# ============================================================

# Return a random wallpaper path.
random_wallpaper() {

    local wallpapers=()

    mapfile -t wallpapers < <(picker_list)

    [[ ${#wallpapers[@]} -eq 0 ]] && return 1

    local index=$(( RANDOM % ${#wallpapers[@]} ))

    RANDOM_WALLPAPER="${wallpapers[$index]}"
    export RANDOM_WALLPAPER
}