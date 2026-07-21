---
name: nix-modules
description: Creating and modifying NixOS and Home Manager modules.
---

# Module Layout

Program modules live in

```
mynixos/programs/<program>/
```

Each module contains

```
default.nix

optional:

dotfiles/
scripts/
assets/
```

desktop.nix automatically imports program modules.

Never edit desktop.nix when adding a module.

User configuration belongs under

```
home-manager.users.benattia
```

Prefer

```
home.packages
```

Use

```
environment.systemPackages
```

only for system tools.

Prefer native Home Manager modules whenever available.

Use

```
let
in
```

for reusable values.

Keep options grouped logically.

---

# Module Patterns

## Pattern A — XDG config

For programs that use `~/.config/<name>/`:

```nix
{ config, pkgs, ... }:

{
  home-manager.users.benattia = {
    xdg.configFile."rofi".source = ./dotfiles;
  };
}
```

Place config files in `programs/<name>/dotfiles/`.

Used by: rofi, swaync, waybar, niri, hyprland

---

## Pattern B — Data directory

For scripts/data in `~/.local/share/<name>/`:

```nix
{ config, pkgs, ... }:

{
  home-manager.users.benattia = {
    home.file.".local/share/<name>" = {
      source = ./scripts;
      recursive = true;
    };
  };
}
```

Used by: wallpaper, linux-updates

---

## Pattern C — Native HM module

For programs with Home Manager modules:

```nix
{ config, pkgs, ... }:

{
  home-manager.users.benattia = {
    programs.waybar = {
      enable = true;
      systemd.enable = false;
    };
  };
}
```

Used by: waybar, zsh, git

---

## Pattern D — Packages + scripts

```nix
{ config, pkgs, ... }:

{
  home-manager.users.benattia = {
    home.packages = with pkgs; [
      some-package
      (writeShellScriptBin "my-script" '' exec "$HOME/.local/share/my-script/main.sh" '')
    ];
  };
}
```

---

## Pattern E — Mixed (most common)

Combine XDG config + packages + scripts:

```nix
{ config, pkgs, ... }:

{
  home-manager.users.benattia = {
    xdg.configFile."myapp".source = ./dotfiles;

    home.packages = with pkgs; [
      myapp
      (writeShellScriptBin "my-script" (builtins.readFile ./scripts/my-script.sh))
    ];
  };
}
```

Used by: wallpaper, linux-updates

---

# Adding New Program

Create

```
programs/<name>/
    default.nix
```

desktop.nix automatically imports it.

Never edit desktop.nix.
