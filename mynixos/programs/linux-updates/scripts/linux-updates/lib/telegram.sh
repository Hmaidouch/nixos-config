#!/usr/bin/env bash

set -euo pipefail

telegram_send_message() {
    local text="$1"

    [[ -n "${TELEGRAM_BOT_TOKEN:-}" ]] || {
        echo "TELEGRAM_BOT_TOKEN is missing" >&2
        return 1
    }

    [[ -n "${TELEGRAM_CHAT_ID:-}" ]] || {
        echo "TELEGRAM_CHAT_ID is missing" >&2
        return 1
    }

    curl \
        --silent \
        --show-error \
        --fail \
        --request POST \
        "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
        --data-urlencode "chat_id=${TELEGRAM_CHAT_ID}" \
        --data-urlencode "text=${text}" \
        --data-urlencode "disable_web_page_preview=true" \
        > /dev/null
}