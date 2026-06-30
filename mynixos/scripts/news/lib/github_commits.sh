#!/usr/bin/env bash

# ============================================================
# GitHub Commits Library
# ============================================================

fetch_commits() {

    cache_set_source "commits"

    # استعمال الكاش إذا كان صالحاً
    if cache_exists && ! cache_expired; then
        return 0
    fi

    ui_notify "$PROJECT_NAME" "Updating Commits..."

    local response

    response=$(github_commits) || {

        if cache_exists; then
            return 0
        fi

        ui_error "Unable to fetch GitHub commits."
        return 1
    }

    if ! echo "$response" | jq -e '.[0]' >/dev/null; then

        if cache_exists; then
            return 0
        fi

        ui_error "No commits found."
        return 1
    fi

    # حفظ JSON الكامل
    printf "%s\n" "$response" \
        > "$SOURCE_CACHE/commits.json"

    # عناوين القائمة
    echo "$response" |
        jq -r '.[] |
            "📝 \(.commit.message | split("\n")[0])"' \
        > "$TITLE_FILE"

    # روابط GitHub
    echo "$response" |
        jq -r '.[].html_url' \
        > "$URL_FILE"

    # اسم الكاتب
    echo "$response" |
        jq -r '.[] |
            (.commit.author.name // "Unknown")' \
        > "$SOURCE_CACHE/author.txt"

    # تاريخ الـ Commit
    echo "$response" |
        jq -r '.[] |
            .commit.author.date' \
        > "$SOURCE_CACHE/date.txt"

    # SHA المختصر
    echo "$response" |
        jq -r '.[] |
            .sha[0:7]' \
        > "$SOURCE_CACHE/sha.txt"

    return 0
}