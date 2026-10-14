#!/bin/bash

set -eufo pipefail

command -v fish >/dev/null || exit 0

fish -c '
  for var in PATH fish_user_paths fish_greeting
    if set -qU $var
      echo "fish: erasing universal $var"
      set -eU $var
    end
  end
'
