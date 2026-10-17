#!/bin/sh
# Permission rules can't do this: a user-level deny or ask beats any repo-level
# allow, and allow rules are ignored in bypassPermissions. A hook "ask" still
# prompts in bypass mode, and repos opt out through their settings `env`.
in=$(cat)

allowed() {
  case " $AGENT_GIT_ALLOW " in *" $1 "*) return 0 ;; esac
  return 1
}

git_runs() {
  printf '%s\n' "$cmd" | grep -Eq "(^|[^[:alnum:]_.-])git([[:space:]]+(-[Cc][[:space:]]+[^[:space:]]+|-[^[:space:]]+))*[[:space:]]+$1([^[:alnum:]-]|\$)"
}

gated=
gate() { allowed "$1" || gated="$gated $1"; }

case $(printf '%s' "$in" | jq -r .tool_name) in
  Bash)
    cmd=$(printf '%s' "$in" | jq -r '.tool_input.command // ""')
    git_runs commit && gate commit
    git_runs '(checkout|switch)' && gate checkout
    git_runs 'worktree[[:space:]]+add' && gate worktree
    ;;
  EnterWorktree) gate worktree ;;
  Agent)
    printf '%s' "$in" | jq -e '.tool_input.isolation == "worktree"' >/dev/null && gate worktree
    ;;
esac

[ -n "$gated" ] || exit 0
jq -n --arg r "git${gated} needs approval. Allow per repo with AGENT_GIT_ALLOW in .claude/settings.local.json env." \
  '{hookSpecificOutput: {hookEventName: "PreToolUse", permissionDecision: "ask", permissionDecisionReason: $r}}'
