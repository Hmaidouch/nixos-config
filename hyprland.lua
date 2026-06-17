
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