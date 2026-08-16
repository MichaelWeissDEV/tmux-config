# `keys/` — the key registry

This directory is the single source of truth for every key this project knows
about. The tmux config, the Key Explorer and the generated documentation all
read from here; nothing downstream keeps its own list.

```
keys/
├── upstream/     tmux's OWN defaults, captured from tmux — never hand-written
├── custom/       what tmux-config binds, hand-maintained
└── generated/    the merge of the two, produced by scripts/gen-keys
```

## `upstream/`

One snapshot per tmux version, e.g. `tmux-3.7b.tsv`. These files are produced
**only** by `scripts/gen-upstream-keys`, which starts a pristine tmux server
and reads `list-keys`. They are never edited by hand and never sourced from a
cheat sheet, a blog post or anyone's memory — including the author's.

Columns: `table`, `key`, `repeatable`, `command`.

A snapshot exists for a version only if someone has run the capture under that
version. CI does this across a tmux matrix; see `.github/workflows/ci.yml`.
Missing versions are a gap in coverage, not an assertion that nothing changed.

## `custom/`

What this project binds, split by topic purely for readability. Together they
are one flat table — the filename carries no meaning.

Columns, in order:

| Column | Meaning |
| --- | --- |
| `table` | tmux key table: `prefix`, `root`, `copy-mode`, `copy-mode-vi` |
| `key` | the key as tmux names it |
| `command` | the tmux command it runs |
| `short_description` | one line, shown in the Explorer and the docs |
| `category` | Explorer grouping — see below |
| `origin` | provenance — see below |
| `repeatable` | `yes` if bound with `-r` |
| `min_tmux_version` | earliest tmux this binding is valid for |
| `displaces` | the upstream command this key had, if any |
| `tags` | space-separated search synonyms |
| `condition` | `@cfg_option=value` gate, or empty if always bound |
| `plugin` | owning plugin, or empty |
| `long_description` | the "why", required when `displaces` is set |

Empty cells are written as `-`. A literal `-` is not otherwise a legal value.

### `origin`

| Value | Meaning |
| --- | --- |
| `tmux` | a plain tmux default, unchanged |
| `tmux-enhanced` | a tmux default kept for **the same purpose**, improved |
| `tmux-config` | a new binding on a key tmux leaves free |
| `tmux-override` | a tmux default **displaced** by different behaviour |
| `plugin` | contributed by an optional plugin |
| `user` | found live but not in this registry — your `local.conf` |

`tmux-override` is the one that matters. Rule 2 of the project philosophy says
a default may be improved but not repurposed, so every override is a
deliberate, justified exception: it **must** name what it `displaces` and
**must** carry a `long_description` saying where the displaced behaviour went.
`scripts/check-key-conflicts` fails the build otherwise, and it also fails on
the opposite mistake — a binding that silently differs from upstream without
being marked as an override at all.

### `category`

`General`, `Sessions`, `Windows`, `Panes`, `Layouts`, `Copy mode`, `Buffers`,
`Configuration`. The Explorer's Quick view shows these in that order.

## `generated/`

`keys.tsv` is the merged registry, written by `scripts/gen-keys`. The Key
Explorer reads this file and nothing else at startup, so opening the Explorer
costs one file read rather than a scan of this directory.

Regenerate after any change under `custom/`:

```sh
./scripts/gen-keys
```

CI runs the generator and fails on a diff, so a stale `generated/` cannot be
merged.
