#!/usr/bin/env bash

set -euo pipefail

# ============================================================
# Directories
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$SCRIPT_DIR/lib"

# ============================================================
# Load libraries
# ============================================================

source "$LIB_DIR/wallpapers.sh"
source "$LIB_DIR/cache.sh"
source "$LIB_DIR/picker.sh"
source "$LIB_DIR/random.sh"
source "$LIB_DIR/awww.sh"
source "$LIB_DIR/wallust.sh"

# ============================================================
# Select wallpaper
# ============================================================

case "${1:-random}" in

    random)

        random_wallpaper || exit 1
        IMAGE="$RANDOM_WALLPAPER"
        ;;

    next)

        IMAGE="$(wallpaper_next "$(cache_get_current)")"
        ;;

    previous)

        IMAGE="$(wallpaper_previous "$(cache_get_current)")"
        ;;

    pick)

        picker_choose || exit 0
        IMAGE="$PICKED_WALLPAPER"
        ;;

    *)

        echo "Usage:"
        echo "  wallpaper random"
        echo "  wallpaper next"
        echo "  wallpaper previous"
        echo "  wallpaper pick"
        exit 1
        ;;

esac

# ============================================================
# Apply wallpaper
# ============================================================

awww_set "$IMAGE"

# ============================================================
# Generate colors
# ============================================================

wallust_apply "$IMAGE"

# ============================================================
# Cache
# ============================================================

cache_set_current "$IMAGE"
cache_add_history "$IMAGE"

exit 0