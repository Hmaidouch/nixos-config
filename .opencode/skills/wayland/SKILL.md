---
name: wayland
description: Wayland compositors, sessions, and desktop integration.
---

# Compositors

Primary:

- Niri

Secondary:

- Hyprland (testing only)

Never generate Hyprland configuration when editing Niri.

Never generate Niri KDL when editing Hyprland.

---

# Niri

Config format: KDL

Config location: `mynixos/sessions/niri/config.kdl`

Config is placed via Home Manager:

```nix
xdg.configFile."niri/config.kdl".source = ./config.kdl;
```

Key bindings defined in `binds { }` block.

Spawn apps with:

```kdl
"Super+T" { spawn "alacritty"; }
```

Startup apps:

```kdl
spawn-at-startup "waybar"
spawn-at-startup "awww-daemon"
```

---

# Hyprland

Config format: Lua

Config location: `mynixos/sessions/hyprland/hyprland.lua`

Enabled with UWSM:

```nix
programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
};
```

---

# UWSM

Universal Wayland Session Manager.

Enabled system-wide:

```nix
programs.uwsm.enable = true;
```

Session launched via:

```
uwsm start niri
```

---

# Greetd

Login manager.

Uses tuigreet for TUI login.

Configured in `hosts/mycore/configurationuser.nix`.

Default session: Niri via UWSM.

```nix
services.greetd = {
    enable = true;
    settings = {
        default_session = {
            command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd 'uwsm start niri'";
            user = "benattia";
        };
    };
};
```

---

# Waybar

Prefer Home Manager module.

Avoid custom services unless necessary.

Modular JSONC files for each widget.

---

# XDG Portals

Required for screen sharing and file dialogs.

Configured per compositor.

---

# Virtualization

Waydroid is installed.

Libvirt exists only for experimentation.

Do not remove virtualization services unless requested.

XWayland is enabled for legacy app support.
