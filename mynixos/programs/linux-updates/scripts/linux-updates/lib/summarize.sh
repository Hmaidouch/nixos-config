#!/usr/bin/env bash

set -euo pipefail

# ============================================================
# Summarize / rewrite news content into Arabic
# ============================================================

summarize_release_ar() {
    local source_label="$1"
    local title="$2"
    local raw_text="$3"

    raw_text="$(trim "$raw_text")"

    # لو لم يوجد محتوى، نرجع فارغ
    [[ -n "$raw_text" ]] || return 0

    # --------------------------------------------------------
    # NixOS
    # --------------------------------------------------------
    if [[ "$source_label" == "NixOS" ]]; then
        printf 'هذا الخبر يخص %s.\n\n%s\n' "$title" "$raw_text"
        return 0
    fi

    # --------------------------------------------------------
    # Generic fallback
    # --------------------------------------------------------
    printf '%s\n' "$raw_text"
}