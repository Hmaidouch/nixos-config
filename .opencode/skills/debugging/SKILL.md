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

# Output Style

When modifying files always provide

- affected file

- changed section

- explanation

Avoid rewriting unrelated code.
