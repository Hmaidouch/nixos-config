#!/usr/bin/env bash

set -euo pipefail

VIDEO_DIR="$HOME/Videos/ToSubtitle"
ENV_FILE="$HOME/nixos-config/.env"
#SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ ! -f "$ENV_FILE" ]]; then
    echo ".env not found:"
    echo "$ENV_FILE"
    read -n1
    exit 1
fi

source "$ENV_FILE"

if [[ -z "${GROQ_API_KEY:-}" ]]; then
    echo "GROQ_API_KEY not found."
    read -n1
    exit 1
fi

video=$(find "$VIDEO_DIR" -maxdepth 1 \
    \( -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.webm" -o -iname "*.mov" \) \
    | head -n1)

if [[ -z "$video" ]]; then
    echo "No video found."
    read -n1
    exit 0
fi

base="${video%.*}"
audio="${base}.wav"

echo
echo "=============================="
echo "Video:"
echo "$video"
echo "=============================="
echo

echo "Extracting audio..."

ffmpeg -y \
    -i "$video" \
    -vn \
    -ac 1 \
    -ar 16000 \
    "$audio"

echo
echo "Uploading to Groq..."

curl https://api.groq.com/openai/v1/audio/transcriptions \
    -s \
    -H "Authorization: Bearer $GROQ_API_KEY" \
    -F file=@"$audio" \
    -F model=whisper-large-v3 \
    -F response_format=verbose_json \
    > "${base}.json"

echo
echo "Generating subtitles..."

python3 "$HOME/nixos-config/mynixos/scripts/transcribe/json_to_srt.py" \
    "${base}.json"


rm "$audio"

echo
echo "Finished."

read -n1