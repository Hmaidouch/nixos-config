---
name: desktop-components
description: SwayNC, wallpaper management, GTK themes, and desktop utilities.
---

# SwayNC

Notification center.

Config location: `mynixos/programs/swaync/dotfiles/`

Uses modular CSS.

Config is placed via XDG:

```nix
xdg.configFile."swaync".source = ./dotfiles;
```

Components:

- config.json — main configuration
- style.css — modular CSS with variables

---

# Wallpaper

Fully automated wallpaper management.

Config location: `mynixos/programs/wallpaper/`

Uses Pattern B + D:

```nix
home.file.".local/share/wallpaper" = {
    source = ./scripts;
    recursive = true;
};

home.packages = with pkgs; [
    awww
    wallust
    waypaper
    (writeShellScriptBin "wallpaper" '' exec "$HOME/.local/share/wallpaper/wallpaper.sh" '')
];
```

Responsibilities:

- wallpaper picker
- random wallpaper
- favorites
- caching
- wallust integration
- automatic color generation

Wallust config: `programs/wallpaper/dotfiles/`

---

# GTK Themes

Configured via Home Manager:

```nix
gtk = {
    enable = true;
    theme = {
        name = "Orchis-Light";
    };
    iconTheme = {
        name = "Tela-circle-light";
    };
};
```

Available themes in repository:

- matcha-gtk-theme
- tokyonight-gtk-theme
- catppuccin-gtk
- gruvbox-gtk-theme
- arc-theme
- orchis-theme

Icon themes:

- tela-circle-icon-theme

---

# Cursor Themes

posy-cursors is installed.

---

# Notifications

Always use

```
notify-send
```

Never use zenity.

Format:

```bash
notify-send -a "AppName" "Title" "Body" -i icon-name
```

---

# Scripts

Theme switching scripts live in

```
mynixos/scripts/themes/
```

Available scripts:

- theme_switch.sh — GTK theme switching
- iconstheme_switch.sh — icon theme switching

Installed via desktop.nix:

```nix
(writeShellScriptBin "theme_switch" (builtins.readFile ./scripts/themes/theme_switch.sh))
```
