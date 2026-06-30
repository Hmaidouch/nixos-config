#!/usr/bin/env bash

# ============================================================
# GitHub Tags Library
# ============================================================

fetch_tags() {

    cache_set_source "tags"

    # استعمال الكاش إذا كان صالحاً
    if cache_exists && ! cache_expired; then
        return 0
    fi

    ui_notify "$PROJECT_NAME" "Updating Tags..."

    local response

    response=$(github_tags) || {

        if cache_exists; then
            return 0
        fi

        ui_error "Unable to fetch GitHub tags."
        return 1
    }

    if ! echo "$response" | jq -e '.[0]' >/dev/null; then

        if cache_exists; then
            return 0
        fi

        ui_error "No tags found."
        return 1
    fi

    # حفظ JSON الكامل
    printf "%s\n" "$response" \
        > "$SOURCE_CACHE/tags.json"

    # أسماء الـ Tags
    echo "$response" |
        jq -r '
.[] |
"🏷 "
+ .name
' > "$TITLE_FILE"

    # روابط GitHub الخاصة بالـ Tag
    echo "$response" |
        jq -r \
        --arg owner "$GITHUB_OWNER" \
        --arg repo "$GITHUB_REPO" \
        '.[] |
        "https://github.com/\($owner)/\($repo)/tree/\(.name)"' \
        > "$URL_FILE"

    # SHA الكامل
    echo "$response" |
        jq -r '.[] |
            .commit.sha' \
        > "$SOURCE_CACHE/sha.txt"

    return 0
}