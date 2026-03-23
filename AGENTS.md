# AGENTS

## Build

- Build this project from `QuizPlease.xcworkspace`, not from `QuizPlease.xcodeproj`.
- For the main debug app build, use scheme `QuizPlease Debug`.
- Use configuration `Debug`.
- Use destination `generic/platform=iOS` for "Any iOS Device".
- Prefer the default Xcode `DerivedData`. Do not pass `-derivedDataPath` unless explicitly needed for a sandboxed environment or requested by the user.

### Command

```bash
xcodebuild -workspace QuizPlease.xcworkspace -scheme "QuizPlease Debug" -configuration Debug -destination "generic/platform=iOS" build
```
