
hl.config({
    input = {
        kb_layout = "fr,ara",
        kb_options = "grp:alt_shift_toggle"
    },

    monitor = {
      "HDMI-A-1, 1920x1080@60, 0x0, 1",
      "Unknown-1, disable"
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
      font_family = "JetBrains Mono";
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
