#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

WORKSPACE="${WORKSPACE:-QuizPlease.xcworkspace}"
SCHEME="${SCHEME:-QuizPlease Debug}"
CONFIGURATION="${CONFIGURATION:-Debug}"
BUILD_DESTINATION="${BUILD_DESTINATION:-generic/platform=iOS}"
RUN_DESTINATION="${RUN_DESTINATION:-platform=iOS Simulator,name=iPhone 17 Pro Max,OS=26.5}"
BUNDLE_ID="${BUNDLE_ID:-com.quizplease.app}"

usage() {
  cat <<USAGE
Usage:
  ./scripts/build.sh build
  ./scripts/build.sh run

Options:
  WORKSPACE=QuizPlease.xcworkspace
  SCHEME="QuizPlease Debug"
  CONFIGURATION=Debug
  BUILD_DESTINATION="generic/platform=iOS"
  RUN_DESTINATION="platform=iOS Simulator,name=iPhone 17 Pro Max,OS=26.5"
  DESTINATION=...              Override destination for build or run
  BUNDLE_ID=com.quizplease.app Used by run to launch the app

Examples:
  make build
  make build DESTINATION="platform=iOS Simulator,name=iPhone 17 Pro Max,OS=26.5"
  make run
  make run DESTINATION="platform=iOS Simulator,name=iPhone 16,OS=18.4"

Formatting:
  Install xcbeautify to format xcodebuild output. Raw xcodebuild output is used otherwise.
USAGE
}

run_xcodebuild() {
  local destination="$1"
  shift
  local status

  local command=(
    xcodebuild
    -workspace "$WORKSPACE"
    -scheme "$SCHEME"
    -configuration "$CONFIGURATION"
    -destination "$destination"
    "$@"
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

app_path_for_destination() {
  local destination="$1"
  local build_settings target_build_dir full_product_name

  build_settings="$(
    xcodebuild \
      -workspace "$WORKSPACE" \
      -scheme "$SCHEME" \
      -configuration "$CONFIGURATION" \
      -destination "$destination" \
      -showBuildSettings 2>/dev/null
  )"

  target_build_dir="$(
    echo "$build_settings" | awk -F ' = ' '/ TARGET_BUILD_DIR / { value = $2 } END { print value }'
  )"
  full_product_name="$(
    echo "$build_settings" | awk -F ' = ' '/ FULL_PRODUCT_NAME / { value = $2 } END { print value }'
  )"

  if [[ -z "$target_build_dir" || -z "$full_product_name" ]]; then
    echo "error: could not resolve built app path from xcodebuild settings" >&2
    exit 1
  fi

  printf '%s/%s' "$target_build_dir" "$full_product_name"
}

simulator_id_for_destination() {
  local destination="$1"

  if [[ "$destination" =~ id=([A-F0-9-]+) ]]; then
    echo "${BASH_REMATCH[1]}"
    return 0
  fi

  local simulator_name simulator_os
  simulator_name="$(sed -n 's/.*name=\([^,]*\).*/\1/p' <<<"$destination")"
  simulator_os="$(sed -n 's/.*OS=\([^,]*\).*/\1/p' <<<"$destination")"

  if [[ -z "$simulator_name" ]]; then
    echo "error: run requires a simulator destination (name=..., optional OS=...)" >&2
    exit 1
  fi

  SIMULATOR_NAME="$simulator_name" SIMULATOR_OS="${simulator_os:-}" \
    ruby -rjson -e '
    data = JSON.parse(STDIN.read)
    name = ENV.fetch("SIMULATOR_NAME")
    os = ENV["SIMULATOR_OS"]

    matches = []
    data.fetch("devices").each do |runtime, devices|
      next if os && !os.empty? && !runtime.end_with?("iOS-#{os.tr(".", "-")}")

      devices.each do |device|
        next unless device["isAvailable"]
        next unless device["name"] == name

        matches << device
      end
    end

    if matches.empty?
      warn "error: no available simulator found for name=#{name}" + (os && !os.empty? ? ", OS=#{os}" : "")
      exit 1
    end

    puts matches.first.fetch("udid")
  ' <<<"$(xcrun simctl list devices available -j)"
}

build_app() {
  local destination="${DESTINATION:-$BUILD_DESTINATION}"
  run_xcodebuild "$destination" build
}

run_app() {
  local destination="${DESTINATION:-$RUN_DESTINATION}"

  if [[ "$destination" == generic/platform=iOS* ]]; then
    echo "error: make run needs a simulator destination; generic/platform=iOS is for make build only" >&2
    echo "example: make run DESTINATION=\"platform=iOS Simulator,name=iPhone 17 Pro Max,OS=26.5\"" >&2
    exit 1
  fi

  run_xcodebuild "$destination" build

  local app_path simulator_id
  app_path="$(app_path_for_destination "$destination")"
  simulator_id="$(simulator_id_for_destination "$destination")"

  if [[ ! -d "$app_path" ]]; then
    echo "error: built app not found at $app_path" >&2
    exit 1
  fi

  xcrun simctl boot "$simulator_id" >/dev/null 2>&1 || true
  open -a Simulator --args -CurrentDeviceUDID "$simulator_id"
  xcrun simctl install "$simulator_id" "$app_path" >/dev/null
  xcrun simctl launch "$simulator_id" "$BUNDLE_ID"
}

case "${1:-}" in
  build)
    build_app
    ;;
  run)
    run_app
    ;;
  -h|--help|help|"")
    usage
    ;;
  *)
    echo "error: unknown build command '$1'" >&2
    usage >&2
    exit 64
    ;;
esac
