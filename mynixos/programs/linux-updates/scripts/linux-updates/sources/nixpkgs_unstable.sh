#!/usr/bin/env bash

set -euo pipefail

PROJECT_NAME="Nixpkgs Unstable"

fetch_latest() {
    local page_url="https://nixos.org/manual/nixpkgs/unstable/release-notes"
    local html
    local text
    local first_release
    local section
    local content_hash

    html=$(curl \
        --silent \
        --show-error \
        --fail \
        --location \
        "$page_url") || {
        echo "Failed to download Nixpkgs unstable release notes page" >&2
        return 1
    }

    # نحوّل الصفحة إلى نص بسيط سطر-بسطر
    text=$(printf "%s" "$html" |
        sed 's/<[^>]*>/\n/g' |
        sed 's/&quot;/"/g; s/&amp;/\&/g; s/&nbsp;/ /g' |
        sed 's/^[[:space:]]*//; s/[[:space:]]*$//' |
        sed '/^$/d')

    # أول سطر يطابق "Nixpkgs xx.xx" هو الإصدار unstable الحالي
    first_release=$(printf "%s\n" "$text" |
        grep -m1 -E '^Nixpkgs [0-9]{2}\.[0-9]{2}\b' || true)

    [[ -n "${first_release:-}" ]] || {
        echo "Failed to detect current unstable release title" >&2
        return 1
    }

    # نأخذ من أول عنوان الإصدار الحالي إلى قبل العنوان التالي Nixpkgs xx.xx
    section=$(printf "%s\n" "$text" | awk -v first="$first_release" '
        BEGIN {
            capture = 0
        }

        $0 == first {
            capture = 1
        }

        capture {
            if ($0 ~ /^Nixpkgs [0-9]{2}\.[0-9]{2}\b/ && $0 != first) {
                exit
            }
            print
        }
    ')

    [[ -n "${section// }" ]] || {
        echo "Failed to extract unstable section" >&2
        return 1
    }

    NEWS_URL="$page_url"
    NEWS_SOURCE="nixpkgs_unstable_release_notes"
    NEWS_TITLE="$first_release"

    NEWS_CONTENT=$(printf "%s\n" "$section" | head -c 20000)

    [[ -n "${NEWS_CONTENT// }" ]] || {
        echo "Failed to extract unstable release notes text" >&2
        return 1
    }

    content_hash=$(printf "%s" "$NEWS_CONTENT" | md5sum | awk '{print $1}')
    NEWS_ID="${page_url}#${first_release}#${content_hash}"

    return 0
}