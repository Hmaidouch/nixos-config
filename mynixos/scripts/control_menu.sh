#!/usr/bin/env bash

# حدد مسار مجلد الأيقونات (يجب أن تحمل أيقونات ويندوز 11 في هذا المجلد)
#ICON_DIR="$HOME/.config/rofi/icons"

# الأيقونات (تعتمد على تثبيت Nerd Font)
SHOT="Shot\0display\x1f<span font='16'>󰄀</span>     Shot"
#SHOT="<span color='#89b4fa' font='24'>󰄀</span>  Shot"
LOCK="Lock\0display\x1f<span font='16'>󰷛</span>      Lock"
REBOOT="Reboot\0display\x1f<span font='16'></span>     Reboot"
SHUTDOWN="Shutdown\0display\x1f<span font='16'>󰤆</span>     Shutdown"


#VOLUME="Volume\0icon\x1f${ICON_DIR}/volume.png"
#WIFI="Wi-Fi\0icon\x1f${ICON_DIR}/wifi.png"

OPTIONS="$SHOT\n$LOCK\n$REBOOT\n$SHUTDOWN"
#OPTIONS="$LOCK\n$SHUTDOWN\n$REBOOT\n$SHOT\n$VOLUME\n$WIFI"

# تشغيل Rofi وعرض الخيارات
# -dmenu : وضع القائمة (Menu)
# -p : نص العنوان
# -theme : يمكنك تحديد ثيم Rofi خاص للقائمة

CHOICE=$(echo -e "$OPTIONS" | rofi -dmenu -i -p "Control Center" -config "$HOME/.config/rofi/themes/Control-menu.rasi" -auto-select)

# تنفيذ الأمر بناءً على الاختيار
case "$CHOICE" in
    "Shot")
        # أمر لقطة الشاشة (مع تحديد المنطقة)
        niri msg action screenshot
        #grim -g "$(slurp)" ~/Pictures/$(date +%s_screenshot.png)
        ;;
    "Lock")
        swaylock \
          --screenshots \
          --clock \
          --timestr="%H:%M" \
          --datestr="%d/%m/%Y" \
          --font="JetBrains Mono" \
          --font-size=150 \
          --indicator-radius=300 \
          --indicator \
          --effect-blur=7x5 \
          --effect-vignette=0.5:0.5 \
          --effect-greyscale
        ;;
    "Shutdown")
        # أمر الإغلاق
        systemctl poweroff
        ;;
    "Reboot")
        # أمر إعادة التشغيل
        systemctl reboot
        ;;

#    "Volume")
        # أمر التحكم في الصوت
#        pavucontrol
 #       ;;
#    "Wi-Fi")
        # أمر إدارة الشبكة
  #      nm-connection-editor
 #       ;;
    *)
        exit 1
        ;;
esac
