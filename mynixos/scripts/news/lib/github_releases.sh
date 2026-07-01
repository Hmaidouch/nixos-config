#!/usr/bin/env bash

# ============================================================
# GitHub Releases Library
# ============================================================

fetch_releases() {

    cache_set_source "releases"

    # استخدم الكاش إذا كان صالحًا
    if cache_exists && ! cache_expired; then
        return 0
    fi

    ui_notify "$PROJECT_NAME" "Updating Releases..."

    local response

    response=$(github_releases) || {

        if cache_exists; then
            return 0
        fi

        ui_error "Unable to fetch GitHub releases."
        return 1
    }

    if ! echo "$response" | jq -e '.[0]' >/dev/null; then

        if cache_exists; then
            return 0
        fi

        ui_error "No releases found."
        return 1
    fi

    # حفظ JSON كاملاً
    printf "%s\n" "$response" > "$SOURCE_CACHE/releases.json"

    # إنشاء ملفات تستخدمها ui.sh
    echo "$response" |
        jq -r '
.[] |
(if .prerelease
 then "🧪"
 else "🚀"
 end)
+ " "
+ .published_at[0:10]
+ " | "
+ .name
' > "$TITLE_FILE"

    echo "$response" |
        jq -r '.[].html_url' \
        > "$URL_FILE"

    echo "$response" |
        jq -r '.[].published_at' \
        > "$SOURCE_CACHE/date.txt"

    echo "$response" |
        jq -r '.[].tag_name' \
        > "$SOURCE_CACHE/tag.txt"

    echo "$response" |
        jq -r '.[].prerelease' \
        > "$SOURCE_CACHE/prerelease.txt"

    echo "$response" |
        jq -r '.[].draft' \
        > "$SOURCE_CACHE/draft.txt"

    return 0
}