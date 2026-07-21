---
name: rofi-ui
description: Rofi menus, themes and launchers.
---

Custom menus should use

```
rofi -dmenu
```

Application launcher should use

```
rofi -show drun
```

Themes live in

```
programs/rofi/dotfiles/themes/
```

Prefer Nerd Font icons.

Avoid plugins.

Keep menus lightweight.

Avoid shell pipelines when a single rofi invocation is sufficient.

Ignore Waydroid launchers unless explicitly requested.