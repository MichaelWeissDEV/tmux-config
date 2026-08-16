# Recipes

Ready-to-use additions. Every one of these is already in
[`local.conf.example`](https://github.com/MichaelWeissDEV/tmux-config/blob/main/local.conf.example),
commented out — copy that file and uncomment what you want:

```bash
cp ~/.config/tmux/local.conf.example ~/.config/tmux/local.conf
```

`local.conf` is loaded last and is gitignored, so nothing here can be lost by
`git pull`.

---

## Popups

A floating window over the current session. Nothing is added to your layout,
and closing it leaves no trace. Requires tmux 3.2+.

<kbd>prefix</kbd> <kbd>g</kbd> already opens a scratch shell in the current
directory.

=== "lazygit"

    ```tmux
    bind -N "Open lazygit" G display-popup -E -w 90% -h 90% \
      -d "#{pane_current_path}" lazygit
    ```

=== "Notes"

    ```tmux
    bind -N "Open notes" N display-popup -E -w 70% -h 70% \
      "${EDITOR:-vi} ~/notes.md"
    ```

=== "man page"

    ```tmux
    bind -N "Look up a man page" M command-prompt -p "man:" \
      "display-popup -E -w 80% -h 80% 'man %%'"
    ```

=== "htop"

    ```tmux
    bind -N "Process viewer" T display-popup -E -w 90% -h 90% "htop"
    ```

!!! tip "`-d` is what makes a popup useful"
    `-d "#{pane_current_path}"` opens the popup in the directory of the pane
    you were in. Without it you land in `$HOME`, which makes a git popup
    useless.

---

## Session and project switching

### fzf session switcher

Faster than `choose-tree` once you have more than a handful of sessions. Needs
`fzf`.

```tmux
bind -N "Switch session (fzf)" C-s display-popup -E -w 40% -h 40% "\
  tmux list-sessions -F '#{session_name}' \
  | fzf --reverse --header='switch session' \
  | xargs -r tmux switch-client -t"
```

### Open a project as its own session

Creates the session if it does not exist, then switches to it. Adjust `~/src`.

```tmux
bind -N "Open a project" P display-popup -E -w 60% -h 60% "\
  find ~/src -mindepth 1 -maxdepth 1 -type d \
  | fzf --reverse --header='open project' \
  | xargs -r -I{} sh -c 'tmux new-session -d -s \$(basename {} | tr . _) -c {} 2>/dev/null; \
                         tmux switch-client -t \$(basename {} | tr . _)'"
```

Session names cannot contain dots, hence the `tr . _`.

---

## Status bar additions

!!! danger "Read this before adding any `#()`"
    A `#(command)` in the status bar forks a process on **every refresh, for
    every attached client**. At the default 5 s interval with two clients
    attached, that is a process every 2.5 seconds, forever.

    This is the single most common reason a tmux config feels heavy. The
    default status bar contains no `#()` at all.

    **Rules:** keep the command under ~50 ms, raise `status-interval` to 15 s
    or more, and never combine `#()` with `status-interval 1`.

### Git branch

```tmux
set -g status-interval 15
set -ag status-right "#[fg=#{@thm_subtle}]#{@sym_sep} #[fg=#{@thm_muted}]\
#(cd '#{pane_current_path}' && git branch --show-current 2>/dev/null) "
```

### SSH warning — free

This one costs nothing: it is a format, not a subprocess. `@cap_ssh` was
resolved once at startup.

```tmux
set -ag status-right "#{?#{==:#{@cap_ssh},yes},#[fg=#{@thm_urgent}#,bold] SSH ,}"
```

A visible marker for "this is not my machine" is worth more than most status
widgets.

!!! note "Why the `#,` in there"
    Inside a `#{?...}` conditional, a comma separates the branches. A literal
    comma — such as the one in `fg=…,bold` — must be escaped as `#,`.

---

## Appearance

### Override one theme colour

Theme variables are ordinary options, but `60-status.conf` was parsed before
`local.conf`, so anything that already consumed the old value must be
re-applied:

```tmux
set -g @thm_accent "#ff8800"
set -g pane-active-border-style "fg=#{@thm_accent}"
set -g status-left "#{?client_prefix,#[bg=#{@thm_urgent}],#[bg=#{@thm_accent}]}\
#[fg=#{@thm_bg},bold] #S #[default] "
```

For more than one colour, copy a theme file instead — see [Theming](themes.md).

### Powerline separators

Needs a patched/Nerd Font. The default deliberately avoids them so the config
works on a fresh machine and over SSH.

```tmux
set -g window-status-current-format \
  "#[fg=#{@thm_surface},bg=#{@thm_bg}]#[fg=#{@thm_accent},bg=#{@thm_surface},bold] #I \
#[fg=#{@thm_fg}]#W #[fg=#{@thm_surface},bg=#{@thm_bg}]"
```

### Pane titles

Costs one line of height per pane.

```tmux
set -g pane-border-status top
set -g pane-border-format " #{pane_index}: #{pane_current_command} "
```

---

## Copy mode

### Copy the visible pane

```tmux
bind -N "Copy the visible pane" Y \
  run-shell "tmux capture-pane -p | tmux load-buffer - && tmux display 'pane copied'"
```

### Copy the current path

```tmux
bind -N "Copy the current path" C-y \
  run-shell "printf '%s' '#{pane_current_path}' | tmux load-buffer - && tmux display 'path copied'"
```

### Open a URL from the pane

Scrapes the last 3000 lines for URLs. Needs `fzf`.

```tmux
bind -N "Open a URL from this pane" u display-popup -E -w 70% -h 40% "\
  tmux capture-pane -p -S -3000 \
  | grep -oE 'https?://[^ \"'\\'')>]+' | sort -u \
  | fzf --reverse --header='open URL' \
  | xargs -r \${BROWSER:-open}"
```

For anything more than URLs, the `extrakto` plugin does this properly — see
[Plugins](../plugins/available.md).

---

## Machine-specific configuration

One dotfiles repository, different behaviour per host.

### By hostname

```tmux
if-shell -b '[ "$(hostname -s)" = "work-laptop" ]' " \
  set -g @thm_accent '#f38ba8' ; \
  set -g status-position top "
```

### By capability

`@cap_*` values are available here, so you can branch on what was detected —
at parse time, with no shell fork:

```tmux
%if "#{==:#{@cap_ssh},yes}"
  set -g @cfg_prefix "C-a"        # avoid clashing with the outer tmux
  set -g @thm_accent "#f9e2af"    # visibly different when remote
%endif

%if "#{!=:#{@cap_utf8},yes}"
  set -g @cfg_symbols "ascii"
%endif
```

See [Capabilities](../reference/capabilities.md) for the full list.

---

## Nested tmux

When you SSH from tmux into tmux, the outer server swallows every prefix. Give
the **inner** one a different prefix, in its own `local.conf`:

```tmux
set -g @cfg_prefix "C-a"
set -g @thm_accent "#f9e2af"   # so you can see which one you are in
```

Alternatively, press <kbd>Ctrl</kbd>+<kbd>b</kbd> twice to send the prefix
through — the config binds `send-prefix` for whatever prefix you configured.
