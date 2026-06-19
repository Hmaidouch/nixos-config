#!/usr/bin/env bash

# إعدادات الموقع والملفات
CITY="Djelfa"
COUNTRY="Algeria"
CACHE_FILE="/tmp/prayer_times.json"
TODAY=$(date +%Y-%m-%d)

# 1. التحقق: هل نحتاج لتحميل البيانات؟ 
# نقوم بالتحميل فقط إذا كان الملف غير موجود أو إذا كان تاريخه قديماً (ليس اليوم)
if [ ! -f "$CACHE_FILE" ] || [ "$(date -r "$CACHE_FILE" +%Y-%m-%d)" != "$TODAY" ]; then
    # محاولة التحميل مرة واحدة فقط
    curl -sL "http://api.aladhan.com/v1/timingsByCity?city=$CITY&country=$COUNTRY&method=3" -o "$CACHE_FILE"
fi

# 2. قراءة البيانات من الملف المحلي
DATA=$(cat "$CACHE_FILE")

# التأكد من نجاح القراءة
if [ -z "$DATA" ] || [ "$(echo "$DATA" | jq -r '.code')" != "200" ]; then
    echo "خطأ في البيانات"
    rm -f "$CACHE_FILE" # حذف الملف الفاشل للمحاولة لاحقاً
    exit 1
fi

# 3. حساب الوقت المتبقي (نفس المنطق السابق)
NOW=$(date +%s)
PRAYERS=("Fajr" "Dhuhr" "Asr" "Maghrib" "Isha")
NAMES=("الفجر" "الظهر" "العصر" "المغرب" "العشاء")

for i in "${!PRAYERS[@]}"; do
    P_TIME=$(echo "$DATA" | jq -r ".data.timings.${PRAYERS[$i]}")
    P_EPOCH=$(date -d "$TODAY $P_TIME" +%s)

   # if [ $P_EPOCH -gt $NOW ]; then
   #     DIFF=$(( (P_EPOCH - NOW) / 60 ))
   #     if [ $DIFF -ge 60 ]; then
   #         echo "${NAMES[$i]} بعد $((DIFF / 60)) س و $((DIFF % 60)) د"
   #     else
   #         echo "${NAMES[$i]} بعد $DIFF دقيقة"
   #     fi
   #     exit 0
   # fi

    if [ $P_EPOCH -gt $NOW ]; then
        DIFF=$(( (P_EPOCH - NOW) / 60 ))
        
        # الشرط الجديد: الإظهار فقط إذا كان الوقت المتبقي أقل من 60 دقيقة
        if [ $DIFF -lt 60 ]; then
            # عرض الأيقونة والوقت فقط في هذه الحالة
            echo "󰽥 ${NAMES[$i]} بعد $DIFF دقيقة "
        else
            # إرجاع نص فارغ لإخفاء الأداة من شريط Waybar
            echo ""
        fi
        exit 0
    fi
done

