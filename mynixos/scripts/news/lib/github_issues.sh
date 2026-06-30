#!/usr/bin/env bash

# ============================================================
# GitHub Issues Library
# ============================================================

fetch_issues() {

    cache_set_source "issues"

    # استخدام الكاش إذا كان صالحًا
    if cache_exists && ! cache_expired; then
        return 0
    fi

    ui_notify "$PROJECT_NAME" "Updating Issues..."

    local response

    response=$(github_issues) || {

        if cache_exists; then
            return 0
        fi

        ui_error "Unable to fetch GitHub issues."
        return 1
    }

    if ! echo "$response" | jq -e '.[0]' >/dev/null; then

        if cache_exists; then
            return 0
        fi

        ui_error "No issues found."
        return 1
    fi

    # حفظ JSON الكامل
    printf "%s\n" "$response" > "$SOURCE_CACHE/issues.json"

    # الملفات التي يحتاجها ui.sh
    echo "$response" |
        jq -r '.[] |
            if .state=="open"
            then "🐞 #\(.number) - \(.title)"
            else "✅ #\(.number) - \(.title)"
            end' \
        > "$TITLE_FILE"

    echo "$response" |
        jq -r '.[].html_url' \
        > "$URL_FILE"

    echo "$response" |
        jq -r '.[].state' \
        > "$SOURCE_CACHE/state.txt"

    echo "$response" |
        jq -r '.[].comments' \
        > "$SOURCE_CACHE/comments.txt"

    echo "$response" |
        jq -r '.[].created_at' \
        > "$SOURCE_CACHE/date.txt"

    echo "$response" |
        jq -r '.[].number' \
        > "$SOURCE_CACHE/number.txt"

    return 0
}