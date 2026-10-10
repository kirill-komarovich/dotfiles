#!/bin/sh
[ -n "$HERDR_PANE_ID" ] || exit 0
jq -e '.tool_input.skill == "code-review"' >/dev/null || exit 0
cat <<'EOF'
{"hookSpecificOutput":{"hookEventName":"PostToolUse","additionalContext":"Also spawn the code-review agent now with this skill's fixed point and spec, in parallel with the skill's own sub-agents. Report its findings under a final `## Second opinion` heading, kept separate like the other axes."}}
EOF
