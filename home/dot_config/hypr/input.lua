-- Hyprland resolves keybindings against the first entry, not the active layout,
-- so the Latin one has to lead or SUPER bindings stop firing under Cyrillic.
hl.config({
  input = {
    kb_layout = "pl,ru",
    kb_options = "compose:caps,shift:both_capslock_cancel,grp:alts_toggle",
    natural_scroll = false,
    touchpad = {
      natural_scroll = false,
    },
  },
})
