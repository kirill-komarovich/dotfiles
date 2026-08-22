---
name: herdr-dev-manifest
disable-model-invocation: true
description: "Write or update a project's .herdr-dev.toml — the manifest the Herdr dev-stack plugin reads to know which docker services and local processes make up this project's dev stack. Use when a project has no manifest, when its compose services have changed, or when the user asks to regenerate one."
---

# .herdr-dev.toml

The Herdr dev-stack plugin runs a project's deps and dev servers in the background, controlled from
one popup TUI. `.herdr-dev.toml` at the project root is the whole of its configuration. It is
**gitignored** (`.herdr-dev*` in `~/.gitignore_global`), personal, and written by you — the plugin has
no generator, deliberately: what belongs in it is judgment, not parsing.

## Shape

```toml
# Merged under every unit's own env.
[env]

[local.rails]
cmd = ["bundle", "exec", "rails", "s"]

[local.vite]
cmd = ["bin/vite", "dev"]

[docker]
names = ["db", "memcached", "redis"]
one_shot = ["migrate"]
hidden = ["web", "sidekiq", "frontend", "minio"]

[docker.notes]
harmony = "run `docker compose run --rm harmony rails db:create db:migrate` once, by hand"

[includes.player_server]
path = "~/projects/tds/player_server"
```

- **`[local.<name>]`** — a process the plugin spawns itself. `cmd` is an **argv array**, never a shell
  string; optional `cwd` and `env`. The table key is the unit name and the row label.
- **`[docker]`** — membership lists of compose **service names**, not tables. `names` is what you can
  start; `one_shot` names services that run and exit; `hidden` names services that must never be
  rendered or started. A service may be in `one_shot` **and** `hidden`.
- **`[docker.notes]`** — free text per service, shown in the row's note column.
- **`[includes.<name>]`** — another repo whose own manifest is read, one level deep, no recursion.
- **`[env]`** — merged under each unit's own `env`.

Document order is display order. `names` order is row order within docker.

## Never put ports in it

Every unit is spawned through `mise exec --` with cwd set, so `PORT`, `VITE_RUBY_PORT` and the
toolchain all come from the project's `mise.toml` / `.mise.local.toml`. A manifest that restates a
port is wrong even when the number is right — it will drift the moment mise changes.

## How to fill it in

1. **Docker services**: `docker compose config --services` in the project root. It needs **no running
   daemon** (~70 ms), reads only `docker-compose.yml` + `docker-compose.override.yml` — the defaults —
   and writes warnings to stderr that are safe to ignore (unset vars that live in `.mise.local.toml`,
   obsolete `version:` keys). Do **not** pass `-f`: files like `docker-compose-services.yml`,
   `-ci.yml` or `.jmeter.yml` are not part of the dev flow.
2. **Sort `names` alphabetically** on a first write. Compose's own output order is arbitrary.
3. **Decide what is `hidden`**, and be aggressive about it. Typical: a containerised copy of the app
   (`web`, `sidekiq`, `frontend`) that duplicates a local unit; anything the user does not run locally;
   anything that is a **production** deploy rather than a dev dep. Read the compose file rather than
   guessing from names, and **ask the user which services they actually start** if it is not obvious —
   getting this wrong fills their TUI with rows that must never be pressed.
4. **`one_shot` cannot be detected** — compose reports a `restart:` key for some exiting services and
   not for others, though they behave identically. Seed it from explicit `restart:` keys, then read the
   commands: anything running a migration, an init or a seed and exiting belongs there. This matters:
   an undeclared one-shot in the waited set makes `up -d --wait` return failure *and* abandon the wait.
5. **Local units**: name them for what they are (`rails`, `sidekiq`, `vite`, `phoenix`) and take the
   command from how the user actually runs it. A `Procfile`, if the repo has one, is a decent source of
   names and bare commands but a bad source of arguments — strip leading `VAR=value` assignments and
   any token containing `${`, since the manifest is argv and mise already supplies the env. Never carry
   over `-p ${RAILS_PORT:-3000}`.
6. **Includes and notes are hand knowledge.** Never invent an include; ask which sibling repos this one
   is run alongside. Add a note only where a row needs a warning a reader could not infer.

## Updating an existing manifest

The file is hand-tuned. Preserve it.

- **New compose service** → append to the end of `names`. Never reorder existing entries.
- **Service gone from compose** → move it into `hidden` with a comment saying why. Nothing is deleted;
  a vanished service must simply stop being startable.
- **Everything else is untouched**: comments, `[docker.notes]`, `one_shot`, `hidden`, `[local.*]`,
  `[includes.*]`, `[env]`, and the order the user arranged rows in.
- Read the file before writing it, and diff your result against it — if a hand edit disappeared, you
  clobbered it.

## Check your work

There is no schema validation anywhere, so a typo is silent:

- Every name in `one_shot` and `hidden` must be a real compose service.
- No duplicates within `names`.
- Every `[local.*]` has a `cmd`, and every `cmd` is an array of separate arguments.
- Parse the file (`python3 -c "import tomllib; tomllib.load(open(p,'rb'))"` or `taplo`) before calling
  it done. Hand-written TOML that has never been parsed is not finished.
