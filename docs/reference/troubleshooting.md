# Troubleshooting

## First: does the config load cleanly?

```bash
tmux -f ~/.config/tmux/tmux.conf -L check new-session -d && tmux -L check kill-server
```

Silence means success. Any output is the error, with the file and line number.
This uses a separate socket (`-L check`), so it cannot disturb a running
session.

---

## Colours are wrong or washed out

The most common tmux problem, and it is almost always one of three things.

**Check what your terminal claims to be, outside tmux:**

```bash
echo $TERM              # expect xterm-256color, or your terminal's own entry
tmux info | grep -i RGB # inside tmux: expect RGB or Tc to be present
```

**Check that true colour actually works, inside tmux:**

```bash
printf '\033[38;2;255;100;0mIf this is ORANGE, true colour works\033[0m\n'
```

If it comes out muddy brown, tmux is not passing 24-bit colour.

### Fixes

`default-terminal` must be a `screen*` or `tmux*` entry — never
`xterm-256color`. This config sets `tmux-256color`, which is correct. The
problem is usually on the outside:

```bash title="in your ~/.bashrc or ~/.zshrc — NOT inside tmux"
export TERM=xterm-256color
```

If your terminal is not covered, add it in `local.conf`:

```tmux
set -as terminal-features ",your-terminal-name:RGB"
```

Find the name with `echo $TERM` **outside** tmux.

---

## "missing or unsuitable terminal: tmux-256color"

Your system has no `tmux-256color` terminfo entry. Common on macOS and older
distros.

#### macOS

    ```bash
    /usr/bin/infocmp -x tmux-256color > /tmp/tmux-256color.src
    /usr/bin/tic -x /tmp/tmux-256color.src
    ```

    If that fails because the entry does not exist at all:

    ```bash
    brew install ncurses
    ```

#### Linux

    ```bash
    sudo apt install ncurses-term      # Debian/Ubuntu
    sudo dnf install ncurses-term      # Fedora
    ```

As a fallback, put this in `local.conf`:

```tmux
set -g default-terminal "screen-256color"
```

---

## Copying does not reach my clipboard

### Work out which path should be doing it

```bash
tmux show -gv @cfg_detected_os   # what the config detected
tmux show -gv copy-command       # the helper it chose
tmux show -gv set-clipboard      # OSC 52 state
```

Setting `@cfg_status_style` to `detailed` also shows the detected platform in
the status bar.

### Local tmux

`copy-command` should be non-empty and the tool should exist:

| Platform | Expected | Install if missing |
| --- | --- | --- |
| macOS | `pbcopy` | built in |
| Wayland | `wl-copy` | `sudo apt install wl-clipboard` |
| X11 | `xclip -selection clipboard -in` | `sudo apt install xclip` |
| WSL | `clip.exe` | built in |

Test the tool directly, outside tmux:

```bash
echo hello | pbcopy      # or wl-copy / xclip -selection clipboard -in
```

If that fails, the problem is not tmux.

### Over SSH

A local helper puts text on the **remote** machine's clipboard. Crossing back
to your own machine needs OSC 52, which needs terminal support:

| Terminal | OSC 52 |
| --- | :---: |
| Ghostty, kitty, WezTerm, Alacritty, foot | ✓ |
| iTerm2 | ✓ (enable in Preferences → General → Selection) |
| Windows Terminal | ✓ |
| xterm | ✓ (needs `allowWindowOps: true`) |
| **macOS Terminal.app** | ✗ — no support; use iTerm2 or Ghostty |
| GNOME Terminal / older VTE | ✗ |

Verify OSC 52 independently of tmux:

```bash
printf "\033]52;c;$(printf 'osc52-works' | base64)\007"
```

Then paste. If nothing arrives, your terminal does not support it.

### Wayland session picking xclip

Under XWayland both tools may exist. The config checks `$WAYLAND_DISPLAY`
first, but if detection still lands wrong, force it:

```tmux title="local.conf"
set -g copy-command 'wl-copy'
```

---

(status-bar-shows-underscores)=
## Status bar shows underscores instead of `•` and `│`

Your locale is not UTF-8, so tmux replaces non-ASCII characters with `_`.

```bash
locale        # expect LANG=...UTF-8
```

Fix it in your shell profile:

```bash
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
```

On a minimal Debian image you may need to generate it first:

```bash
sudo apt install locales && sudo locale-gen en_US.UTF-8
```

Then `tmux kill-server` and start again — the locale is read at server startup.

Or avoid the characters entirely:

```tmux title="local.conf"
set -g status-right "#[fg=#{@thm_muted}]#{T:#{@cfg_clock_format}} | #{T:#{@cfg_date_format}} "
```

---

## Neovim feels laggy leaving insert mode

`escape-time`. tmux's default of 500 ms is the culprit; this config sets 10.

```bash
tmux show -sv escape-time    # expect 10
```

If it reports 500, the config is not being loaded — check with the clean-load
test at the top of this page. Note it is a **server** option, so `tmux
kill-server` is needed for a change to take effect, not just a reload.

Also confirm focus events are on, which Neovim needs for `autoread`:

```bash
tmux show -gv focus-events   # expect on
```

---

## My changes do not take effect

In order of likelihood:

1. **You did not reload.** ++ctrl+b<kbd> </kbd>r++.
2. **The setting only applies to new panes.** `escape-time`,
   `default-terminal`, and several window options are read when a pane is
   created. Open a new one, or `tmux kill-server`.
3. **You edited the wrong file.** `local.conf` loads last and wins over
   `config/00-options.conf`. Check whether you set the same option twice.
4. **You used `set -g` where a format needs `set -gF`.**

   ```tmux
   set -g  mouse "#{@cfg_mouse}"   # stores the literal text — silently wrong
   set -gF mouse "#{@cfg_mouse}"   # correct
   ```

   Colour-typed options (`display-panes-colour`, `clock-mode-colour`) also
   need `-F`, while style options (`*-style`) do not. Without it you get
   `bad colour: #{...}` and the old value is kept. Run `./scripts/check` —
   its parse pass catches exactly this.

5. **You used `%if` against an option set earlier in the same file.** It reads
   empty and the block is skipped, with no error. This is the sharpest edge in
   tmux configuration — see [The `%if` trap](../architecture.md#the-if-trap).

Check what tmux actually holds:

```bash
tmux show -gv mouse
tmux show -gv @cfg_theme
```

---

## Alt+number does nothing, or breaks an application

`@cfg_alt_window_keys` binds ++alt+1<kbd>…</kbd>alt+9++ globally, so tmux takes them
before the program in your pane sees them.

- **Does nothing:** your terminal is sending a different sequence for Alt. In
  iTerm2, set the Option key to "Esc+". In some terminals it is "Meta".
- **Breaks an app:** that is the documented tradeoff. Turn it off:

```tmux title="config/00-options.conf"
set -g @cfg_alt_window_keys "off"
```

---

## Mouse scroll behaves oddly

With `@cfg_mouse "on"`, scrolling up enters copy mode — that is intended, and
<kbd>q</kbd> leaves it.

If you want your terminal's own scrollback and selection instead:

```tmux
set -g @cfg_mouse "off"
```

To keep the mouse but select text with the terminal, hold <kbd>shift</kbd> while
dragging. This works in most terminals and bypasses tmux entirely.

---

## Nested tmux (local + remote over SSH)

The inner session needs a different prefix, or the outer one swallows
everything. On the **remote** machine:

```tmux title="local.conf"
set -g @cfg_prefix "C-a"
```

Alternatively, press ++ctrl+b++ twice to send the prefix through to the inner
session — the config binds `send-prefix` for this.

---

## Still stuck

Collect this before opening an issue:

```bash
tmux -V
echo "TERM=$TERM  LANG=$LANG"
uname -a
tmux show -gv @cfg_detected_os
tmux -f ~/.config/tmux/tmux.conf -L check new-session -d 2>&1; tmux -L check kill-server 2>/dev/null
```
