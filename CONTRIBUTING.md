# Contributing

Maintained by **Michael Weiss**.

Thanks for looking. This project has a fairly opinionated design, so the most
useful thing before opening a pull request is to read
[Philosophy](docs/philosophy.md) — several rules there are enforced by CI, and
a change that breaks one will fail the build rather than being debated.

---

## Before you start

```bash
./scripts/check     # static checks
./tests/run         # behaviour tests
./scripts/doctor    # your environment (informational)
```

`check` and `tests/run` must pass. Both run in CI on Ubuntu, macOS, Debian,
Fedora, Arch and Alpine.

---

## The rules that are actually enforced

| Rule | How it is checked |
| --- | --- |
| No Ctrl-based key intercepted globally by default | `check` fails if one appears in the root key table |
| No key bound twice in the same table | `check` compares each key table |
| Every `@cfg_*` used is defined in `00-options.conf` | `check` diffs used against defined |
| Generated docs match the config | `check` regenerates and diffs |
| Config parses on every supported platform | `tests/run` in the CI container matrix |

The keybindings page and the options reference are **generated**. Never edit
them by hand:

```bash
./scripts/gen-keys      # rebuild the merged key registry
./scripts/gen-docs      # rebuild the keybinding pages
./scripts/gen-options.py > docs/reference/options.md
```

---

## Adding an option

1. Add it to `config/00-options.conf` with its accepted values and the reason
   for the default. That file is the source of the options reference, so the
   comment you write there becomes the documentation.
2. Read it in a module with `set -gF` or `%if` — never `set -g` with a format,
   which silently stores the literal `#{...}` text.
3. Regenerate the docs.

## Adding a module

See [Architecture → Adding a module](docs/architecture.md#adding-a-module).
Two constraints are easy to trip over and both fail silently:

- `%if` is evaluated at **parse time, per file**. An option set earlier in the
  *same* file is invisible to it.
- A backgrounded `if-shell -b` is not visible to a later file's `%if`; a
  synchronous one is.

## Adding a plugin

Plugins are vendored, never fetched at runtime. See
[Plugins → Vendoring](docs/plugins/available.md#vendoring-a-new-plugin-maintainers).
A plugin needs a manifest entry, an adapter in `plugins/`, an option, and a
line in `config/70-plugins.conf`.

A plugin is only worth vendoring if current tmux cannot do the job natively.
Rejected candidates and the reasoning are recorded in
`vendor-manifest/plugins.toml` so the discussion is not repeated.

---

## Style

- Comments explain **why**, not what. `set -g mouse on` needs no comment;
  the reason a default was chosen does.
- Where a default takes something away from the user, say so next to it.
  The Alt+number binding is the model: it states what it costs.
- No hex colours outside `config/themes/`. Use `#{@thm_*}`.
- No literal non-ASCII glyphs in the status bar. Use `#{@sym_*}`, which
  degrades to ASCII automatically.
- No `#(shell)` in the status bar by default — it forks per refresh, per
  client.

---

## Commits and pull requests

- One logical change per pull request.
- Update `CHANGELOG.md` under `[Unreleased]`.
- If you rename an option or change a default, say so under **Changed** — that
  is what people read after `git pull` when something moved.
