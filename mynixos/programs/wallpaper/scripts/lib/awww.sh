#!/usr/bin/env bash

set -euo pipefail

# ============================================================
# awww Library
# ============================================================

# Start daemon if not already running
awww_start() {

    if ! pgrep -x awww-daemon >/dev/null; then
        awww-daemon >/dev/null 2>&1 &
        sleep 0.5
    fi
}

# ------------------------------------------------------------
# Set wallpaper
# ------------------------------------------------------------

awww_set() {

    local image="$1"

    [[ -f "$image" ]] || {
        echo "Wallpaper not found: $image"
        return 1
    }

    awww_start

    awww img "$image"
}

# ------------------------------------------------------------
# Reload wallpaper
# ------------------------------------------------------------

awww_reload() {

    local image="$1"

    awww_start

    awww img "$image"
}