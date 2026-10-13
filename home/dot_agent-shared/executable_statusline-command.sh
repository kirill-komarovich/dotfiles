#!/usr/bin/env bash
input=$(cat)

IFS=$'\t' read -r cwd session_id model ctx_used ctx_size cost_cents rate_5h reset_5h rate_7d < <(
  jq -r '[
    .workspace.current_dir,
    (.session_id // "-"),
    (.model.display_name // "-"),
    (.context_window.total_input_tokens // 0),
    (.context_window.context_window_size // 0),
    ((.cost.total_cost_usd // 0) * 100 | round),
    (.rate_limits.five_hour.used_percentage // 0 | round),
    (.rate_limits.five_hour.resets_at // 0 | if type == "number" then floor else (sub("\\.[0-9]+"; "") | fromdateiso8601? // 0) end),
    (.rate_limits.seven_day.used_percentage // 0 | round)
  ] | @tsv' <<< "$input"
)

dim=$'\e[2m' bold=$'\e[1m' reset=$'\e[0m'

level() {
  if (($1 >= 80)); then printf '\e[31m'
  elif (($1 >= 50)); then printf '\e[33m'
  else printf '\e[32m'
  fi
}

profile_info=""
if [[ "$CLAUDE_CONFIG_DIR" == */.claude-* ]]; then
  profile=${CLAUDE_CONFIG_DIR##*/.claude-}
  palette=(36 35 34 33 32)
  sum=$(printf '%s' "$profile" | cksum | cut -d' ' -f1)
  profile_info=$(printf '\e[%s;1m%s%s ' "${palette[sum % ${#palette[@]}]}" "$profile" "$reset")
fi

short_path="${cwd/#$HOME/~}"
IFS='/' read -ra parts <<< "$short_path"
sp=()
for ((i=0; i<${#parts[@]}-1; i++)); do
  p="${parts[i]}"
  if [[ -n "$p" && "$p" != "~" ]]; then [[ "$p" == .* ]] && sp+=("${p:0:2}") || sp+=("${p:0:1}"); else sp+=("$p"); fi
done
[[ ${#parts[@]} -gt 0 ]] && sp+=("${parts[${#parts[@]}-1]}")
short_path=$(IFS=/; echo "${sp[*]}")

git_info=""
if git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
  branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
  if [[ -n "$branch" ]]; then
    if git -C "$cwd" diff --no-ext-diff --quiet 2>/dev/null && git -C "$cwd" diff --no-ext-diff --cached --quiet 2>/dev/null; then
      git_info=" ${dim}($branch)${reset}"
    else
      git_info=" ${dim}($branch${reset}\e[33m*${reset}${dim})${reset}"
    fi
  fi
fi

model_info=""
[[ "$model" != "-" ]] && model_info=" | ${bold}${model}${reset}"

# Absolute tokens, not the percentage: auto-compact triggers on a reserve below
# the full window, so a percentage of context_window_size never reaches 0.
ctx_info=""
if ((ctx_size > 0 && ctx_used > 0)); then
  pct=$((ctx_used * 100 / ctx_size))
  ctx_info=$(printf " | %dk/%dk %s(%d%%)%s" $((ctx_used / 1000)) $((ctx_size / 1000)) "$(level "$pct")" "$pct" "$reset")
fi

cost_info=""
((cost_cents > 0)) && cost_info=$(printf " | \$%d.%02d" $((cost_cents / 100)) $((cost_cents % 100)))

rate_info=""
if ((rate_5h > 0)); then
  rate_info=$(printf " | 5h %s%d%%%s" "$(level "$rate_5h")" "$rate_5h" "$reset")
  left=$((reset_5h - $(date +%s)))
  if ((rate_5h >= 50 && left > 0)); then
    rate_info+=$(printf " %s↻%dh%02dm%s" "$dim" $((left / 3600)) $((left % 3600 / 60)) "$reset")
  fi
fi
((rate_7d > 0)) && rate_info+=$(printf " | 7d %s%d%%%s" "$(level "$rate_7d")" "$rate_7d" "$reset")

printf "%s%s%b%s%s%s%s | %s%s%s" "$profile_info" "$short_path" "$git_info" "$model_info" "$ctx_info" "$cost_info" "$rate_info" "$dim" "$session_id" "$reset"
