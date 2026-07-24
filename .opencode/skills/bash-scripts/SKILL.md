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

---

# Transcribe Pipeline

Multi-script workflow for video transcription and translation.

Location:

```
mynixos/scripts/transcribe/
```

## Pipeline

```
Video → transcribe_groq.sh → Groq API (Whisper) → JSON
    ↓
json_to_srt.py → .srt + .txt + .vtt
    ↓
translate.sh → Gemini API → .ar.srt
    ↓
merge_subtitle.sh → subtitled.mp4
```

## Scripts

| Script | Language | Purpose |
|---|---|---|
| `transcribe_groq.sh` | Bash | Extract audio, call Groq Whisper API |
| `json_to_srt.py` | Python | Convert Groq JSON to SRT/VTT/TXT |
| `translate.sh` | Bash | Orchestrate SRT translation via Gemini |
| `translate_srt.py` | Python | Parse SRT, batch-translate via Gemini API |
| `merge_subtitle.sh` | Bash | Embed Arabic SRT into video via ffmpeg |

## API Keys

Scripts load keys from `.env`:

```bash
ENV_FILE="$HOME/nixos-config/.env"
source "$ENV_FILE"
```

Required keys:

- `GROQ_API_KEY` — for transcription (Whisper)
- `GEMINI_API_KEY` — for translation

Never commit `.env`.

## Conventions Used

- `set -euo pipefail` in all bash scripts
- Python scripts use `#!/usr/bin/env python3`
- Batch translation in chunks of 30 lines
- Skip existing output files (idempotent)
- Use `read -n1` at end for terminal pause
- ffmpeg for audio extraction and subtitle embedding
