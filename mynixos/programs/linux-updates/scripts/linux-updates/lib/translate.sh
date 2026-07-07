#!/usr/bin/env bash

set -euo pipefail

# ============================================================
# Lightweight English -> Arabic release/news phrasing
# ============================================================

translate_release_title_ar() {
    local source_label="$1"
    local title="$2"

    local t
    t="$(trim "$title")"

    # --------------------------------------------------------
    # NixOS
    # --------------------------------------------------------
    if [[ "$source_label" == "NixOS" ]]; then
        if [[ "$t" =~ ^NixOS[[:space:]]+([0-9]+\.[0-9]+)[[:space:]]+released$ ]]; then
            printf 'صدور NixOS %s\n' "${BASH_REMATCH[1]}"
            return 0
        fi
    fi

    # --------------------------------------------------------
    # Niri
    # --------------------------------------------------------
    if [[ "$source_label" == "Niri" ]]; then
        if [[ "$t" =~ ^Niri[[:space:]]+([0-9][^[:space:]]*)[[:space:]]+released$ ]]; then
            printf 'صدور Niri %s\n' "${BASH_REMATCH[1]}"
            return 0
        fi

        if [[ "$t" =~ ^Release[[:space:]]+([0-9][^[:space:]]*)$ ]]; then
            printf 'صدور إصدار جديد من Niri %s\n' "${BASH_REMATCH[1]}"
            return 0
        fi
    fi

    # --------------------------------------------------------
    # Hyprland
    # --------------------------------------------------------
    if [[ "$source_label" == "Hyprland" ]]; then
        if [[ "$t" =~ ^Hyprland[[:space:]]+([0-9][^[:space:]]*)[[:space:]]+released$ ]]; then
            printf 'صدور Hyprland %s\n' "${BASH_REMATCH[1]}"
            return 0
        fi
    fi

    # --------------------------------------------------------
    # Kotlin Multiplatform
    # --------------------------------------------------------
    if [[ "$source_label" == "Kotlin" ]]; then
        if [[ "$t" =~ ^Kotlin[[:space:]]+([0-9][^[:space:]]*)[[:space:]]+released$ ]]; then
            printf 'صدور Kotlin %s\n' "${BASH_REMATCH[1]}"
            return 0
        fi
    fi

    # --------------------------------------------------------
    # Generic patterns
    # --------------------------------------------------------
    if [[ "$t" =~ ^(.+)[[:space:]]+released$ ]]; then
        printf 'صدور %s\n' "${BASH_REMATCH[1]}"
        return 0
    fi

    if [[ "$t" =~ ^Release[[:space:]]+(.+)$ ]]; then
        printf 'إصدار جديد: %s\n' "${BASH_REMATCH[1]}"
        return 0
    fi

    # fallback: نعيد العنوان كما هو إذا لم نعرف نمطه
    printf '%s\n' "$t"
}

translate_summary_ar() {
    local source_label="$1"
    local summary="$2"

    summary="$(trim "$summary")"

    # حاليًا لا نترجم الملخص ترجمة فعلية
    # فقط نعيده كما هو إذا كان موجودًا.
    # لاحقًا يمكننا إضافة قاموس/قواعد أو خدمة ترجمة.
    printf '%s\n' "$summary"
}