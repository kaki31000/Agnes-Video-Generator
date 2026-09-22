---
name: Voice defaults
description: Default text-to-speech selection for multilingual Agnes workflows
---

When the active UI language changes, automatically supplied voice selections should follow that language; deliberate user-selected voices must remain unchanged.

**Why:** The backend correctly rejects incompatible voice/text pairs, so a fixed Chinese default makes French and other supported languages fail before generation starts.

**How to apply:** Keep automatic defaults distinguishable from explicit selections, use the loaded voice catalog when available, and retain a valid per-language fallback while the catalog is loading.