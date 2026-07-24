---
name: nixos-config
description: Main entry point for this repository. Use for any work involving NixOS, Home Manager, flakes, desktop modules, scripts or repository architecture.
---

# Repository

Personal NixOS configuration.

Principles:

- Declarative
- Modular
- Reproducible
- Lightweight
- Wayland only
- Performance first

Primary compositor:

- Niri

Secondary:

- Hyprland

Always use flakes.

Never recommend channels.

Repository:

```
hosts/
mynixos/
flake.nix
```

Desktop configuration lives inside:

```
mynixos/
```

Machine configuration lives inside:

```
hosts/
```

Always preserve repository architecture.

Never edit:

```
hosts/hardware-configuration.nix
```

Read repository-rules skill before large refactors.

---

# Scripts

Scripts live inside:

```
mynixos/scripts/
```

Example workflows:

- `transcribe/` — video transcription, translation, subtitle embedding
- `themes/` — GTK and icon theme switching
- `news/` — Linux news aggregation

Desktop scripts are installed via `writeShellScriptBin` in `desktop.nix`.