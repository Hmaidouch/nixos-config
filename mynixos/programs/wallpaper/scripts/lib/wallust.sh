#!/usr/bin/env bash

set -euo pipefail

# ============================================================
# Wallust Library
# ============================================================

reload_waybar() {
    pkill -USR2 -x waybar 2>/dev/null || true
}

wallust_apply() {

    local image="$1"

    [[ -f "$image" ]] || {
        echo "Wallpaper not found: $image"
        return 1
    }

    wallust run "$image"

    reload_waybar
}

# ------------------------------------------------------------
# Reload last wallpaper colors
# ------------------------------------------------------------

wallust_reload() {

    local image="$1"

    wallust_apply "$image"
}