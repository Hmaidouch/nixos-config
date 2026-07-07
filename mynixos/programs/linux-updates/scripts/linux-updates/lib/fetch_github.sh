#!/usr/bin/env bash

set -euo pipefail

github_latest_release() {
    local repo="$1"   # مثال: hyprwm/Hyprland

    curl -fsS \
        -H "Accept: application/vnd.github+json" \
        "https://api.github.com/repos/${repo}/releases/latest"
}