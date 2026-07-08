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
    echo "${XDG_CACHE_HOME:-$HOME/.cache}/linux-updates/gemini"
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
• تم اكتشاف خبر جديد لكن لم أتمكن من توليد الملخص لأن مفتاح Gemini غير موجود.
• يمكنك فتح الرابط مباشرة لقراءة التفاصيل.

🔗 المصدر:
${url}"
        return 0
    fi

    if [[ -z "${content// }" ]]; then
        content="لا يوجد محتوى تفصيلي مرفق، اعتمد على العنوان ونوع المصدر فقط."
    fi

    local prompt
    prompt=$(cat <<EOF
أنت مساعد تقني يلخص أخبار لينكس والبرمجة بالعربية لمستخدم مهتم بـ:
NixOS و Niri و Hyprland و Kotlin Multiplatform و Compose Multiplatform.

المطلوب:
- لخص الخبر بالعربية الفصحى المبسطة.
- اجعل النتيجة مناسبة لرسالة تيليغرام.
- لا تكتب مقدمة إنشائية.
- ركز على: ما الجديد؟ ما الذي تغير؟ ولماذا قد يهم المطور أو مستخدم لينكس؟
- إذا كان الخبر مجرد tag أو release صغير بدون تفاصيل مهمة، فقل ذلك بوضوح.
- إذا كانت الملاحظات التقنية الموجودة في المحتوى مهمة، اذكرها بنقاط واضحة.
- إذا لم توجد معلومات كافية، اذكر ذلك بدل التخمين.
- لا تستعمل Markdown معقد، فقط نص واضح.

أخرج النتيجة بهذا الشكل فقط:

🟢 تحديث جديد من ${project}

📌 العنوان:
عنوان عربي واضح

📝 الخلاصة:
• نقطة أولى تشرح جوهر الخبر
• نقطة ثانية توضح ما الجديد أو ما تغير
• نقطة ثالثة تذكر لماذا قد يهم المستخدم
• أضف نقطة رابعة أو خامسة فقط إذا كانت هناك تفاصيل تقنية مهمة فعلًا
• إذا كان التحديث بسيطًا أو مجرد tag فاذكر ذلك بصراحة

🔗 المصدر:
${url}

بيانات الخبر:
- المشروع: ${project}
- المصدر: ${source}
- العنوان الأصلي: ${title}
- الرابط: ${url}

المحتوى الخام:
${content}
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
• تم اكتشاف خبر جديد لكن تعذر إنشاء الملخص عبر Gemini حاليًا.
• يمكنك فتح الرابط مباشرة لقراءة التفاصيل.

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