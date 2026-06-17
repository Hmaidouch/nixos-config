
----------------------------------------------------------------
-- 1. إعدادات كرت نفيديا والأداء (Nvidia & Render Settings)
----------------------------------------------------------------

-- تعطيل مؤشر الماوس العتادي (إلزامي جداً لمنع اختفاء الماوس في نفيديا)
-- ملاحظة: اضبط الصيغة بناءً على الـ Wrapper الخاص بك (إما كجدول أو كأمر مباشر)
hl.config.cursor = {
    no_hardware_cursors = true
}

-- خيارات تحسين الأداء وتقليل الوميض (Flickering) لمعمارية Kepler القديمة
hl.config.render = {
    explicit_sync = false, -- الكروت القديمة وتعريف 470 قد لا تدعم الـ Explicit Sync بشكل مستقر
    wal_disable_vblank = false
}

----------------------------------------------------------------
-- 2. مصفوفة اختصارات الأزرار والماوس (Keybindings Table)
----------------------------------------------------------------

hl.config({
    input = {
        kb_layout = "fr,ara",
        kb_options = "grp:alt_shift_toggle"
    },

    monitor = {
        "Unknown-1,1920x1080@60,0x0,1"
    }
})

hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + T", hl.dsp.exec_cmd("alacritty"))
hl.bind("SUPER + B", hl.dsp.exec_cmd("firefox"))
hl.bind("SUPER + E", hl.dsp.exec_cmd("nemo"))
hl.bind("SUPER + C", hl.dsp.exec_cmd("code"))

hl.bind(
    "SUPER + mouse:272",
    hl.dsp.window.drag(),
    { mouse = true }
)

hl.bind(
    "SUPER + mouse:273",
    hl.dsp.window.resize(),
    { mouse = true }
)

hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")