.DEFAULT_GOAL := help

.PHONY: help archive version

help:
	@printf '%s\n' \
		'Usage:' \
		'  make version BUMP=patch|minor|major' \
		'  make archive' \
		'' \
		'Branch rules:' \
		'  make version  develop only' \
		'  make archive  develop or release/*' \
		'' \
		'Options:' \
		'  DRY_RUN=1  Print planned changes without editing, archiving, or committing.'

archive:
	@./scripts/release.sh archive

version:
	@./scripts/release.sh version "$(BUMP)"
