# QuizPlease

iOS app for the «Квиз, плиз!» game.

## Requirements

- Xcode with iOS 15.1+ SDK (recent Xcode 26.x recommended)
- Ruby 3.0+ (Homebrew Ruby works; repo pins `4.0.5` in `.ruby-version`)
- Bundler (`gem install bundler`)
- Optional: [SwiftLint](https://github.com/realm/SwiftLint) for the build script phase
- Optional: [xcbeautify](https://github.com/cpisciotta/xcbeautify) for readable `xcodebuild` output in `make test*`

## First-time setup

```bash
git clone <repo-url>
cd QuizPlease

bundle install
bundle exec pod install
```

Open **`QuizPlease.xcworkspace`**, not `QuizPlease.xcodeproj`.

CocoaPods is pinned in `Gemfile` (`cocoapods` 1.17.0). Use `bundle exec pod install` after Podfile changes so the project stays compatible with `objectVersion = 100`.

## Run locally

1. Open `QuizPlease.xcworkspace` in Xcode.
2. Select scheme **`QuizPlease Debug`**.
3. Choose a simulator or a connected device.
4. Run (⌘R).

Other useful schemes:

- `QuizPlease Staging` — staging configuration
- `QuizPleaseTests` — unit tests
- `QuizPleaseUITests` — UI tests

## Build from CLI

```bash
make build       # Debug build for generic iOS device
make run         # build, install, and launch on the default simulator
```

Override destination if needed:

```bash
make build DESTINATION="platform=iOS Simulator,name=iPhone 17 Pro Max,OS=26.5"
make run DESTINATION="platform=iOS Simulator,name=iPhone 16,OS=18.4"
```

Defaults:

- `make build` → `generic/platform=iOS`
- `make run` → `platform=iOS Simulator,name=iPhone 17 Pro Max,OS=26.5`

Tests:

```bash
make test        # unit tests (QuizPleaseTests)
make ui-test     # UI tests (QuizPleaseUITests)
make test-all    # both
```

Override simulator if needed:

```bash
TEST_DESTINATION="platform=iOS Simulator,name=iPhone 17 Pro Max,OS=26.5" make test
```

## Production archive

```bash
make archive
```

Allowed on `develop` and `release/*` branches. Archives scheme **`QuizPlease Production`** using the separate **`QuizPlease Production`** target. That target intentionally excludes debug-only SwiftPM products such as Wormholy while still embedding production CocoaPods frameworks.

## Local secrets

`QuizPlease/Keys.plist` is gitignored. The app builds without it, but payment keys are empty unless you add the file locally.
