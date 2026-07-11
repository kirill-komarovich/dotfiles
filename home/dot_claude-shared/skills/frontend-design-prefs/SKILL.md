---
name: frontend-design-prefs
description: Personal UI/UX rules to apply whenever building or editing frontend — web components, pages, or apps. ALWAYS use together with the frontend-design skill; this layers preferences on top of it (motion & theming prefs, responsive, low-chrome dense layouts, physics-based easing).
---

# Frontend design preferences

A personal preference layer on top of `frontend-design`. Whenever you build or edit UI:

1. Also load `frontend-design:frontend-design` and follow it for craft/aesthetics.
2. Apply the rules below as constraints on top of it.

## Rules

- **Motion & theming prefs:** honor `prefers-reduced-motion` and `prefers-color-scheme`; support light and dark.
- **Subtle motion only:** hover/state feedback, view/state transitions. Natural easing — use `linear()` to approximate physics. Guide attention, don't overdo it.
- **Responsive:** desktop and mobile.
- **Low chrome, dense content:** minimal borders, no visual clutter; maximize signal.
- **Typography & spacing:** clean type scale, consistent spacing, balanced layout.

## Scope

Only for frontend UI work. Non-UI tasks: skip. Does not override explicit user requests or project conventions.
