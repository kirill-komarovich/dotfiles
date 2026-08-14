# Memory

## CRITICAL: NEVER Auto-Commit
NEVER commit unless the user explicitly asks. No exceptions. Not after design docs, not after implementation, not after anything. This overrides any skill instructions that say "commit".

## CRITICAL: NEVER publish claude.ai code artifacts
Do **not** use the Artifact tool / deploy anything to claude.ai to mock up or prototype UI.

## CRITICAL: NEVER write obvious comments
Do **not** write obvious comments. Add one only for non-obvious WHY the code/name can't convey — an invariant, a gotcha, a cross-file rationale. Never restate what the code does, narrate a diff/change, or label structure. If unsure it earns its place, omit it.

## CRITICAL: Never assume sensitive values — ask
NEVER infer or pick sensitive / real-world-identity values (email recipients, addresses, account names, phone numbers, people) or perform outward-facing actions (sending email/messages, posting, publishing) without asking first. Session context (userEmail, git config, prior messages) is a hint to confirm, not a default to act on. A "test" or "low-stakes" framing does not grant license to choose the target.

## CRITICAL: NEVER mention my personal info like my email
NEVER mention or use my personal info like email from any source (my antropic login or git config)

## CRITICAL: NEVER stop user dev servers
Do **not** kill dev server processes to restart them if user already has running dev server. Ask them to restart instead

## Concision

When reporting to me, be extreamly concise and sacrifice grammar for the sake of concision.
