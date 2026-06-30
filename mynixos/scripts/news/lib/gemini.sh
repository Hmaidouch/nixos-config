#!/usr/bin/env bash

# ============================================================
# Gemini Library
# ============================================================

summarize_url() {

    local url="$1"

    gemini_cache_init

    SUMMARY=""

    # --------------------------------------------------------
    # Cache
    # --------------------------------------------------------

    local cache_file
    cache_file=$(gemini_cache_file "$url")

    if [[ -s "$cache_file" ]]; then
        SUMMARY=$(cat "$cache_file")
        notify-send -t 1500 "Gemini" "Loaded from cache ⚡"
        return 0
    fi

    # --------------------------------------------------------
    # Prompt
    # --------------------------------------------------------

    local question="
اقرأ هذا الرابط ثم لخصه بالعربية.

أريد:

• عنوان المقال.
• الفكرة الرئيسية.
• أهم النقاط.
• أهم ما جاء في التعليقات.
• إذا كان هناك حل أو إجماع من المستخدمين فاذكره.

الرابط:
$url
"

    local payload

    payload=$(jq -n \
        --arg text "$question" \
        '{
            contents: [
                {
                    parts: [
                        {
                            text: $text
                        }
                    ]
                }
            ]
        }')

    notify-send -t 1500 "Gemini" "Generating summary..."

    # --------------------------------------------------------
    # API
    # --------------------------------------------------------

    local response

    response=$(curl \
        --silent \
        --fail \
        --request POST \
        "https://generativelanguage.googleapis.com/v1/models/${MODEL}:generateContent?key=${API_KEY}" \
        -H "Content-Type: application/json" \
        -d "$payload")

    SUMMARY=$(echo "$response" |
        jq -r '.candidates[0].content.parts[0].text // empty')

    # --------------------------------------------------------
    # Error
    # --------------------------------------------------------

    if [[ -z "$SUMMARY" ]]; then

        local error

        error=$(echo "$response" |
            jq -r '.error.message // "Unknown error"')

        SUMMARY="⚠️ Gemini Error

$error"

        return 1
    fi

    # --------------------------------------------------------
    # Save Cache
    # --------------------------------------------------------

    printf "%s\n" "$SUMMARY" > "$cache_file"

    gemini_cache_cleanup

    notify-send -t 1500 "Gemini" "Summary saved ✓"

    return 0
}