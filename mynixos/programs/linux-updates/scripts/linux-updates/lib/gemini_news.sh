#!/usr/bin/env bash

set -euo pipefail

# ============================================================
# Gemini News Summary Library
# ============================================================

GEMINI_MODEL="${GEMINI_MODEL:-gemini-2.5-flash}"

# ------------------------------------------------------------
# API key
# ------------------------------------------------------------

gemini_load_api_key() {
    if [[ -n "${GEMINI_API_KEY:-}" ]]; then
        return 0
    fi

    local env_file="$HOME/nixos-config/.env"

    if [[ -f "$env_file" ]]; then
        # shellcheck disable=SC1090
        source "$env_file"
    fi

    [[ -n "${GEMINI_API_KEY:-}" ]]
}

# ------------------------------------------------------------
# Cache
# ------------------------------------------------------------

summary_cache_dir() {
    echo "$CACHE_DIR/gemini"
}

summary_cache_init() {
    mkdir -p "$(summary_cache_dir)"
}

summary_cache_file() {
    local key="$1"

    local hash
    hash=$(printf "%s" "$key" | md5sum | awk '{print $1}')

    echo "$(summary_cache_dir)/${hash}.txt"
}

summary_cache_read() {
    local key="$1"
    local file

    file=$(summary_cache_file "$key")

    [[ -s "$file" ]] && cat "$file"
}

summary_cache_write() {
    local key="$1"
    local content="$2"
    local file

    file=$(summary_cache_file "$key")

    printf "%s\n" "$content" > "$file"
}

summary_cache_cleanup() {
    ls -1t "$(summary_cache_dir)"/*.txt 2>/dev/null \
        | tail -n +31 \
        | xargs -r rm -f
}

# ------------------------------------------------------------
# Helpers
# ------------------------------------------------------------

truncate_content() {
    local text="$1"
    local max_chars="${2:-12000}"

    if (( ${#text} > max_chars )); then
        printf "%s" "${text:0:max_chars}"
    else
        printf "%s" "$text"
    fi
}

# ------------------------------------------------------------
# Summarize
# ------------------------------------------------------------

summarize_linux_news() {
    local project="$1"
    local source="$2"
    local title="$3"
    local url="$4"
    local content="$5"

    SUMMARY=""

    summary_cache_init

    local cache_key="${project}|${source}|${title}|${url}"
    local cached=""

    cached=$(summary_cache_read "$cache_key" || true)

    if [[ -n "$cached" ]]; then
        SUMMARY="$cached"
        return 0
    fi

    if ! gemini_load_api_key; then
        SUMMARY="🟢 تحديث جديد من ${project}

📌 العنوان:
${title}

📝 الخلاصة:
• تعذر توليد الملخص لأن مفتاح Gemini غير موجود.
• يمكنك مراجعة الرابط مباشرة لمعرفة التفاصيل.

🔗 المصدر:
${url}"
        return 0
    fi

    if [[ -z "${content// }" ]]; then
        content="لا يوجد محتوى تفصيلي مرفق، اعتمد على العنوان ونوع المصدر فقط."
    fi

    # نقصّ المحتوى لو كان كبيرًا جدًا
    local content_for_ai
    content_for_ai="$(truncate_content "$content" 12000)"

    local prompt
    prompt=$(cat <<EOF
أنت مساعد تقني متخصص في تلخيص أخبار لينكس والمشاريع البرمجية بالعربية.

المطلوب:
أعطِني ملخصًا عربيًا واضحًا وغنيًا نسبيًا لرسالة تيليغرام، بناءً على محتوى الخبر أدناه.

قواعد مهمة جدًا:
- اكتب بالعربية الفصحى المبسطة.
- لا تترجم حرفيًا من الإنجليزية.
- لا تكتب مقدمة إنشائية.
- لا تكتب "إليك الملخص" أو "بالتأكيد".
- لا تكرر العنوان داخل الخلاصة.
- ركز على المعلومة العملية: ما الجديد؟ ما الذي تغير؟ لماذا الخبر مهم؟
- إذا كان الخبر إصدارًا جديدًا، فاذكر:
  1) اسم الإصدار
  2) أهم التغييرات أو النقاط المذكورة
  3) مدة الدعم إن وُجدت
  4) أي تحذير أو ملاحظة مهمة
- إذا كان الخبر commit أو tag أو issue بسيط، فقل ذلك بوضوح ولا تضخمه.
- إذا كانت المعلومات المتاحة قليلة، اذكر ذلك صراحة بدل اختراع تفاصيل.
- لا تستخدم Markdown معقد.
- اجعل الخلاصة أغنى من مجرد 3 أسطر عامة، لكن بدون إطالة مملة.

أخرج النتيجة بهذا الشكل فقط:

🟢 تحديث جديد من ${project}

📌 العنوان:
عنوان عربي واضح ومختصر

📝 الخلاصة:
• نقطة أولى مفيدة
• نقطة ثانية مفيدة
• نقطة ثالثة مفيدة
• نقطة رابعة مفيدة إذا وجدت
• نقطة خامسة إذا كان الخبر مهمًا فعلًا ويستحق

📎 لماذا قد يهمك:
سطر أو سطران كحد أقصى يوضحان لماذا هذا الخبر مهم لمستخدم هذا المشروع.

🔗 المصدر:
${url}

بيانات الخبر:
- المشروع: ${project}
- المصدر: ${source}
- العنوان الأصلي: ${title}
- الرابط: ${url}

المحتوى الخام للخبر:
${content_for_ai}
EOF
)

    local payload
    payload=$(jq -n \
        --arg text "$prompt" \
        '{
            contents: [
                {
                    parts: [
                        { text: $text }
                    ]
                }
            ]
        }')

    local response
    response=$(curl \
        --silent \
        --show-error \
        --fail \
        --request POST \
        "https://generativelanguage.googleapis.com/v1/models/${GEMINI_MODEL}:generateContent?key=${GEMINI_API_KEY}" \
        -H "Content-Type: application/json" \
        -d "$payload") || {

        SUMMARY="🟢 تحديث جديد من ${project}

📌 العنوان:
${title}

📝 الخلاصة:
• تعذر إنشاء الملخص عبر Gemini حاليًا.
• لكن تم اكتشاف خبر جديد ويمكنك فتح الرابط مباشرة لمعرفة التفاصيل.

🔗 المصدر:
${url}"
        return 0
    }

    SUMMARY=$(echo "$response" |
        jq -r '.candidates[0].content.parts[0].text // empty')

    if [[ -z "$SUMMARY" ]]; then
        SUMMARY="🟢 تحديث جديد من ${project}

📌 العنوان:
${title}

📝 الخلاصة:
• وصل خبر جديد لكن لم أتمكن من استخراج ملخص عربي من Gemini.
• يمكنك فتح الرابط مباشرة لقراءة التفاصيل.

🔗 المصدر:
${url}"
        return 0
    fi

    summary_cache_write "$cache_key" "$SUMMARY"
    summary_cache_cleanup

    return 0
}