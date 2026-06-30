#!/usr/bin/env bash

# --- الإعدادات ---

# تحديد مسار ملف البيئة (تأكد من كتابة المسار الكامل لملفك)
ENV_FILE="$HOME/nixos-config/.env"

if [ -f "$ENV_FILE" ]; then
    source "$ENV_FILE"
    API_KEY="$GEMINI_API_KEY"
else
    # خيار بديل إذا كان السكريبت يعمل كخدمة نظام لا تصل للمجلد
    API_KEY=$(cat $HOME/.config/gemini_api.txt 2>/dev/null)
fi
MODEL="gemini-2.5-flash"
# تأكد من أن هذا المسار موجود وصحيح
CACHE_BASE="$HOME/.cache/waybar/reddit_ai/hyprland"
TITLE_FILE="$CACHE_BASE/titles.txt"
URL_FILE="$CACHE_BASE/urls.txt"
CACHE_MINUTES=60

mkdir -p "$CACHE_BASE"

# وظيفة جلب البيانات مع هوية متصفح قوية
fetch_reddit_data() {
    local url="https://api.pullpush.io/reddit/search/submission/?subreddit=Hyprland&size=15&sort=desc&sort_type=created_utc"
    local response=$(curl -s "$url")
    
    if [ -n "$response" ] && echo "$response" | jq '.' >/dev/null 2>&1; then
        if echo "$response" | jq -e '.data[0].title' > /dev/null 2>&1; then
            echo "$response" | jq -r '.data[].title' > "$TITLE_FILE.tmp"
            echo "$response" | jq -r '.data[] | "https://reddit.com" + .permalink' > "$URL_FILE.tmp"
            mv "$TITLE_FILE.tmp" "$TITLE_FILE"
            mv "$URL_FILE.tmp" "$URL_FILE"
            return 0
        fi
    fi
    return 1
}

# 1. التحقق من وجود الكاش أو تحديثه
if [ ! -s "$TITLE_FILE" ]; then
    notify-send -t 3000 "Hyprland News" "جاري محاولة التحميل الأولية..."
    if ! fetch_reddit_data; then
        notify-send -t 5000 "خطأ" "فشل التحميل: رديت رفض الطلب أو لا يوجد إنترنت"
        exit 1
    fi
else
    # تحديث في الخلفية إذا مر وقت طويل
    if test $(find "$TITLE_FILE" -mmin +$CACHE_MINUTES 2>/dev/null); then
        ( fetch_reddit_data ) &
    fi
fi

# قراءة البيانات
mapfile -t titles < "$TITLE_FILE"
mapfile -t urls < "$URL_FILE"

# عرض Rofi
choice=$(printf "%s\n" "${titles[@]}" | rofi -dmenu -i \
    -p " Hyprland News" \
    -kb-custom-1 "MouseSecondary" \
    -mesg "󰍽 [يسار]: AI شرح  |  󰍽 [يمين]: فتح رابط" \
    -config "$HOME/.config/rofi/themes/general_news.rasi")

exit_code=$?
[ -z "$choice" ] && exit 0

index=-1
for i in "${!titles[@]}"; do
    [[ "${titles[$i]}" == "$choice" ]] && index=$i && break
done
url="${urls[$index]}"

# بصمة فريدة للمقال
url_hash=$(echo -n "$url" | md5sum | awk '{print $1}')
SUMMARY_CACHE="$CACHE_BASE/${url_hash}.cache"

if [ $exit_code -eq 10 ]; then
    xdg-open "$url" & disown
else
    if [ -s "$SUMMARY_CACHE" ]; then
        RESPONSE=$(cat "$SUMMARY_CACHE")
        notify-send -t 2000 "Gemini AI" "تم التحميل من الكاش المحلي ⚡"
    else
        notify-send -t 3000 "Gemini AI" "جاري التحليل الجديد..."
        
        QUESTION="لخص هذا المنشور من رديت والتعليقات بالعربية: $url"
        JSON_PAYLOAD=$(jq -n --arg q "$QUESTION" '{contents: [{parts: [{text: $q}]}]}')

        API_RES=$(curl -s -X POST "https://generativelanguage.googleapis.com/v1/models/${MODEL}:generateContent?key=${API_KEY}" \
            -H 'Content-Type: application/json' -d "$JSON_PAYLOAD")
        
        RESPONSE=$(echo "$API_RES" | jq -r '.candidates[0].content.parts[0].text // ""')

        if [ -n "$RESPONSE" ] && [ "$RESPONSE" != "null" ]; then
            printf "%s\n" "$RESPONSE" > "$SUMMARY_CACHE"
            # تنظيف الكاش
            ls -1t "$CACHE_BASE"/*.cache 2>/dev/null | tail -n +16 | xargs -r rm -f
            notify-send -t 2000 "Gemini AI" "تم التحليل ✅"
        else
            ERROR_MSG=$(echo "$API_RES" | jq -r '.error.message // "خطأ غير معروف"')
            RESPONSE="⚠️ فشل الذكاء الاصطناعي: $ERROR_MSG"
        fi
    fi

# 1. نسخ النص الأصلي للحافظة (بدون وسوم)

#FORMATTED=$(echo "$RESPONSE" | fold -s -w 130)

    # 2. إضافة وسم RTL وتنسيق العرض في Rofi
    # استخدمنا dir='rtl' لإصلاح قلب الكلمات الإنجليزية داخل الجمل العربية
 #   RESPONSE_RTL="<span dir='rtl' font_desc='Vazirmatn 12'>$FORMATTED</span>"

 #   printf "%s\n" "$RESPONSE_RTL" | rofi -dmenu -i -p "🤖 AI Analysis" \
 #       -config "$HOME/.config/rofi/themes/ai_news.rasi" \
 #       -theme-str 'window {width: 54%; height: 90%;} listview {lines: 50; fixed-height: false;}'

   # FORMATTED=$(printf "%s" "$RESPONSE" | fold -s -w 120)
#printf "%s\n" "$FORMATTED" | rofi -dmenu -p "🤖 AI Analysis" -config "$HOME/.config/rofi/themes/ai_news.rasi" -theme-str 'window {width: 50%; height: 90%;} listview {lines: 18;}'

printf "%s\n" "$RESPONSE" | wl-copy

    # عرض النص في صندوق معلومات Zenity
    printf "%s" "$RESPONSE" | zenity --text-info --title="AI Analysis" --width=700 --height=600 --font="Vazirmatn 14"
fi