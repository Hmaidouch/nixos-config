#!/usr/bin/env bash

set -euo pipefail

# ============================================================
# Message formatting
# ============================================================

format_release_message() {
    local source_label="$1"
    local title="$2"
    local url="$3"
    local summary="${4:-}"

    local ar_title ar_summary

    ar_title="$(translate_release_title_ar "$source_label" "$title")"
    ar_summary="$(summarize_release_ar "$source_label" "$ar_title" "$summary")"

    if [[ -n "$ar_summary" ]]; then
        printf '🟢 تحديث جديد من %s\n\n📌 العنوان:\n%s\n\n📝 الخلاصة:\n%s\n\n🔗 الرابط:\n%s\n' \
            "$source_label" \
            "$ar_title" \
            "$ar_summary" \
            "$url"
    else
        printf '🟢 تحديث جديد من %s\n\n📌 العنوان:\n%s\n\n🔗 الرابط:\n%s\n' \
            "$source_label" \
            "$ar_title" \
            "$url"
    fi
}