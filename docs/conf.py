"""Sphinx configuration for tmux-config documentation.
Builds with Sphinx + MyST + Furo.
"""

import pathlib
import sys

from pygments.lexers.configs import IniLexer
from pygments.lexers.special import TextLexer
from sphinx.highlighting import lexers

# Map 'tmux' codeblocks to IniLexer and 'mermaid' to TextLexer
lexers["tmux"] = IniLexer()
lexers["mermaid"] = TextLexer()

sys.path.insert(0, str(pathlib.Path(__file__).parent))

project = "tmux-config"
copyright = "2026, Michael Weiss"
author = "Michael Weiss"

extensions = [
    "myst_parser",
    "sphinx_copybutton",
]

source_suffix = {
    ".md": "markdown",
}

myst_enable_extensions = [
    "colon_fence",
    "deflist",
    "attrs_inline",
    "fieldlist",
]

exclude_patterns = ["_build", "Thumbs.db", ".DS_Store", ".venv", "stylesheets"]

myst_heading_anchors = 3
suppress_warnings = ["myst.header", "myst.xref_missing"]

html_theme = "furo"
html_title = "tmux-config docs"
html_theme_options = {
    "source_repository": "https://github.com/MichaelWeissDEV/tmux-config",
    "source_branch": "main",
    "source_directory": "docs/",
    "light_css_variables": {
        "color-brand-primary": "#1e66f5",
        "color-brand-content": "#1e66f5",
    },
    "dark_css_variables": {
        "color-brand-primary": "#89b4fa",
        "color-brand-content": "#89b4fa",
        "color-background-primary": "#1e1e2e",
        "color-background-secondary": "#181825",
    },
}

html_static_path = []

master_doc = "index"

pygments_style = "friendly"
pygments_dark_style = "monokai"

nitpicky = False
