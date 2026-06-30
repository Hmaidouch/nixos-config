#!/usr/bin/env bash

# ============================================================
# Reddit Library
# ============================================================

REDDIT_CACHE_MINUTES=60

fetch_reddit() {

    cache_set_source "reddit"

    # إذا الكاش صالح لا نجلب من الإنترنت
    if cache_exists && ! cache_expired; then
        return 0
    fi

    notify-send -t 1500 "$PROJECT_NAME" "Updating Reddit..."

    local url="https://api.pullpush.io/reddit/search/submission/?subreddit=${SUBREDDIT}&size=20&sort=desc&sort_type=created_utc"

    local response

    response=$(curl \
        --silent \
        --location \
        --fail \
        "$url") || {

        if cache_exists; then
            return 0
        fi

        notify-send "Reddit" "Unable to download posts"
        return 1
    }

    if ! echo "$response" | jq -e '.data[0]' >/dev/null; then

        if cache_exists; then
            return 0
        fi

        notify-send "Reddit" "No posts found"
        return 1
    fi

    echo "$response" |
        jq -r '
.data[] |
"\(.created_utc | strftime("%Y-%m-%d")) │ \(.title)"
' > "$TITLE_FILE"

    echo "$response" |
        jq -r '.data[] | "https://reddit.com" + .permalink' \
        > "$URL_FILE"

    echo "$response" |
        jq -r '.data[].created_utc' \
        > "$SOURCE_CACHE/date.txt"

    echo "$response" |
        jq -r '.data[].score' \
        > "$SOURCE_CACHE/score.txt"

    echo "$response" |
        jq -r '.data[].num_comments' \
        > "$SOURCE_CACHE/comments.txt"

}