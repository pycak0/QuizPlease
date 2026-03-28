# AGENTS

## Project Map

- Repo analysis and evolving architecture notes live in `.codex/project-map.md`.
- Keep this file short and stable; put long-form project memory in the project map.

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
