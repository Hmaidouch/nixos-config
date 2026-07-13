# NixOS Project Context

## Overview

This repository contains my personal NixOS configuration.

The goal of this project is **not** to collect dotfiles, but to build a complete, modular and maintainable Linux environment completely managed by Nix Flakes and Home Manager.

The philosophy of the project is:

* Fast
* Lightweight
* Modular
* Reproducible
* Easy to maintain
* Easy to extend
* GitHub friendly

I prefer writing my own solutions instead of relying on huge desktop frameworks.

---

# Current Environment

Distribution:

* NixOS Unstable

Package source:

* nixos-unstable

Architecture:

* x86_64-linux

Window Manager:

* Niri

Previously tested:

* Hyprland

Desktop philosophy:

* Wayland only
* Minimal desktop
* Modular components
* Independent services
* Everything managed declaratively

---

# Repository Structure

```
.
├── flake.nix
├── flake.lock
│
├── hosts
│   ├── configuration.nix
│   ├── hardware-configuration.nix
│   └── mycore
│       ├── default.nix
│       ├── configurationuser.nix
│       ├── fonts.nix
│       └── graphics.nix
│
├── mynixos
│   ├── default.nix
│   ├── desktop.nix
│   │
│   ├── sessions
│   │   ├── niri
│   │   └── hyprland
│   │
│   ├── programs
│   │   ├── linux-updates
│   │   ├── rofi
│   │   ├── swaync
│   │   ├── wallpaper
│   │   ├── waybar
│   │   └── zsh
│   │
│   └── scripts
│       ├── news
│       ├── themes
│       └── ...
│
└── README.md
```

---

# Architecture

The project is separated into multiple layers.

## Layer 1

hosts/

Contains only machine-specific configuration.

Examples:

* hardware
* kernel
* networking
* users
* fonts
* graphics

---

## Layer 2

mynixos/

Contains desktop configuration only.

Nothing hardware specific should exist here.

---

## Layer 3

programs/

Each application has its own independent module.

Every program is isolated.

Example:

```
programs/
    rofi/
    waybar/
    swaync/
    wallpaper/
    linux-updates/
```

Each module contains

* default.nix
* configuration
* scripts
* themes
* assets

depending on the application.

---

# Linux Updates Module

One of the largest modules in the project.

Directory:

```
programs/linux-updates
```

It is completely independent.

Architecture:

```
linux_updates.sh

↓

sources/

↓

fetch_*

↓

summarize

↓

Gemini

↓

Telegram

↓

state/cache
```

Libraries include:

* common.sh
* fetch_rss.sh
* fetch_github.sh
* helpers.sh
* summarize.sh
* gemini_news.sh
* telegram.sh
* translate.sh
* state.sh

Sources currently include:

* NixOS
* Nixpkgs Unstable
* Hyprland
* Niri
* Kotlin
* Kotlin Multiplatform
* Compose Multiplatform

The module automatically:

* downloads news
* detects new releases
* removes duplicates
* summarizes using Gemini
* caches summaries
* sends Telegram notifications

---

# Waybar Module

Waybar is fully modular.

Instead of one large configuration, modules are split into individual files.

Example:

```
modules/

audio.jsonc
clock.jsonc
launcher.jsonc
news.jsonc
system.jsonc
connections.jsonc
themes.jsonc
...
```

CSS is also modular.

---

# Wallpaper Module

Wallpaper management is completely automated.

Responsibilities:

* wallpaper picker
* random wallpaper
* favorites
* caching
* wallust integration
* automatic color generation

---

# Rofi Module

Rofi is used as the main launcher.

It contains:

* launcher
* control center
* network menu
* news menus
* custom themes

---

# SwayNC Module

Notification center is customized.

Configuration includes:

* modular CSS
* notification layout
* sliders
* media controls
* variables

---

# Sessions

Currently maintained sessions:

* Niri
* Hyprland

Niri is the primary session.

Hyprland exists mainly for testing and compatibility.

---

# Home Manager

Home Manager manages:

* applications
* desktop
* scripts
* themes
* GTK
* Waybar
* Rofi
* SwayNC
* sessions

System configuration remains inside NixOS modules.

---

# Scripts

Almost every automation is written in Bash.

Rules:

* modular
* readable
* reusable
* one responsibility per file

---

# AI Usage

Gemini is only used for:

* Linux news summarization

Everything else should remain deterministic.

---

# Git Philosophy

Everything is version controlled.

Ignored files include:

* .env
* hardware-configuration.nix (when deploying to another machine)

Sensitive data is never committed.

---

# Coding Style

When generating code:

Prefer:

* modularity
* readability
* reusable functions
* small files
* clear naming

Avoid:

* unnecessary abstraction
* giant files
* duplicated logic
* clever but unreadable Bash

---

# Nix Style

Prefer:

* Flakes
* Home Manager
* imports
* reusable modules
* directory-based organization

Avoid:

* monolithic configuration.nix
* duplicated declarations
* unnecessary overlays

---

# Performance Philosophy

Performance is preferred over visual effects.

I generally avoid software that:

* keeps unnecessary background daemons
* depends on large frameworks
* consumes excessive memory
* replaces multiple independent tools with one large shell

For this reason I chose:

* Niri
* Waybar
* Rofi
* SwayNC

instead of desktop shells based on Quickshell.

---

# Development Preferences

When suggesting improvements:

1. Preserve the existing architecture.
2. Follow the current module organization.
3. Never merge unrelated modules.
4. Keep the project modular.
5. Assume this repository will continue growing.

---

# Long-Term Goal

The long-term objective is to build a polished personal Linux desktop that is:

* lightweight
* elegant
* modular
* reproducible
* fully documented
* GitHub-ready
* easy to understand months or years later

Whenever answering questions about this project, assume this architecture and philosophy unless I explicitly state otherwise.
