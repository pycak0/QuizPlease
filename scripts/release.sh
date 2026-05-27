#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

BASE_CONFIG="QuizPlease/Config/Base.xcconfig"
WORKSPACE="QuizPlease.xcworkspace"
PRODUCTION_SCHEME="QuizPlease Production"
PRODUCTION_CONFIGURATION="Production"
ARCHIVES_DIR="${HOME}/Library/Developer/Xcode/Archives"
LOG_DIR="${LOG_DIR:-logs}"
ARCHIVE_LOG_FILE=""
XCODEBUILD_LOG_FILE=""
ARCHIVE_BACKUP_FILE=""
ARCHIVE_STARTED_AT=0

if [[ (-t 1 || "${FORCE_COLOR:-0}" == "1") && -z "${NO_COLOR:-}" ]]; then
  BOLD=$'\033[1m'
  DIM=$'\033[2m'
  RED=$'\033[31m'
  GREEN=$'\033[32m'
  YELLOW=$'\033[33m'
  BLUE=$'\033[34m'
  CYAN=$'\033[36m'
  RESET=$'\033[0m'
else
  BOLD=""
  DIM=""
  RED=""
  GREEN=""
  YELLOW=""
  BLUE=""
  CYAN=""
  RESET=""
fi

usage() {
  cat <<'USAGE'
Usage:
  make version BUMP=patch|minor|major
  make archive

Branch rules:
  make version  develop only
  make archive  develop or release/*

Options:
  DRY_RUN=1  Print the planned change without editing, archiving, or committing.

Logs:
  make archive writes logs to logs/ by default. Override with LOG_DIR=path.

Formatting:
  Install xcbeautify to format xcodebuild output. Raw xcodebuild output is used otherwise.
USAGE
}

die() {
  echo "${RED}error:${RESET} $*" >&2
  exit 1
}

is_dry_run() {
  [[ "${DRY_RUN:-0}" == "1" ]]
}

log_title() {
  echo "${BOLD}${BLUE}==>${RESET} ${BOLD}$*${RESET}"
}

log_kv() {
  local key="$1"
  local value="$2"

  printf '  %s%-8s%s %s\n' "$CYAN" "${key}:" "$RESET" "$value"
}

log_dry_run() {
  echo "${YELLOW}dry-run:${RESET} $*"
}

log_success() {
  echo "${GREEN}done:${RESET} $*"
}

log_note() {
  echo "${DIM}$*${RESET}"
}

grep_count() {
  local pattern="$1"
  local file="$2"

  if [[ -f "$file" ]]; then
    grep -Eic "$pattern" "$file" || true
  else
    echo 0
  fi
}

format_duration() {
  local started_at="$1"
  local ended_at elapsed

  if [[ "$started_at" -le 0 ]]; then
    echo "-"
    return
  fi

  ended_at="$(date +%s)"
  elapsed=$((ended_at - started_at))
  printf '%02d:%02d:%02d\n' $((elapsed / 3600)) $(((elapsed % 3600) / 60)) $((elapsed % 60))
}

setup_archive_logging() {
  local stamp

  if is_dry_run; then
    return
  fi

  mkdir -p "$LOG_DIR"
  ARCHIVE_STARTED_AT="$(date +%s)"

  if [[ -n "${RELEASE_LOG_FILE:-}" ]]; then
    ARCHIVE_LOG_FILE="$RELEASE_LOG_FILE"
  else
    stamp="$(date +%Y%m%d-%H%M%S)"
    ARCHIVE_LOG_FILE="${LOG_DIR}/archive-${stamp}.log"
    : > "$ARCHIVE_LOG_FILE"
  fi

  XCODEBUILD_LOG_FILE="${ARCHIVE_LOG_FILE%.log}.xcodebuild.raw.log"
  : > "$XCODEBUILD_LOG_FILE"

  log_note "Archive log: $ARCHIVE_LOG_FILE"
  log_note "Raw xcodebuild log: $XCODEBUILD_LOG_FILE"
}

print_archive_summary() {
  local result="$1"
  local warnings errors notes

  warnings="$(grep_count '(^|[^[:alpha:]])warning:' "$XCODEBUILD_LOG_FILE")"
  errors="$(grep_count '^(/|[A-Za-z0-9_./ -]+:)[^:]*:[0-9]+:[0-9]+: error:' "$XCODEBUILD_LOG_FILE")"
  errors=$((errors + $(grep_count '^\*\* (BUILD|ARCHIVE) FAILED \*\*$' "$XCODEBUILD_LOG_FILE")))
  notes="$(grep_count '(^|[^[:alpha:]])note:' "$XCODEBUILD_LOG_FILE")"

  log_title "Archive summary"
  log_kv "Result" "$result"
  log_kv "Duration" "$(format_duration "$ARCHIVE_STARTED_AT")"
  log_kv "Warnings" "$warnings"
  log_kv "Errors" "$errors"
  log_kv "Notes" "$notes"

  if [[ -n "$ARCHIVE_LOG_FILE" ]]; then
    log_kv "Log" "$ARCHIVE_LOG_FILE"
  fi

  if [[ -n "$XCODEBUILD_LOG_FILE" ]]; then
    log_kv "Raw log" "$XCODEBUILD_LOG_FILE"
  fi
}

archive_exit() {
  local exit_code=$?
  trap - EXIT INT TERM

  if [[ "$exit_code" -eq 0 ]]; then
    return
  fi

  if [[ -n "${ARCHIVE_BACKUP_FILE:-}" && -f "$ARCHIVE_BACKUP_FILE" ]]; then
    cp "$ARCHIVE_BACKUP_FILE" "$BASE_CONFIG"
    rm -f "$ARCHIVE_BACKUP_FILE"
    ARCHIVE_BACKUP_FILE=""
    log_note "Reverted $BASE_CONFIG."
  fi

  print_archive_summary "failed"

  if [[ -n "$ARCHIVE_LOG_FILE" ]]; then
    echo "${RED}archive failed:${RESET} full log saved to $ARCHIVE_LOG_FILE" >&2
  fi

  exit "$exit_code"
}

run_with_archive_log_if_needed() {
  local command="${1:-}"
  local stamp log_file force_color status

  if [[ "$command" != "archive" || "${ARCHIVE_LOG_ACTIVE:-0}" == "1" || "${DRY_RUN:-0}" == "1" ]]; then
    return
  fi

  mkdir -p "$LOG_DIR"
  stamp="$(date +%Y%m%d-%H%M%S)"
  log_file="${RELEASE_LOG_FILE:-${LOG_DIR}/archive-${stamp}.log}"
  : > "$log_file"

  force_color=0
  if [[ -t 1 && -z "${NO_COLOR:-}" ]]; then
    force_color=1
  fi

  set +e
  if [[ "$force_color" == "1" ]]; then
    ARCHIVE_LOG_ACTIVE=1 RELEASE_LOG_FILE="$log_file" FORCE_COLOR="${FORCE_COLOR:-$force_color}" "$0" "$@" 2>&1 \
      | tee >(sed -E $'s/\x1B\\[[0-9;]*[[:alpha:]]//g' >> "$log_file")
    status=${PIPESTATUS[0]}
  else
    ARCHIVE_LOG_ACTIVE=1 RELEASE_LOG_FILE="$log_file" FORCE_COLOR="${FORCE_COLOR:-$force_color}" "$0" "$@" 2>&1 | tee -a "$log_file"
    status=${PIPESTATUS[0]}
  fi
  set -e
  exit "$status"
}

require_clean_tree() {
  if is_dry_run; then
    return
  fi

  if [[ -n "$(git status --porcelain)" ]]; then
    die "git working tree is not clean; commit or stash changes before release automation"
  fi
}

current_branch() {
  local branch
  branch="$(git branch --show-current)"
  [[ -n "$branch" ]] || die "release automation must run on a named branch"
  echo "$branch"
}

require_version_branch() {
  local branch
  branch="$(current_branch)"

  [[ "$branch" == "develop" ]] || die "make version must run on develop; current branch is '$branch'"
}

require_archive_branch() {
  local branch
  branch="$(current_branch)"

  case "$branch" in
    develop|release/*)
      ;;
    *)
      die "make archive must run on develop or release/*; current branch is '$branch'"
      ;;
  esac
}

read_config_value() {
  local key="$1"

  awk -F '=' -v expected_key="$key" '
    {
      key = $1
      gsub(/^[ \t]+|[ \t]+$/, "", key)
      if (key == expected_key) {
        value = $2
        sub(/[ \t]*\/\/.*$/, "", value)
        gsub(/^[ \t]+|[ \t]+$/, "", value)
        print value
        found = 1
        exit
      }
    }
    END { if (!found) exit 1 }
  ' "$BASE_CONFIG"
}

validate_build() {
  local build="$1"

  [[ "$build" =~ ^[1-9][0-9]*$ ]] || die "CURRENT_PROJECT_VERSION must be a positive integer, got '$build'"
}

parse_version() {
  local version="$1"
  IFS='.' read -r VERSION_MAJOR VERSION_MINOR VERSION_PATCH VERSION_EXTRA <<< "$version"

  [[ -z "${VERSION_EXTRA:-}" ]] || die "MARKETING_VERSION must have at most three components, got '$version'"
  [[ "$VERSION_MAJOR" =~ ^[0-9]+$ ]] || die "invalid MARKETING_VERSION: '$version'"
  [[ "$VERSION_MINOR" =~ ^[0-9]+$ ]] || die "invalid MARKETING_VERSION: '$version'"

  if [[ -z "${VERSION_PATCH:-}" ]]; then
    VERSION_PATCH=0
  fi

  [[ "$VERSION_PATCH" =~ ^[0-9]+$ ]] || die "invalid MARKETING_VERSION: '$version'"
}

bump_marketing_version() {
  local bump="$1"
  local version="$2"

  parse_version "$version"

  case "$bump" in
    patch)
      VERSION_PATCH=$((VERSION_PATCH + 1))
      ;;
    minor)
      VERSION_MINOR=$((VERSION_MINOR + 1))
      VERSION_PATCH=0
      ;;
    major)
      VERSION_MAJOR=$((VERSION_MAJOR + 1))
      VERSION_MINOR=0
      VERSION_PATCH=0
      ;;
    *)
      die "BUMP must be patch, minor, or major"
      ;;
  esac

  echo "${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH}"
}

write_config_values() {
  local marketing_version="$1"
  local build_version="$2"
  local tmp_file

  tmp_file="$(mktemp)"

  awk -v marketing_version="$marketing_version" -v build_version="$build_version" '
    /^[ \t]*MARKETING_VERSION[ \t]*=/ {
      print "MARKETING_VERSION = " marketing_version
      saw_marketing = 1
      next
    }
    /^[ \t]*CURRENT_PROJECT_VERSION[ \t]*=/ {
      print "CURRENT_PROJECT_VERSION = " build_version
      saw_build = 1
      next
    }
    { print }
    END {
      if (!saw_marketing || !saw_build) exit 1
    }
  ' "$BASE_CONFIG" > "$tmp_file" || {
    rm -f "$tmp_file"
    die "failed to update $BASE_CONFIG"
  }

  mv "$tmp_file" "$BASE_CONFIG"
}

commit_config_change() {
  local message="$1"

  git add "$BASE_CONFIG"
  git commit -m "$message"
}

run_xcodebuild_archive() {
  local archive_path="$1"
  local -a args=(
    -workspace "$WORKSPACE"
    -scheme "$PRODUCTION_SCHEME"
    -configuration "$PRODUCTION_CONFIGURATION"
    -destination "generic/platform=iOS"
    -archivePath "$archive_path"
    archive
  )

  if command -v xcbeautify >/dev/null 2>&1; then
    log_note "Using xcbeautify for xcodebuild output."
    NSUnbufferedIO=YES xcodebuild "${args[@]}" 2>&1 | tee "$XCODEBUILD_LOG_FILE" | xcbeautify
  else
    log_note "xcbeautify is not installed; using raw xcodebuild output."
    xcodebuild "${args[@]}" 2>&1 | tee "$XCODEBUILD_LOG_FILE"
  fi
}

run_version() {
  local bump="${1:-}"
  [[ -n "$bump" ]] || {
    usage
    die "missing BUMP; expected patch, minor, or major"
  }

  require_version_branch
  require_clean_tree

  local old_version build_version new_version
  old_version="$(read_config_value MARKETING_VERSION)"
  build_version="$(read_config_value CURRENT_PROJECT_VERSION)"
  validate_build "$build_version"
  new_version="$(bump_marketing_version "$bump" "$old_version")"

  if [[ "$new_version" == "$old_version" ]]; then
    die "version did not change"
  fi

  log_title "Bump version"
  log_kv "Version" "$old_version -> $new_version"
  log_kv "Build" "$build_version"

  if is_dry_run; then
    log_dry_run "would commit '#version $old_version -> $new_version'"
    return
  fi

  local backup_file
  backup_file="$(mktemp)"
  cp "$BASE_CONFIG" "$backup_file"

  rollback() {
    cp "$backup_file" "$BASE_CONFIG"
    rm -f "$backup_file"
  }

  trap rollback ERR INT TERM
  write_config_values "$new_version" "$build_version"
  commit_config_change "#version $old_version -> $new_version"
  trap - ERR INT TERM
  rm -f "$backup_file"

  log_success "committed #version $old_version -> $new_version"
}

run_archive() {
  setup_archive_logging
  if ! is_dry_run; then
    trap archive_exit EXIT
    trap 'exit 130' INT
    trap 'exit 143' TERM
  fi

  require_archive_branch
  require_clean_tree

  local marketing_version old_build new_build archive_day archive_path
  marketing_version="$(read_config_value MARKETING_VERSION)"
  old_build="$(read_config_value CURRENT_PROJECT_VERSION)"
  validate_build "$old_build"
  new_build=$((old_build + 1))
  archive_day="$(date +%Y-%m-%d)"
  archive_path="${ARCHIVES_DIR}/${archive_day}/QuizPlease ${marketing_version} (${new_build}).xcarchive"

  log_title "Archive production build"
  log_kv "Version" "$marketing_version"
  log_kv "Build" "$old_build -> $new_build"
  log_kv "Archive" "$archive_path"

  if is_dry_run; then
    log_dry_run "would archive and commit '#build $marketing_version ($new_build)'"
    return
  fi

  ARCHIVE_BACKUP_FILE="$(mktemp)"
  cp "$BASE_CONFIG" "$ARCHIVE_BACKUP_FILE"

  write_config_values "$marketing_version" "$new_build"
  mkdir -p "$(dirname "$archive_path")"

  run_xcodebuild_archive "$archive_path"

  commit_config_change "#build $marketing_version ($new_build)"
  rm -f "$ARCHIVE_BACKUP_FILE"
  ARCHIVE_BACKUP_FILE=""

  print_archive_summary "succeeded"
  log_success "archived and committed #build $marketing_version ($new_build)"

  trap - EXIT INT TERM
}

run_with_archive_log_if_needed "$@"

case "${1:-}" in
  version)
    run_version "${2:-}"
    ;;
  archive)
    run_archive
    ;;
  -h|--help|help)
    usage
    ;;
  *)
    usage
    die "unknown command: ${1:-}"
    ;;
esac
