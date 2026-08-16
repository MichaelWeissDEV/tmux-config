# Philosophy

The design rules this project holds itself to. They are listed here because
they are enforced — `scripts/check` and `tests/run` fail the build when the
input-safety and option-definition rules are broken.

---

## The rules

1. **Preserve tmux defaults.** No global `unbind-key -a`, ever, and no blanket
   reset of a key table. Every default binding keeps working; this project adds
   to tmux, it does not replace its interaction model.
2. **Improve a default, never repurpose it.** A tmux binding may be made better
   at the job it already does — <kbd>prefix</kbd> <kbd>c</kbd> opening a window
   in the current directory is an improvement. Giving that key an *unrelated*
   job is not, and is forbidden. Where the rule is deliberately broken, the
   exception is registered, justified, and shown to the user; see
   [the key model](#the-key-model) below.
3. **Do not intercept application input by default** — with one documented
   exception, below.
4. **Neovim receives terminal input unchanged.** No Ctrl-based key is taken
   globally by the default config.
5. **Native tmux before plugins.** If current tmux can do it properly, the
   plugin does not ship.
6. **Plugins are optional and vendored.** All off by default.
7. **Unknown terminals get conservative behaviour.** Nothing is assumed.
8. **Capabilities are detected, not assumed.**
9. **SSH is a primary supported environment**, not an afterthought.
10. **No mandatory Nerd Fonts.**
11. **No mandatory external tools.**
12. **No hidden downloads.** tmux never fetches anything at startup.
13. **No automatic plugin updates.**
14. **User overrides always load last.**
15. **Every feature is documented.**
16. **Every binding has an owner and a scope.**
17. **Every plugin has a pinned upstream revision.**
18. **Configuration must be testable.**
19. **The core keeps working when every optional dependency is absent.**
20. **Visual defaults stay minimal.**
21. **Stability beats cleverness.**

---

## The one exception to rule 3

**<kbd>Alt</kbd>+<kbd>1</kbd>…<kbd>9</kbd> is bound globally by default.**

This is a real deviation from rule 3 and is called out rather than hidden. A
`bind -n` binding means tmux consumes the key **before** the program in your
pane sees it. Alt+number is used by terminal browsers, some TUI applications,
and Windows Terminal's own tab switching.

It is the default because jumping straight to a window is the single most-used
action in day-to-day tmux, and requiring the prefix for it costs more than the
collision does for most people.

The narrower form of rule 3 that this project actually enforces:

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

It is **off by default** precisely because it breaks rule 4, and
`scripts/check` reports the interception when you enable it. That is intended:
the tool tells you the truth about what your config does, rather than making an
exception for a plugin the project happens to ship.

See [Neovim](integration/neovim.md).

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
[Capabilities](reference/capabilities.md).

---

## The key model

Rule 2 is the one that needed machinery rather than good intentions, because
"do not repurpose a default" is easy to write down and easy to break by
accident. So the keys are data, not prose.

Every binding this project knows about — tmux's own included — lives in a
registry under `keys/`. The upstream half is **captured from tmux itself** by
starting a pristine server and reading `list-keys`; it is never transcribed
from a cheat sheet, a blog post or anybody's memory. Each of this config's own
bindings declares its provenance:

| Origin | Meaning |
| --- | --- |
| `tmux` | a plain tmux default, untouched |
| `tmux-enhanced` | a default kept for **the same purpose**, improved |
| `tmux-config` | added on a key tmux leaves free |
| `tmux-override` | a default **displaced** — the exception to rule 2 |

`scripts/check-key-conflicts` then enforces the rule mechanically. It fails the
build when a binding takes a tmux default without declaring it, when something
claiming to be an *enhancement* actually changed the command's purpose, and
when an *override* does not say what it displaced and where that behaviour went.
`scripts/check` additionally compares the registry against a live tmux server in
both directions, so a binding cannot exist without being written down, and a
registered binding cannot quietly stop working.

The whole config displaces **four** tmux defaults. Each one is listed in the
[complete keymap](keybindings/complete.md) with its justification, and the
[Key Explorer](keybindings/key-explorer.md) shows you the displaced command when
you inspect the key.

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
| Improve, never repurpose | `prefix r` meaning "reload" in one config and "refresh" in every other |
| Keys captured from tmux | Hand-written keymap tables that are wrong within one release |
