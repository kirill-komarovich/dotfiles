---
name: herdr-dev
description: "Read or drive a project's dev stack — its docker deps and local dev servers — with the `herdr-dev` command. Use when work needs a dep running, when you need a unit's port, log or state, or when a service must be started, stopped or restarted."
---

# herdr-dev

The dev stack of a project with a `.herdr-dev.toml`: its docker services and the dev servers the user
runs locally, all owned by one background daemon. `herdr-dev` is on `PATH` and answers in JSON on
stdout; prose and complaints go to stderr.

```
herdr-dev status                          # every unit of this project
herdr-dev start   <unit>...               # and stop, and restart
herdr-dev stop    <unit>...
herdr-dev restart <unit>...
```

Both forms take `--project <dir>` before the units; without it the project is the nearest
`.herdr-dev.toml` at or above the working directory.

A unit is named by `<name>` (`rails`), by `<kind>-<name>` when a local unit and a docker service share
one (`docker-web`), or by `<repo>:<name>` for a unit in an included repo. An ambiguous name is refused
with the spellings that would work.

## What a status says

One object per unit under `units`:

- `state` — `down`, `starting`, `up`, `done` (a `one_shot` that ran and exited), `dead`, `unknown`.
- `ports` — host ports it is **listening on right now**, `[]` until something is bound. Never
  declared anywhere: a docker service publishes them, a local unit is observed holding them, so a
  server that binds late shows none until it does. Read the port from here rather than from a
  `mise.toml` or a compose file.
- `log` — a plain file a local unit writes; `tail -n 50` it when a start did not take.
- `note` — what the state itself says (`unhealthy`, a stale reading); `manifest_note` is the user's
  standing hint about the unit.
- `pid`, `cmd`, `cwd`, `uptime_ms`, `exit_code`, `one_shot`, `repo`.

`daemon` is `null` when nothing is supervising, which is the stack being down. `problems` holds
anything that could not be read.

## Rules

- **`status` starts nothing.** A verb starts the daemon if it is not running; a read never does.
- **Act on the unit you were asked about.** The user is working in these servers: a restart is theirs
  to ask for, and a stop takes their session's dep with it.
- **Poll after a start.** A verb returns when the unit is spawned, not when it is serving: re-read
  `status` until `state` is `up` and the port you need is in `ports`.
- **Restart to pick up config**: a changed `mise.toml`, `.env` or compose file takes effect on the
  next start, never in the running process.
- Starting a unit that is already running succeeds and says so in `results[].note`.

Exit status is 0 when every verb took, 1 when one did not (the JSON still prints, and
`results[].error` says why), 2 for bad arguments.

## Changing what units exist

The manifest is hand-tuned and personal. To add, remove or fix a unit, use the `herdr-dev-manifest`
skill rather than editing `.herdr-dev.toml` from here.
