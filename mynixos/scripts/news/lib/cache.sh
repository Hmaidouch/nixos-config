#!/usr/bin/env bash

# ============================================================
# Cache Library
# ============================================================

CACHE_MINUTES=60

# إنشاء مجلد الكاش إن لم يكن موجوداً
cache_init() {
    mkdir -p "$CACHE_BASE"
}

# أسماء ملفات الكاش الخاصة بالمصدر الحالي
cache_set_source() {
    local source="$1"

    SOURCE_CACHE="$CACHE_BASE/$source"

    mkdir -p "$SOURCE_CACHE"

    TITLE_FILE="$SOURCE_CACHE/titles.txt"
    URL_FILE="$SOURCE_CACHE/urls.txt"
}

# هل ملفات الكاش موجودة؟
cache_exists() {
    [[ -s "$TITLE_FILE" && -s "$URL_FILE" ]]
}

# هل انتهت صلاحية الكاش؟
cache_expired() {
    find "$TITLE_FILE" -mmin +"$CACHE_MINUTES" | grep -q .
}

# حفظ القوائم
cache_save_lists() {
    local titles_tmp="$TITLE_FILE.tmp"
    local urls_tmp="$URL_FILE.tmp"

    cat > "$titles_tmp"
    mv "$titles_tmp" "$TITLE_FILE"

    cat > "$urls_tmp"
    mv "$urls_tmp" "$URL_FILE"
}

# حذف كاش مصدر معين
cache_clear_source() {
    rm -rf "$SOURCE_CACHE"
}

# حذف جميع الكاش
cache_clear_all() {
    rm -rf "$CACHE_BASE"
}

# ============================================================
# Gemini Cache
# ============================================================

gemini_cache_file() {
    local url="$1"

    local hash
    hash=$(printf "%s" "$url" | md5sum | awk '{print $1}')

    echo "$CACHE_BASE/gemini/${hash}.cache"
}

gemini_cache_init() {
    mkdir -p "$CACHE_BASE/gemini"
}

gemini_cache_read() {
    local file
    file=$(gemini_cache_file "$1")

    [[ -s "$file" ]] && cat "$file"
}

gemini_cache_write() {
    local file
    file=$(gemini_cache_file "$1")

    printf "%s\n" "$2" > "$file"
}

gemini_cache_cleanup() {
    ls -1t "$CACHE_BASE"/gemini/*.cache 2>/dev/null \
        | tail -n +16 \
        | xargs -r rm -f
}