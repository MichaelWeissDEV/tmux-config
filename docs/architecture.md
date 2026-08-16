# Architecture

Why the config is split the way it is. Read this before adding a module or
sending a pull request — several of the constraints below are non-obvious, and
every one of them was verified against tmux 3.7 rather than assumed.

---

## File layout

```
~/.config/tmux/
├── tmux.conf                 # loader — version gate, then sources everything
├── config/
│   ├── 00-options.conf       # your settings; must load first
│   ├── 10-general.conf       # core behaviour
│   ├── 20-keys.conf          # prefix, panes, windows, sessions
│   ├── 30-copy-mode.conf     # selection and yanking
│   ├── 40-clipboard.conf     # clipboard routing (reads @cap_*)
│   ├── 50-theme.conf         # picks a palette file
│   ├── 60-status.conf        # status bar layout
│   ├── 70-plugins.conf       # sources the plugin adapters
│   └── themes/*.conf         # ten colour variables each
├── capabilities/
│   ├── detect.conf           # probes the environment, sets @cap_*
│   ├── terminal.conf         # colour depth, terminal-features, extended keys
│   └── symbols.conf          # Unicode vs ASCII glyph set (@sym_*)
├── terminals/
│   └── corrections.conf      # targeted fixes for known-broken terminals
├── plugins/*.conf            # one adapter per plugin — never source vendor/ directly
├── vendor/                   # vendored plugins (git subtree)
├── vendor-manifest/
│   ├── plugins.toml          # upstream, branch, pinned revision, licence
│   └── licenses/
├── local.conf                # yours, gitignored, loaded last
├── scripts/
│   ├── info · doctor · check
│   ├── update-vendor
│   └── gen-upstream-keys · gen-keys · gen-docs · gen-options.py
└── tests/run
```

Load order, as set by `tmux.conf`:

```
00-options  →  capabilities/detect  →  10-general  →  capabilities/terminal
            →  capabilities/symbols →  terminals/corrections
            →  20-keys → 30-copy-mode → 40-clipboard → 50-theme → 60-status
            →  70-plugins → plugins/*  →  local.conf
```

Detection runs early because every later module branches on `@cap_*`.

Numbering is load order. It is also dependency order: nothing may depend on a
file with a higher number.

---

## The `%if` trap

This single behaviour dictates the whole layout.

**tmux evaluates `%if` at parse time, for a whole file, before any line of that
file has run.**

Which means:

=== "Works"

    An option set in a **previously sourced** file is visible.

    ```tmux
    # tmux.conf
    source-file -q "~/.config/tmux/config/00-options.conf"
    source-file -q "~/.config/tmux/config/10-general.conf"
    ```

    ```tmux
    # 10-general.conf  — @cfg_dim_inactive already exists
    %if "#{==:#{@cfg_dim_inactive},on}"
      setw -g window-style "fg=colour247"
    %endif
    ```

=== "Silently fails"

    An option set **earlier in the same file** is not visible.

    ```tmux
    set -g @flag "on"

    %if "#{==:#{@flag},on}"   # reads empty — the block never runs
      set -g @proof "never happens"
    %endif
    ```

    No error. The block is simply skipped.

That is exactly why `00-options.conf` is its own file, sourced before
everything else. It buys every later module the ability to branch on your
settings with zero shell forks.

**A synchronous `if-shell` in an earlier file IS visible to a later `%if`** —
but a backgrounded one (`if-shell -b`) is not, because the option is still
unset when the next file is parsed. That is exactly why
`capabilities/detect.conf` runs its probes without `-b`. Verified.

If you need a runtime conditional inside one file, use `if-shell -F`:

```tmux
if-shell -F '#{==:#{@flag},on}' 'set -g @proof "works"' ''
```

It costs a fork, but it is evaluated when the line executes.

---

## Why modules are sourced one line at a time

A glob would be shorter:

```tmux
source-file -q "~/.config/tmux/config/[0-9]*.conf"   # do not do this
```

It loads the files in the right order — but tmux parses **all** matched files
as a single unit, which breaks the `%if` contract above. Every module's
conditional silently reads an empty value.

Explicit lines are more verbose and they work.

---

## Paths

`source-file` is more limited than it looks. Verified behaviour:

| Form | Works | Note |
| --- | :---: | --- |
| `~/.config/tmux/x.conf` | :material-check: | Tilde is expanded |
| `$SOME_VAR/x.conf` | :material-check: | Environment variables are expanded |
| `~/.config/tmux/*.conf` | :material-check: | Globs work, but see the warning above |
| `config/x.conf` | :material-close: | Not relative to the sourcing file |
| `#{d:current_file}/x.conf` | :material-close: | **Formats are not expanded** |

The last row is why the install path cannot be auto-detected, and why
`~/.config/tmux` is written out in full. `setenv` does not help either — it
sets the *session* environment, which `source-file` does not consult.

The path appears in four files: `tmux.conf`, `20-keys.conf` (the reload
binding), `50-theme.conf`, and `70-plugins.conf`. `install.sh` symlinks the
repository there, so editing the repo is live and no reinstall is needed.

### If `XDG_CONFIG_HOME` is not `~/.config`

`install.sh` detects this, switches to copy mode, and rewrites the paths in the
installed copy. The repository itself is left untouched.

This matters more than it looks: because every module is sourced with
`source-file -q`, a config installed at a path it does not expect loads
`tmux.conf`, finds none of its modules, and reports **no error at all**. The
installer therefore verifies a sentinel option (`@thm_accent`, which only gets
set if options → theme loader → theme file all ran) rather than trusting an
empty stderr.

---

## Why the theme loader looks like that

```tmux
%if "#{==:#{@cfg_theme},nord}"
  source-file -q "~/.config/tmux/config/themes/nord.conf"
%endif
```

The obvious version does not work, for the reason in the table above:

```tmux
source-file -q "~/.config/tmux/config/themes/#{@cfg_theme}.conf"   # literal path
```

The chain is repetitive, but it resolves at parse time and spawns nothing.

---

## Passing values through: `set -F`

```tmux
set -gF history-limit "#{@cfg_history_limit}"
```

Without `-F`, tmux stores the literal string `#{@cfg_history_limit}` and
reports no error. With it, the format is expanded first.

`set -F` handles every pass-through setting in this config. `%if` is only used
where a setting needs several lines or a different code path.

### Colour options versus style options

There is an asymmetry here that is easy to trip over, and it fails in the
worst way — the option keeps its old value and tmux carries on.

| Option kind | Example | Needs `-F`? |
| --- | --- | :---: |
| **Style** (`*-style`) | `pane-active-border-style "fg=#{@thm_accent}"` | no — expanded when drawn |
| **Colour** (`*-colour`) | `display-panes-colour "#{@thm_subtle}"` | **yes** |

Colour-typed options are validated at set time and do not expand formats, so
without `-F` tmux reports `bad colour: #{@thm_subtle}` and keeps its default.
Three lines in `60-status.conf` were wrong this way until
`scripts/check` caught it — the parse check (`source-file -n`) sees it, while
simply loading the config does not, because the message is not fatal.

---

## The one place strftime bites

```tmux
set -g status-right "#[fg=#{@thm_muted}]#{T:#{@cfg_clock_format}} "
```

tmux runs `strftime` over the status string **before** it resolves
`#{@variables}`. A `%H:%M` arriving through `#{@cfg_clock_format}` therefore
lands after that pass and would print literally as `%H:%M`.

`#{T:...}` forces a second, explicit time expansion on the resolved value.

---

## Performance

Three decisions carry essentially all of it:

1. **Conditionals resolve at parse time.** `%if` costs nothing. Startup forks
   exactly twice: the version gate, and `scripts/detect`, which probes the
   whole environment in one shell and applies the result with a single sourced
   command file. Everything downstream reads the resulting `@cap_*` values with
   `%if`. See [Capabilities → Cost](reference/capabilities.md#cost).

2. **No `#(shell)` in the status bar.** A `#()` forks a process every
   `status-interval`, for every attached client. This is the usual cause of a
   tmux that feels heavy. See
   [Status bar performance](configuration/index.md#status-bar-performance).

3. **Plugins are off.** Nothing in the config depends on one, so the default
   install has no runtime dependencies that can break or slow startup.

Measure your own startup with:

```bash
time tmux -f ~/.config/tmux/tmux.conf -L bench new-session -d \; kill-server
```

---

## Adding a module

1. Create `config/80-yourthing.conf`.
2. Add its `@cfg_*` settings to `00-options.conf`, with documented defaults.
3. Add one `source-file -q` line to `tmux.conf`, in order.
4. Read your options with `set -gF` or `%if` — never `set -g` with a format.
5. Give every binding an `-N "description"`, so it appears in the generated
   keybindings page.
6. Regenerate the docs and verify a clean load:

```bash
./scripts/gen-keys && ./scripts/gen-docs
tmux -f ~/.config/tmux/tmux.conf -L check new-session -d && tmux -L check kill-server
```

A clean load prints nothing. Any output is an error worth fixing.

---

## Testing without installing

The config hardcodes `~/.config/tmux`, so to test a working tree that is not
installed there, rewrite the paths into a temporary copy — which is exactly
what `scripts/gen-keys` and `scripts/gen-docs` do:

```bash
T=$(mktemp -d)
cp -R config "$T/config"
sed "s|~/.config/tmux|$T|g" tmux.conf > "$T/tmux.conf"
for f in "$T"/config/*.conf; do
  sed -i.bak "s|~/.config/tmux|$T|g" "$f" && rm -f "$f.bak"
done
tmux -f "$T/tmux.conf" -L test new-session -d && echo "loaded clean"
tmux -L test kill-server; rm -rf "$T"
```
