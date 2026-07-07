#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

WORKSPACE="${WORKSPACE:-QuizPlease.xcworkspace}"
CONFIGURATION="${CONFIGURATION:-Debug}"
TEST_DESTINATION="${TEST_DESTINATION:-platform=iOS Simulator,name=iPhone 17,OS=26.5}"
UNIT_TEST_SCHEME="${UNIT_TEST_SCHEME:-QuizPleaseTests}"
UI_TEST_SCHEME="${UI_TEST_SCHEME:-QuizPleaseUITests}"

usage() {
  cat <<'USAGE'
Usage:
  ./scripts/test.sh unit
  ./scripts/test.sh ui
  ./scripts/test.sh all

Options:
  WORKSPACE=QuizPlease.xcworkspace
  CONFIGURATION=Debug
  TEST_DESTINATION="platform=iOS Simulator,name=iPhone 17,OS=26.5"
  UNIT_TEST_SCHEME=QuizPleaseTests
  UI_TEST_SCHEME=QuizPleaseUITests

Formatting:
  Install xcbeautify to format xcodebuild output. Raw xcodebuild output is used otherwise.
USAGE
}

run_xcodebuild_test() {
  local scheme="$1"
  local status

  local command=(
    xcodebuild
    -workspace "$WORKSPACE"
    -scheme "$scheme"
    -configuration "$CONFIGURATION"
    -destination "$TEST_DESTINATION"
    test
  )

  if command -v xcbeautify >/dev/null 2>&1; then
    set +e
    "${command[@]}" | xcbeautify --disable-logging
    status=${PIPESTATUS[0]}
    set -e
    return "$status"
  fi

  "${command[@]}"
}

case "${1:-}" in
  unit)
    run_xcodebuild_test "$UNIT_TEST_SCHEME"
    ;;
  ui)
    run_xcodebuild_test "$UI_TEST_SCHEME"
    ;;
  all)
    run_xcodebuild_test "$UNIT_TEST_SCHEME"
    run_xcodebuild_test "$UI_TEST_SCHEME"
    ;;
  -h|--help|help|"")
    usage
    ;;
  *)
    echo "error: unknown test command '$1'" >&2
    usage >&2
    exit 64
    ;;
esac
