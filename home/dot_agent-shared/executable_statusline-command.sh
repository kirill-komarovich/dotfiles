#!/usr/bin/env bash
input=$(cat)

IFS=$'\t' read -r cwd session_id ctx_used ctx_size cost_cents rate_5h < <(
  jq -r '[
    .workspace.current_dir,
    (.session_id // "-"),
    (.context_window.total_input_tokens // 0),
    (.context_window.context_window_size // 0),
    ((.cost.total_cost_usd // 0) * 100 | round),
    (.rate_limits.five_hour.used_percentage // 0 | round)
  ] | @tsv' <<< "$input"
)

short_path="${cwd/#$HOME/~}"
IFS='/' read -ra parts <<< "$short_path"
sp=()
for ((i=0; i<${#parts[@]}-1; i++)); do
  p="${parts[i]}"
  [[ -n "$p" && "$p" != "~" ]] && sp+=("${p:0:1}") || sp+=("$p")
done
[[ ${#parts[@]} -gt 0 ]] && sp+=("${parts[${#parts[@]}-1]}")
short_path=$(IFS=/; echo "${sp[*]}")

git_info=""
if git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
  branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
  if [[ -n "$branch" ]]; then
    if git -C "$cwd" diff --no-ext-diff --quiet 2>/dev/null && git -C "$cwd" diff --no-ext-diff --cached --quiet 2>/dev/null; then
      git_info=" ($branch)"
    else
      git_info=" ($branch*)"
    fi
  fi
fi

# Absolute tokens, not the percentage: auto-compact triggers on a reserve below
# the full window, so a percentage of context_window_size never reaches 0.
ctx_info=""
if ((ctx_size > 0 && ctx_used > 0)); then
  ctx_info=$(printf " | %dk/%dk (%d%%)" $((ctx_used / 1000)) $((ctx_size / 1000)) $((ctx_used * 100 / ctx_size)))
fi

cost_info=""
((cost_cents > 0)) && cost_info=$(printf " | \$%d.%02d" $((cost_cents / 100)) $((cost_cents % 100)))

rate_info=""
((rate_5h > 0)) && rate_info=$(printf " | 5h %d%%" "$rate_5h")

printf "%s%s%s%s%s | %s" "$short_path" "$git_info" "$ctx_info" "$cost_info" "$rate_info" "$session_id"
