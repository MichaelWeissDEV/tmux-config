# Diagnostics

Three scripts, with three different jobs.

| Script | Question it answers | Use it when |
| --- | --- | --- |
| [`./scripts/info`](#info) | *What did the config decide on this machine?* | Something behaves differently than the docs say |
| [`./scripts/doctor`](#doctor) | *Is anything wrong with my environment?* | Something is broken and you want to know why |
| [`./scripts/check`](#check) | *Is the config itself sound?* | Before committing; in CI |

---

## info

Reports, never judges.

```bash
./scripts/info           # inspect the running server
./scripts/info --fresh   # load the repo into a throwaway server first
```

```
Platform
  OS                     macos
  display                none
  remote/SSH             no

Terminal
  TERM                   xterm-256color
  COLORTERM              truecolor
  colour depth           16m
  truecolor              yes (policy: auto)
  UTF-8                  yes (policy: auto)
```

The `(policy: …)` part is the useful bit: it shows the detected **fact** next
to your **setting**. `truecolor no (policy: on)` means detection disagreed with
you and your override won.

---

## doctor

Checks your environment and explains every problem it finds.

```bash
./scripts/doctor
```

```
Locale
  WARN  locale is not UTF-8 (charmap: ANSI_X3.4-1968)
        tmux replaces non-ASCII characters with '_'.
        The config detects this and uses ASCII separators automatically,
        so the status bar stays readable — but box-drawing will be plain.
        Fix: export LANG=en_US.UTF-8
```

It covers the tmux version, terminfo, colour support, locale, clipboard tooling,
whether the config actually loaded, the detected capabilities, and Neovim input
safety.

`WARN` means degraded but working. `FAIL` means broken. Exit status is `0`
unless something failed, so it is safe in CI.

!!! tip "The check that catches the nastiest failure"
    Every module is sourced with `source-file -q`, which is **silent** when a
    file is missing. A config installed at the wrong path therefore loads with
    no error and does nothing.

    `doctor` verifies a sentinel option instead of trusting an empty error
    stream. So does `install.sh`.

---

## check

Static checks about the config itself — no judgement about your machine, so it
is meaningful on a CI runner.

```bash
./scripts/check
```

1. Every `.conf` parses (via `tmux source-file -n`, which parses without
   executing).
2. The config loads and all modules applied.
3. No key is bound twice in the same key table.
4. No Ctrl-based key is intercepted globally
   ([the hard rule](../philosophy.md)).
5. Every `@cfg_*` used by a module is defined in `00-options.conf`.
6. The generated docs are in sync with the config.

Check 6 matters more than it sounds: the keybindings and options pages are
generated, so a config change without a regeneration would publish docs
describing something that no longer exists.

---

## tests/run

Behaviour tests across environments — what `check` cannot do, because it runs
in only one.

```bash
./tests/run
```

It loads the config under 13 different `$TERM` values, with and without a
UTF-8 locale, with and without SSH variables, and asserts the resulting
behaviour: that ASCII fallback actually engages, that tri-state overrides beat
detection, that every theme resolves, and that no Ctrl key is intercepted.

```
Tri-state overrides beat detection
  ok    symbols=ascii forces ASCII despite UTF-8
  ok    symbols=unicode forces Unicode despite C locale

38 passed, 0 failed
```

---

## In CI

`.github/workflows/ci.yml` runs `check` and `tests/run` on Ubuntu and macOS,
then again inside Debian, Fedora, Arch and Alpine containers — the environments
where locale and clipboard tooling are genuinely absent, which a GitHub runner
hides.

A separate job builds the docs exactly as Read the Docs does
(`mkdocs build --strict`) and fails if the generated pages are stale.

---

## Reporting a problem

```bash
./scripts/info --fresh
./scripts/doctor
tmux -V; echo "TERM=$TERM LANG=$LANG"; uname -a
```
