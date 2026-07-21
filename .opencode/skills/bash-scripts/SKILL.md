---
name: bash-scripts
description: Repository bash scripting conventions.
---

# Script Structure

Every script should begin with

```bash
#!/usr/bin/env bash
set -euo pipefail
```

Every script should expose

```bash
main() {

}

main "$@"
```

Use

```
readonly
```

for constants.

Use

```
local
```

inside functions.

Avoid global variables.

Avoid duplicated code.

Prefer reusable functions.

---

# Script Installation

Large scripts live under

```
mynixos/scripts/
```

Small wrappers may use

```
writeShellScriptBin
```

Two patterns for installing scripts:

## Pattern 1 — Inline read

For scripts that are part of the Nix store and don't change independently:

```nix
(writeShellScriptBin "network_menu" (builtins.readFile ./scripts/network_menu.sh))
```

## Pattern 2 — Exec wrapper

For scripts that may be updated independently or are large:

```nix
(writeShellScriptBin "wallpaper" '' exec "$HOME/.local/share/wallpaper/wallpaper.sh" '')
```

Installed in desktop.nix via

```
home.packages
```

---

# Notifications

Always use

```
notify-send
```

Never use zenity.

Format:

```bash
notify-send -a "AppName" "Title" "Body"
```

---

# Icons

Use Nerd Font icons inside scripts.

Do not use emojis.

Example:

```bash
echo "󰖩 Connected"
echo "󰤨 Strong signal"
```

---

# Network Scripts

Use

```
nmcli
```

for network operations.

Detect wifi interface dynamically:

```bash
get_wlan_iface() {
    nmcli -t -f DEVICE,TYPE dev status | awk -F: '$2=="wifi"{print $1; exit}'
}
```

Never hardcode `wlan0`.

---

# Rofi Scripts

Use

```
rofi -dmenu
```

for custom menus.

Always pass theme:

```bash
rofi -dmenu -i -p "Title" -theme "$ROFI_THEME"
```
