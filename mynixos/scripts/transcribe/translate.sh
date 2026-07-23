#!/usr/bin/env bash

set -euo pipefail

VIDEO_DIR="$HOME/Videos/ToSubtitle"
ENV_FILE="$HOME/nixos-config/.env"

source "$ENV_FILE"

if [[ -z "${GEMINI_API_KEY:-}" ]]; then
    echo "Missing GEMINI_API_KEY"
    read -n1
    exit 1
fi

#SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

for srt in "$VIDEO_DIR"/*.srt; do

    [[ -f "$srt" ]] || continue

    [[ "$srt" == *.ar.srt ]] && continue

    out="${srt%.srt}.ar.srt"

    [[ -f "$out" ]] && continue

    echo
    echo "================================"
    echo "Translating $(basename "$srt")"
    echo "================================"

    #python3 "$SCRIPT_DIR/translate_srt.py" \
    python3 "$HOME/nixos-config/mynixos/scripts/transcribe/translate_srt.py" \
        "$srt" \
        "$out" \
        "$GEMINI_API_KEY"

done

echo
echo "Done."

read -n1