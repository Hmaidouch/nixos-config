---
name: repository-rules
description: Repository architecture and design rules.
---

# Repository Rules

Desktop code belongs under

```
mynixos/
```

Machine configuration belongs under

```
hosts/
```

Never move files between layers.

One module = one responsibility.

Never create giant modules.

Prefer reusable functions.

Never rewrite unrelated code.

When modifying files always provide

- affected file
- changed section
- explanation

Do not disable services unless requested.

Do not introduce unnecessary dependencies.

Do not replace declarative configuration with imperative solutions.

Preserve repository architecture.