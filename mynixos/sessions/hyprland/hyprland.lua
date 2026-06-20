
hl.config({
    input = {
        kb_layout = "fr,ara",
        kb_options = "grp:alt_shift_toggle",
        follow_mouse = 0
    },

    monitor = {
      ", 1920x1080@60, 0x0, 1",
    },

    cursor = {
      no_hardware_cursors = true
    },

    general = {
      gaps_in = 1;
      gaps_out = 0;
    },

    decoration = {
      rounding = 4;
      active_opacity = 1.0;
      inactive_opacity = 1.0;
      blur = {
        enabled = true;
        size = 8;
        passes = 3;
      };
      shadow = {
        enabled = false;
      };
    },
    
    misc = {
        force_default_wallpaper = 0;
        
        mouse_move_enables_dpms = true;
        focus_on_activate = true;
        mouse_move_focuses_monitor = true;
    }
})

hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + T", hl.dsp.exec_cmd("alacritty"))
hl.bind("SUPER + B", hl.dsp.exec_cmd("firefox"))
hl.bind("SUPER + E", hl.dsp.exec_cmd("nemo"))
hl.bind("SUPER + C", hl.dsp.exec_cmd("code"))
-- 1. التنقل للأمام باستخدام Alt + Tab وجلب النافذة للمقدمة
hl.bind("ALT + Tab", function()
  hl.dispatch(hl.dsp.window.cycle_next())
  hl.dispatch(hl.dsp.window.bring_to_top())
end)

-- 2. التنقل العكسي (للخلف) باستخدام Alt + Shift + Tab (مفيد جداً)
hl.bind("ALT + SHIFT + Tab", function()
  hl.dispatch(hl.dsp.window.cycle_next({ next = false }))
  hl.dispatch(hl.dsp.window.bring_to_top())
end)

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

hl.env("XCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "Posy_Cursor")

hl.env("HYPRCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "Posy_Cursor")


-- =====================================================================
-- قواعد النوافذ الحديثة (Hyprland Lua Window Rules)
-- =====================================================================

-- 1. القواعد الأساسية العامة (تُطبق على كل النوافذ)
hl.window_rule({
  match = { class = ".*" },
  float = true,
  move = "0 0",
  size = "100% 1020"
})

--hl.window_rule({
--  match = { class = "^(org.gnome.Calculator)$" },
--  size = "360 510",
--  move = "20 480"
--})

--hl.window_rule({
--  match = { class = "^(org.pulseaudio.pavucontrol)$" },
--  size = "360 510",
--  move = "100%-370 100%-550"
--})

--hl.window_rule({
--  match = { class = "^(nemo)$" },
--  size = "1200 850",
--  move = "100%-1920 100%-1000"
--})

--hl.window_rule({
--  match = { class = "^(Alacritty)$" },
--  size = "900 600",
--  move = "100%-1000 100%-900"
--})

hl.on("hyprland.start", function () 
--  hl.exec_cmd("waybar")
end)