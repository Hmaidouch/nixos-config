#!/usr/bin/env bash

set -euo pipefail

PROJECT_NAME="Kotlin Multiplatform"

fetch_latest() {
    local PYTHON_BIN=""
    PYTHON_BIN="$(find_python3)" || {
        echo "python3 not found" >&2
        return 1
    }

    local matched=""
    matched=$(
        "$PYTHON_BIN" - <<'PY'
import re
import sys
import html
import urllib.request
import xml.etree.ElementTree as ET

FEEDS = [
    "https://blog.jetbrains.com/kotlin/feed/",
    "https://blog.jetbrains.com/kotlin/category/releases/feed/",
]

KEYWORDS = [
    # KMP / Compose MP
    "kotlin multiplatform",
    "multiplatform",
    "kmp",
    "compose multiplatform",
    "compose for ios",
    "compose for desktop",
    "compose for web",

    # Kotlin releases / toolchain / wasm
    "kotlin release",
    "kotlin 2.",
    "kotlin 1.9",
    "kotlin/wasm",
    "kotlin wasm",
    "wasm",
]

def clean_html(text: str) -> str:
    if not text:
        return ""
    text = html.unescape(text)
    text = re.sub(r"<[^>]+>", " ", text)
    text = re.sub(r"\s+", " ", text).strip()
    return text

def score_entry(title: str, desc: str, link: str) -> int:
    haystack = f"{title} {desc} {link}".lower()
    score = 0

    # استبعاد المقالات التجميعية/النشرات لأنها ليست خبرًا مباشرًا
    weak_patterns = [
        "roundup",
        "weekly",
        "monthly",
        "newsletter",
        "recap",
        "highlights",
        "kodee’s kotlin roundup",
        "kodee's kotlin roundup",
    ]
    for w in weak_patterns:
        if w in haystack:
            score -= 20

    # إشارات قوية جدًا
    strong = [
        "kotlin multiplatform",
        "compose multiplatform",
        "kotlin release",
        "kotlin 2.",
    ]
    for k in strong:
        if k in haystack:
            score += 10

    # إشارات متوسطة
    medium = [
        "multiplatform",
        "kmp",
        "kotlin/wasm",
        "kotlin wasm",
        "compose for ios",
        "compose for desktop",
        "compose for web",
        "wasm",
    ]
    for k in medium:
        if k in haystack:
            score += 3

    # أولوية إضافية إذا كان المقال نفسه release أو roadmap أو announcement
    priority_words = [
        "release",
        "released",
        "announcement",
        "now available",
        "stable",
        "beta",
        "rc",
    ]
    for p in priority_words:
        if p in haystack:
            score += 2

    if "/releases/" in link:
        score += 3

    return score

candidates = []

for feed_url in FEEDS:
    try:
        with urllib.request.urlopen(feed_url) as r:
            xml_data = r.read()
    except Exception:
        continue

    try:
        root = ET.fromstring(xml_data)
    except Exception:
        continue

    channel = root.find("channel")
    if channel is None:
        continue

    items = channel.findall("item")

    for idx, item in enumerate(items[:30]):
        title = (item.findtext("title") or "").strip()
        link = (item.findtext("link") or "").strip()
        desc_raw = item.findtext("description") or ""
        desc = clean_html(desc_raw)

        haystack = f"{title} {desc} {link}".lower()

        # فلترة أولية: لازم يوجد شيء له علاقة
        if not any(k in haystack for k in KEYWORDS):
            continue

        score = score_entry(title, desc, link)
        if score <= 0:
            continue

        candidates.append({
            "title": title,
            "link": link,
            "desc": desc,
            "score": score,
            "feed": feed_url,
            "index": idx,   # الأقدم index أكبر داخل نفس feed غالبًا
        })

if not candidates:
    print("", end="")
    sys.exit(0)

# نرتب حسب:
# 1) score الأعلى
# 2) ثم الظهور الأقرب لبداية الـ feed (غالبًا الأحدث)
candidates.sort(key=lambda x: (-x["score"], x["index"]))

best = candidates[0]
print(best["title"])
print(best["link"])
print(best["desc"])
PY
    )

    [[ -n "${matched:-}" ]] || {
        echo "No matching Kotlin Multiplatform news found" >&2
        return 1
    }

    NEWS_TITLE=$(printf "%s\n" "$matched" | sed -n '1p')
    NEWS_URL=$(printf "%s\n" "$matched" | sed -n '2p')
    NEWS_CONTENT=$(printf "%s\n" "$matched" | sed -n '3,$p' | tr '\n' ' ')

    [[ -n "${NEWS_TITLE:-}" ]] || return 1
    [[ -n "${NEWS_URL:-}" ]] || return 1

    NEWS_ID="$NEWS_URL"
    NEWS_SOURCE="jetbrains_kotlin_blog"

    return 0
}