#!/usr/bin/env bash

set -euo pipefail

# ============================================================
# Wallust Library
# ============================================================

reload_waybar() {
    #pkill -USR2 -x waybar 2>/dev/null || true
    #pkill -SIGUSR2 waybar
    #pkill -SIGUSR2 waybar 2>/dev/null || true
    pkill --signal SIGUSR2 waybar 2>/dev/null || true
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

wallust_reload() {
    local image="$1"
    wallust_apply "$image"
}