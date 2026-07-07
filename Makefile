.DEFAULT_GOAL := help

.PHONY: help archive version test ui-test test-all

help:
	@printf '%s\n' \
		'Usage:' \
		'  make version BUMP=patch|minor|major' \
		'  make archive' \
		'  make test' \
		'  make ui-test' \
		'  make test-all' \
		'' \
		'Branch rules:' \
		'  make version  develop only' \
		'  make archive  develop or release/*' \
		'' \
		'Options:' \
		'  DRY_RUN=1  Print planned changes without editing, archiving, or committing.' \
		'  TEST_DESTINATION="platform=iOS Simulator,name=iPhone 17,OS=26.5"' \
		'' \
		'Logs:' \
		'  make archive writes logs to logs/ by default. Override with LOG_DIR=path.' \
		'' \
		'Formatting:' \
		'  Install xcbeautify to format xcodebuild output.'

archive:
	@./scripts/release.sh archive

version:
	@./scripts/release.sh version "$(BUMP)"

test:
	@./scripts/test.sh unit

ui-test:
	@./scripts/test.sh ui

test-all:
	@./scripts/test.sh all
