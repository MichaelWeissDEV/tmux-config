#!/usr/bin/env python3
"""
gen-options.py — generate docs/reference/options.md from config/00-options.conf

The options file already documents every setting inline: a comment block, an
optional `#   values:` line, and the `set -g @cfg_* "default"` itself. Parsing
that is strictly better than maintaining a second copy of the same table by
hand, which drifts the moment anyone adds an option.

Usage:
    ./scripts/gen-options.py > docs/reference/options.md
"""

import pathlib
import re
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
SRC = ROOT / "config" / "00-options.conf"

SECTION_RE = re.compile(r"^#\s{2}(\S.*?)\s*$")
RULE_RE = re.compile(r"^#\s*-{10,}\s*$")
SET_RE = re.compile(r'^set\s+-g\s+(@cfg_\w+)\s+"([^"]*)"')
# Matched against comment text that has already had its leading '#' stripped.
VALUES_RE = re.compile(r"^values:\s*(.+)$", re.I)


def parse(text):
    """Yield ('section', name) and ('option', {...}) events in file order."""
    section = None
    buf = []          # comment lines since the last blank/section
    prev_was_rule = False

    for raw in text.splitlines():
        line = raw.rstrip()

        if RULE_RE.match(line):
            prev_was_rule = True
            buf = []
            continue

        m = SECTION_RE.match(line)
        if m and prev_was_rule:
            # A heading is the comment line sandwiched between two rules.
            candidate = m.group(1)
            if not candidate.startswith("-") and len(candidate) < 60:
                section = candidate
                yield ("section", candidate)
            prev_was_rule = False
            buf = []
            continue

        prev_was_rule = False

        if line.startswith("#"):
            buf.append(line.lstrip("#").strip())
            continue

        m = SET_RE.match(line)
        if m:
            name, default = m.group(1), m.group(2)
            values = None
            desc = []
            for c in buf:
                v = VALUES_RE.match(c)
                if v:
                    values = v.group(1).strip()
                elif values is not None:
                    # continuation of a wrapped `values:` line
                    if c.startswith("|") or c.startswith("| "):
                        values += " " + c
                    elif c:
                        desc.append(c)
                elif c:
                    desc.append(c)
            yield ("option", {
                "name": name,
                "default": default,
                "values": values,
                "desc": desc,
                "section": section,
            })
            buf = []
            continue

        if not line:
            buf = []


def fmt_values(v):
    if not v:
        return "—"
    parts = [p.strip() for p in v.replace("|", "\x00").split("\x00")]
    parts = [p for p in parts if p]
    return " · ".join(f"`{p}`" for p in parts)


def first_sentence(desc):
    """The first paragraph, collapsed — enough for a summary table."""
    out = []
    for line in desc:
        if not line:
            break
        out.append(line)
    text = " ".join(out)
    return text if text else "—"


def main():
    if not SRC.exists():
        sys.exit(f"not found: {SRC}")

    events = list(parse(SRC.read_text()))
    options = [e[1] for e in events if e[0] == "option"]

    print("# Options reference")
    print()
    print(":::{note} This page is generated")
    print("Produced from `config/00-options.conf` by `scripts/gen-options.py`,")
    print("so it cannot drift from the actual defaults. Regenerate with:")
    print()
    print("```bash")
    print("./scripts/gen-options.py > docs/reference/options.md")
    print("```")
    print(":::")
    print()
    print("Every option below is set in "
          "[`config/00-options.conf`](../configuration/index.md). Override it in "
          "`local-options.conf`, then press <kbd>Ctrl</kbd>+<kbd>b</kbd> "
          "<kbd>R</kbd> to reload.")
    print()

    # --- summary table ---------------------------------------------------
    print("## All options at a glance")
    print()
    print("| Option | Default | Accepted values |")
    print("| --- | --- | --- |")
    for o in options:
        default = f"`{o['default']}`" if o["default"] != "" else '`""`'
        print(f"| [`{o['name']}`](#{o['name'].replace('_', '-').lstrip('@')}) "
              f"| {default} | {fmt_values(o['values'])} |")
    print()

    # --- detail, grouped by section --------------------------------------
    current = None
    for kind, payload in events:
        if kind == "section":
            current = payload
            continue
        o = payload
        if o["section"] != current:
            current = o["section"]
        if o is options[0] or (o["section"] and o["section"] != getattr(main, "_last", None)):
            if o["section"] != getattr(main, "_last", None):
                print(f"## {o['section']}")
                print()
                main._last = o["section"]

        anchor = o["name"].replace("_", "-").lstrip("@")
        print(f"({anchor})=")
        print(f"### `{o['name']}`")
        print()
        print("```tmux")
        print(f'set -g {o["name"]} "{o["default"]}"')
        print("```")
        print()
        if o["values"]:
            print(f"**Accepted values:** {fmt_values(o['values'])}")
            print()
        for line in o["desc"]:
            print(line if line else "")
        print()


if __name__ == "__main__":
    main()
