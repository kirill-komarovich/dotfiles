#!/usr/bin/env bash
set -euo pipefail

root="$HOME/.agent-shared/skills/synced"
[[ -d "$root" ]] || exit 0

# Remove cloud skills intentionally retired from the shared skill set.
skills=(docs docx import-memory morning pdf pptx skill-creator xlsx)
for bucket in "$root"/*; do
  [[ -d "$bucket" ]] || continue
  for skill in "${skills[@]}"; do
    rm -rf -- "$bucket/$skill"
  done
done
