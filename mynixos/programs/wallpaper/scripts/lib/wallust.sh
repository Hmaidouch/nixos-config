#!/usr/bin/env bash

set -euo pipefail

# ============================================================
# Wallust Library
# ============================================================

wallust_apply() {

    local image="$1"

    [[ -f "$image" ]] || {
        echo "Wallpaper not found: $image"
        return 1
    }

    wallust run "$image"
}

# ------------------------------------------------------------
# Reload last wallpaper colors
# ------------------------------------------------------------

wallust_reload() {

    local image="$1"

    wallust_apply "$image"
}