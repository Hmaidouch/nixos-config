---
name: debugging
description: Debugging NixOS builds and repository issues.
---

# Build Workflow

Before rebuilding prefer

```
nix flake check
```

Then

```
sudo nixos-rebuild test --flake .#benattia
```

Finally

```
sudo nixos-rebuild switch --flake .#benattia
```

Always use flakes.

Never suggest channels.

---

# When Debugging

Always explain

1. root cause

2. why it happens

3. minimal fix

4. exact patch

Avoid generic troubleshooting.

Prefer declarative fixes over imperative workarounds.

Never suggest editing generated files inside /nix/store.

---

# Git Rules

Never touch

```
hosts/hardware-configuration.nix
```

Never rewrite history.

Never use

```
git reset --hard
```

unless explicitly requested.

Never force push.

---

# Secrets

API keys live in `.env` at repository root.

```
.env
```

Loaded via:

```bash
source "$HOME/nixos-config/.env"
```

Never commit `.env`.

Never log API keys.

Never echo secrets to output.

Required keys:

- `GROQ_API_KEY` — Groq Whisper transcription
- `GEMINI_API_KEY` — Gemini translation
- `TELEGRAM_BOT_TOKEN` — Telegram notifications
- `TELEGRAM_CHAT_ID` — Telegram chat target

---

# Output Style

When modifying files always provide

- affected file

- changed section

- explanation

Avoid rewriting unrelated code.
