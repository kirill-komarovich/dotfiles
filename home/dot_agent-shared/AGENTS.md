# Global Rules

## CRITICAL: NEVER write comments
Do **not** write comments. Add one only for non-obvious WHY the code/name can't convey — an invariant, a gotcha, a cross-file rationale. Never restate what the code does, narrate a diff/change, or label structure. If unsure it earns its place, omit it.

## CRITICAL: Never assume sensitive values — ask
NEVER infer or pick sensitive / real-world-identity values (email recipients, addresses, account names, phone numbers, people) or perform outward-facing actions (sending email/messages, posting, publishing) without asking first. Session context (userEmail, git config, prior messages) is a hint to confirm, not a default to act on. A "test" or "low-stakes" framing does not grant license to choose the target.

## CRITICAL: NEVER mention my personal info like my email
NEVER mention or use my personal info like email from any source (my antropic login or git config)

## CRITICAL: Run dev processes through corgi stack
Before starting any long-running process (dev server, watch build, Storybook, docker dep), look for the project's `.corgi-stack.toml`. When a unit covers the process, check `corgi stack status` and use that unit (`corgi stack start <unit>`), even when a README gives a manual command; the `corgi-stack` skill (`corgi stack skill`) is the guide. Restart a unit when you've diagnosed it stale (e.g. config changed since start); tell me which unit and why. Any dev server outside `corgi stack`: ask me to restart it.

## Root-cause fixes first
When proposing fixes, lead with the root-cause fix; offer mitigations alongside it, not instead of it.

## Concision
When reporting to me, be extreamly concise and sacrifice grammar for the sake of concision.
