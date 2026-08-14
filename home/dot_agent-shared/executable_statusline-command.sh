#!/usr/bin/env bash
input=$(cat)
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
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
session_id=$(echo "$input" | jq -r '.session_id // empty')
session_info=""
[[ -n "$session_id" ]] && session_info=" | ${session_id}"
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
total_in=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
total_out=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')
total_cost=$(echo "$input" | jq -r '.total_cost // empty')
token_info=""
if [[ -n "$used" ]]; then
  avail=$((100 - used))
  total=$((total_in + total_out))
  token_k=$((total / 1000))
  token_info=" | ${avail}% avail (${token_k}k tokens)"
  [[ -n "$total_cost" ]] && token_info="${token_info}, \$${total_cost}"
fi
printf "%s%s%s%s" "$short_path" "$git_info" "$token_info" "$session_info"
