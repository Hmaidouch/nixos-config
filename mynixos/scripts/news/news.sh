#!/usr/bin/env bash

set -euo pipefail

# ============================================================
# Directories
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$SCRIPT_DIR/lib"

CACHE_BASE="$HOME/.cache/waybar/news/$CACHE_ID"
mkdir -p "$CACHE_BASE"

# ============================================================
# Load libraries
# ============================================================

source "$LIB_DIR/cache.sh"
source "$LIB_DIR/ui.sh"
source "$LIB_DIR/reddit.sh"
source "$SCRIPT_DIR/lib/github_api.sh"
source "$SCRIPT_DIR/lib/github_releases.sh"
source "$SCRIPT_DIR/lib/github_issues.sh"
source "$SCRIPT_DIR/lib/github_commits.sh"
source "$LIB_DIR/gemini.sh"

# ============================================================
# Load Gemini API Key
# ============================================================

ENV_FILE="$HOME/nixos-config/.env"

if [[ -f "$ENV_FILE" ]]; then
    source "$ENV_FILE"
    API_KEY="$GEMINI_API_KEY"
else
    API_KEY=$(cat "$HOME/.config/gemini_api.txt" 2>/dev/null || true)
fi

if [[ -z "${API_KEY:-}" ]]; then
    notify-send "Gemini" "API Key not found"
    exit 1
fi

# ============================================================
# Choose Source
# ============================================================

SOURCE=$(printf "%s\n" \
"📰 Reddit" \
"🚀 GitHub Releases" \
"📝 GitHub Commits" \
"🐞 GitHub Issues" | rofi -dmenu \
        -i \
        -p "$PROJECT_ICON $PROJECT_NAME" \
        -config "$HOME/.config/rofi/themes/general_news.rasi")

[[ -z "$SOURCE" ]] && exit 0

# ============================================================
# Fetch data
# ============================================================

case "$SOURCE" in

"📰 Reddit")
    fetch_reddit
    ;;

"🚀 GitHub Releases")
    fetch_releases
    ;;

"📝GitHub Commits")
    fetch_commits
    ;;

"🐞 GitHub Issues")
    fetch_issues
    ;;

*)
    exit 0
    ;;
esac

# ============================================================
# Read cache
# ============================================================

mapfile -t titles < "$TITLE_FILE"
mapfile -t urls < "$URL_FILE"

choice=$(printf "%s\n" "${titles[@]}" |
    rofi -dmenu \
    -i \
    -p "$SOURCE" \
    -kb-custom-1 MouseSecondary \
    -mesg "🖱 Left : Gemini Summary    |    Right : Open Link" \
    -config "$HOME/.config/rofi/themes/general_news.rasi")

exit_code=$?

[[ -z "$choice" ]] && exit 0

index=-1

for i in "${!titles[@]}"
do
    [[ "${titles[$i]}" == "$choice" ]] && index=$i && break
done

[[ $index -lt 0 ]] && exit 1

URL="${urls[$index]}"

# ============================================================
# Right Click
# ============================================================

if [[ $exit_code -eq 10 ]]; then
    xdg-open "$URL" &
    disown
    exit 0
fi

# ============================================================
# Gemini Summary
# ============================================================

summarize_url "$URL"

printf "%s\n" "$SUMMARY" | wl-copy

printf "%s" "$SUMMARY" | zenity \
        --text-info \
        --title="$PROJECT_NAME AI" \
        --width=750 \
        --height=650 \
        --font="Vazirmatn 14"