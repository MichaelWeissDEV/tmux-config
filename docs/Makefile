SPHINXOPTS    ?= -W --keep-going
SPHINXBUILD   ?= $(if $(wildcard .venv/bin/sphinx-build),.venv/bin/sphinx-build,sphinx-build)
SOURCEDIR     = .
BUILDDIR      = _build

.PHONY: help html dirhtml clean
help:
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

html:
	@$(SPHINXBUILD) -b html "$(SOURCEDIR)" "$(BUILDDIR)/html" $(SPHINXOPTS) $(O)

dirhtml:
	@$(SPHINXBUILD) -b dirhtml "$(SOURCEDIR)" "$(BUILDDIR)/dirhtml" $(SPHINXOPTS) $(O)

clean:
	rm -rf "$(BUILDDIR)"

%: Makefile
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
