# Key Explorer

Press <kbd>prefix</kbd> <kbd>H</kbd>.

A searchable list of every key, in a native tmux popup. It is the answer to
"what can I press?" when you do not want to leave your terminal, read a
website, or scroll through 300 lines of `list-keys` output.

```text
tmux-config keys   Quick

Search: _

GENERAL
  Prefix :           Prompt for a command
  Prefix ?           List key bindings
  Prefix C-k         Clear the screen and the scrollback
  Prefix b           Toggle the status bar
  Prefix g           Toggle a floating scratch terminal

SESSIONS
  Prefix $           Rename current session
  Prefix (           Switch to previous client
  Prefix )           Switch to next client
  Prefix d           Detach the current client
  Prefix s           Choose a session from a list

WINDOWS
  M-1                Go to window 1
  Prefix &           Kill current window
--------------------------------------------------------------------
/ search   n/N next/prev   Enter details   a active view   q close
```

## Keys inside the Explorer

| Key | Action |
| --- | --- |
| <kbd>j</kbd> / <kbd>k</kbd>, arrows | move |
| <kbd>Ctrl</kbd>+<kbd>f</kbd> / <kbd>Ctrl</kbd>+<kbd>b</kbd>, PgDn / PgUp | page |
| <kbd>g</kbd> / <kbd>G</kbd> | top / bottom |
| <kbd>/</kbd> | search — type a term, <kbd>Enter</kbd> to apply, empty to clear |
| <kbd>n</kbd> / <kbd>N</kbd> | next / previous match |
| <kbd>Enter</kbd> | details for the selected binding |
| <kbd>a</kbd> | cycle Quick → Active → All |
| <kbd>q</kbd> / <kbd>Esc</kbd> | close |

## The three views

**Quick** is what opens. It is the curated shortlist from
[`keys/quick.tsv`](https://github.com/MichaelWeissDEV/tmux-config/blob/main/keys/quick.tsv) —
the same list as the [quick reference](quick.md) — because showing 300 bindings
to someone asking "what can I press?" is not an answer.

**Active** is what is *actually* bound right now. It does not read a file to
decide that; it reads the running tmux server with `list-keys`. So it shows:

- keys an option turned off, correctly absent
- keys an enabled plugin added, correctly present
- anything you bound in `local.conf`, including where you overrode this config

**All** adds everything the registry knows but that is not currently in force —
bindings behind an option you have not set, and the tmux defaults that an
enabled feature displaces. Those are marked `[off]`.

Searching from the Quick view widens automatically to Active: searching a
shortlist would report "no such key" for keys that plainly exist. Clearing the
search hands Quick back.

## Search

Search matches, case-insensitively, across the key, its description, the tmux
command it runs, its category, its table, its origin, its owning plugin, and
its tags.

Tags are what make ordinary words work. They are written into the registry by
hand for this config's own keys, and derived from tmux's own command names and
descriptions for tmux's:

| Search | Finds |
| --- | --- |
| `split` | every split binding, in every table |
| `zoom` | <kbd>prefix</kbd> <kbd>z</kbd>, tagged `zoom fullscreen maximize` |
| `detach` | <kbd>prefix</kbd> <kbd>d</kbd>, tagged `detach leave disconnect` |
| `copy` | copy mode, the buffer keys, and the clipboard bindings |
| `session` | every session binding |

There is no fuzzy matching, no ranking and no index — a plain substring test
over a 300-line file, which is instant and, more importantly, explainable.

## Details

<kbd>Enter</kbd> on a binding shows where it came from and what it cost:

```text
Prefix l

Select the pane to the right

Table       prefix
Category    Panes
Origin      tmux default displaced by tmux-config
Status      bound now
Runs        select-pane -R
Displaces   last-window

Why         Completes the vi-style h/j/k/l pane row, which is why this one
            key displaces a default. tmux binds l to last-window; that is
            still available on prefix Tab, which this config adds for
            exactly this reason.
```

That `Displaces` line is the point. This config changes four tmux defaults in
total, and each one has to say what it took and where the original went.

## What it costs

Nothing until you press <kbd>prefix</kbd> <kbd>H</kbd>, and very little then.

The static data is generated offline into a single committed file. Opening the
Explorer reads that file and runs `list-keys` once. There is no daemon, no
cache to warm, no repository scan, and nothing at all happens at tmux startup.
See [philosophy](../philosophy.md).

## Requirements

A POSIX shell, `awk`, `sed` and `printf`. That is the whole list. No Python, no
Node, no compiled helper, no Nerd Font, and no `fzf` — philosophy rules 10, 11
and 19.

`fzf` is supported as a convenience if you already have it:

```tmux
set -g @cfg_key_explorer_fzf "on"
```

With that on and `fzf` installed, search runs through `fzf` instead. With it
off, or `fzf` missing, the built-in search does the same job — the test suite
asserts this by putting a booby-trapped `fzf` first on `PATH` and checking the
Explorer never calls it.

## Running it outside tmux

```bash
./scripts/key-explorer --dump active
```

Prints the rows as TSV and exits — useful when debugging why a key is or is not
showing up. Without a tmux server to ask, every registered binding is reported
as bound, which is the honest answer when there is nothing to consult.
