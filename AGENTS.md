# AGENTS

## Project Map

- Repo analysis and evolving architecture notes live in `.codex/project-map.md`.
- Keep this file short and stable; put long-form project memory in the project map.
- When changing build, dependency, release, target, or architecture behavior, update the relevant Markdown project knowledge before finishing.

## Build

- Build this project from `QuizPlease.xcworkspace`, not from `QuizPlease.xcodeproj`.
- For the main debug app build, use scheme `QuizPlease Debug`.
- For production archive automation, use `make archive`; it archives scheme `QuizPlease Production`.
- `QuizPlease Production` is a separate app target on purpose so production builds can exclude debug-only SwiftPM products such as Wormholy.
- Use configuration `Debug`.
- Use destination `generic/platform=iOS` for "Any iOS Device".
- Run Xcode/xcodebuild commands outside the filesystem sandbox when possible; sandboxed runs have produced CoreSimulator service/log permission failures before reaching the real build.
- Prefer the default Xcode `DerivedData`. Do not pass `-derivedDataPath` unless explicitly needed for a sandboxed environment or requested by the user.

### Command

```bash
xcodebuild -workspace QuizPlease.xcworkspace -scheme "QuizPlease Debug" -configuration Debug -destination "generic/platform=iOS" build
```

## Tests

- When implementing behavior, add or update focused tests for it. If tests are not practical for the change, state the reason explicitly.
- Prefer the `QuizPleaseTests` scheme for unit tests.
