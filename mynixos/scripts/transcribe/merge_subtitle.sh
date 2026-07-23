#!/usr/bin/env bash

set -euo pipefail

VIDEO_DIR="$HOME/Videos/ToSubtitle"

shopt -s nullglob

for video in "$VIDEO_DIR"/*.mp4; do

    base="${video%.mp4}"
    subtitle="${base}.ar.srt"

    [[ -f "$subtitle" ]] || {
        echo "Missing subtitle:"
        echo "$subtitle"
        continue
    }

    output="${base}.subtitled.mp4"

    [[ -f "$output" ]] && {
        echo "Already exists:"
        echo "$output"
        continue
    }

    echo
    echo "==========================="
    echo "Embedding subtitle..."
    echo "$(basename "$video")"
    echo "==========================="

    ffmpeg \
        -i "$video" \
        -i "$subtitle" \
        -map 0 \
        -map 1 \
        -c copy \
        -c:s mov_text \
        -metadata:s:s:0 language=ara \
        "$output"

    echo
    echo "Created:"
    echo "$output"

done

echo
echo "Done."

read -n1