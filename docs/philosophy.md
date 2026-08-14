# Philosophy

The design rules this project holds itself to. They are listed here because
they are enforced — `scripts/check` and `tests/run` fail the build when the
input-safety and option-definition rules are broken.

---

## The rules

1. **Preserve tmux defaults.** No global `unbind-key -a`, ever. Every default
   binding keeps working; this project adds to tmux, it does not replace its
   interaction model.
2. **Do not intercept application input by default** — with one documented
   exception, below.
3. **Neovim receives terminal input unchanged.** No Ctrl-based key is taken
   globally by the default config.
4. **Native tmux before plugins.** If current tmux can do it properly, the
   plugin does not ship.
5. **Plugins are optional and vendored.** All off by default.
6. **Unknown terminals get conservative behaviour.** Nothing is assumed.
7. **Capabilities are detected, not assumed.**
8. **SSH is a primary supported environment**, not an afterthought.
9. **No mandatory Nerd Fonts.**
10. **No mandatory external tools.**
11. **No hidden downloads.** tmux never fetches anything at startup.
12. **No automatic plugin updates.**
13. **User overrides always load last.**
14. **Every feature is documented.**
15. **Every binding has an owner and a scope.**
16. **Every plugin has a pinned upstream revision.**
17. **Configuration must be testable.**
18. **The core keeps working when every optional dependency is absent.**
19. **Visual defaults stay minimal.**
20. **Stability beats cleverness.**

---

## The one exception to rule 2

**<kbd>Alt</kbd>+<kbd>1</kbd>…<kbd>9</kbd> is bound globally by default.**

This is a real deviation from rule 2 and is called out rather than hidden. A
`bind -n` binding means tmux consumes the key **before** the program in your
pane sees it. Alt+number is used by terminal browsers, some TUI applications,
and Windows Terminal's own tab switching.

It is the default because jumping straight to a window is the single most-used
action in day-to-day tmux, and requiring the prefix for it costs more than the
collision does for most people.

The narrower form of rule 2 that this project actually enforces:

> **No Ctrl-based key is intercepted globally by default.**

That is the line that matters for Neovim, and it is checked automatically —
`scripts/check` fails if `C-h`, `C-j`, `C-k`, `C-l`, `C-w`, `C-v`, `C-o`,
`C-a`, `C-e`, `C-u`, `C-d` or `Escape` appears in the root key table.

Turn the exception off with one line:

```tmux title="config/00-options.conf"
set -g @cfg_alt_window_keys "off"
```

Then <kbd>prefix</kbd> <kbd>1</kbd>…<kbd>9</kbd> still works, and the default
config intercepts nothing at all.

---

## The second exception: vim-tmux-navigator

`@cfg_plugin_navigator` binds <kbd>Ctrl</kbd>+<kbd>h/j/k/l</kbd> globally and
forwards them when the pane is running vim or nvim.

It is **off by default** precisely because it breaks rule 3, and
`scripts/check` reports the interception when you enable it. That is intended:
the tool tells you the truth about what your config does, rather than making an
exception for a plugin the project happens to ship.

See [Neovim](neovim.md).

---

## What "maximum functionality" means here

Not *as many features as possible active*. Rather:

> as many capabilities as possible **available**, while the default stays
> small, stable and predictable.

Which produces three tiers:

| Tier | Always active? | Depends on | Example |
| --- | --- | --- | --- |
| **Core** | yes | tmux only | prefix, splits, copy mode, status bar |
| **Capabilities** | detected | environment | true colour, UTF-8 glyphs, clipboard route |
| **Plugins** | no | vendored code | resurrect, navigator |

A capability never *adds* behaviour you did not ask for — it decides how an
existing feature degrades. True colour becomes 256 colours; Unicode separators
become ASCII; a missing `wl-copy` falls back to OSC 52. The feature is still
there, it just does the best the environment allows.

---

## Why detection is not clever

Capability detection deliberately does **not** try to be exhaustive. It reads
the environment once at startup (`$TERM`, `$COLORTERM`, `$SSH_*`,
`locale charmap`) and otherwise defers to tmux's own `terminal-features` table.

There is a hard technical reason for that, not just taste:

!!! warning "tmux cannot tell you about the client while the config is parsing"
    `#{client_termfeatures}` and `#{client_termname}` are **empty** at config
    load time — the server is starting and no client has attached yet.
    Verified against tmux 3.7.

    So per-client capability logic cannot live in a config file at all. What
    *does* work is `terminal-features`, which is keyed by TERM glob and matched
    by tmux as each client attaches — which is why the config declares a table
    instead of computing values.

The consequence is a design that stays correct when three clients on three
different operating systems attach to the same server. See
[Capabilities](capabilities.md).

---

## Where the rules came from

Most of them are reactions to specific failure modes seen in shared tmux
configs:

| Rule | The failure it prevents |
| --- | --- |
| No `unbind-key -a` | A config that silently deletes muscle memory built over years |
| Native before plugins | `tmux-copycat` shipped long after tmux 3.1 made it redundant |
| Vendored, pinned plugins | An upstream force-push changing your terminal on a Monday |
| Detected, not assumed | `terminal-overrides ",xterm-256color:RGB"` on a terminal that cannot |
| Core works alone | A config that breaks entirely when one plugin fails to load |
| No hidden downloads | tmux hanging at startup on a machine with no network |
