# QuizPlease
iOS App for a "Квиз, плиз!" game

## Build

Open and build the app from `QuizPlease.xcworkspace`.

Main local debug build:

```bash
xcodebuild -workspace QuizPlease.xcworkspace -scheme "QuizPlease Debug" -configuration Debug -destination "generic/platform=iOS" build
```

Production archive automation:

```bash
make archive
```

`make archive` uses the `QuizPlease Production` scheme and the separate `QuizPlease Production` target. That target intentionally excludes debug-only SwiftPM products such as Wormholy while still embedding the production CocoaPods frameworks.
