#!/usr/bin/env bash
set -euo pipefail

normalize_skill_name() {
  local skill="$1"
  local source_name="$2"
  local normalized_name="$3"
  [[ -f "$skill" ]] || return 0

  if grep -Fqx "name: $source_name" "$skill"; then
    local tmp
    tmp="$(mktemp "${TMPDIR:-/tmp}/normalize-skills.XXXXXX")"
    awk -v source="name: $source_name" -v normalized="name: $normalized_name" \
      '!fixed && $0 == source { print normalized; fixed = 1; next } { print }' \
      "$skill" >"$tmp"
    cat "$tmp" >"$skill"
    rm -f "$tmp"
    echo "normalized $skill"
  fi
}

# Cursor uses a display label, while Agent Skills names accept only lowercase slugs.
normalize_skill_name "$HOME/.agent-shared/skills/poteto-mode/SKILL.md" "Poteto Mode" "poteto-mode"
