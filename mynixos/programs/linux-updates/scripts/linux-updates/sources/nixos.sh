#!/usr/bin/env bash

set -euo pipefail

PROJECT_NAME="NixOS"

fetch_latest() {
    local feed_url="https://nixos.org/blog/announcements-rss.xml"
    local matched
    local PYTHON_BIN=""

    PYTHON_BIN="$(find_python3)" || {
        echo "python3 not found" >&2
        return 1
    }

    matched=$(
        "$PYTHON_BIN" - "$feed_url" <<'PY'
import sys
import re
import html
import urllib.request
import xml.etree.ElementTree as ET

feed_url = sys.argv[1]

def clean_html(text: str) -> str:
    if not text:
        return ""
    text = html.unescape(text)
    text = re.sub(r"<[^>]+>", " ", text)
    text = re.sub(r"\s+", " ", text).strip()
    return text

with urllib.request.urlopen(feed_url) as r:
    xml_data = r.read()

root = ET.fromstring(xml_data)

# namespace الخاص بـ content:encoded
ns = {
    "content": "http://purl.org/rss/1.0/modules/content/"
}

channel = root.find("channel")
if channel is None:
    sys.exit(1)

items = channel.findall("item")
if not items:
    sys.exit(1)

# أول item في RSS هو الأحدث
item = items[0]

title = (item.findtext("title") or "").strip()
link = (item.findtext("link") or "").strip()

content_encoded = item.findtext("{http://purl.org/rss/1.0/modules/content/}encoded") or ""
description = item.findtext("description") or ""

content = content_encoded if content_encoded.strip() else description
content = clean_html(content)

print(title)
print(link)
print(content)
PY
    )

    [[ -n "${matched:-}" ]] || {
        echo "Failed to parse NixOS RSS feed" >&2
        return 1
    }

    NEWS_TITLE=$(printf "%s\n" "$matched" | sed -n '1p')
    NEWS_URL=$(printf "%s\n" "$matched" | sed -n '2p')
    NEWS_CONTENT=$(printf "%s\n" "$matched" | sed -n '3,$p')

    [[ -n "${NEWS_TITLE:-}" ]] || return 1
    [[ -n "${NEWS_URL:-}" ]] || return 1
    [[ -n "${NEWS_CONTENT:-}" ]] || return 1

    NEWS_ID="$NEWS_URL"
    NEWS_SOURCE="announcements_rss"

    return 0
}