#!/usr/bin/env bash

set -euo pipefail

# ============================================================
# Logging
# ============================================================

log_info() {
    echo "[INFO] $*"
}

log_warn() {
    echo "[WARN] $*" >&2
}

log_error() {
    echo "[ERROR] $*" >&2
}

# ============================================================
# Robust HTTP fetch
# ============================================================

fetch_url() {
    local url="$1"

    curl \
        --silent \
        --show-error \
        --location \
        --fail \
        --retry 3 \
        --retry-delay 2 \
        --connect-timeout 15 \
        --max-time 45 \
        "$url"
}

# ============================================================
# Python lookup
# ============================================================

find_python3() {
    local candidates=(
        "${PYTHON3:-}"
        "/run/current-system/sw/bin/python3"
        "$HOME/.nix-profile/bin/python3"
        "/etc/profiles/per-user/$USER/bin/python3"
    )

    for candidate in "${candidates[@]}"; do
        [[ -n "$candidate" ]] || continue
        [[ -x "$candidate" ]] && {
            printf '%s\n' "$candidate"
            return 0
        }
    done

    if command -v python3 >/dev/null 2>&1; then
        command -v python3
        return 0
    fi

    return 1
}