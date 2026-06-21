# QuizPlease Project Map

Last updated: 2026-06-21
Purpose: working memory for future Codex sessions. Keep `AGENTS.md` short and put evolving repo knowledge here.

## TL;DR

- UIKit app with storyboard entry points. No SwiftUI found in sources.
- Main build entry is the workspace, not the standalone project: `QuizPlease.xcworkspace`.
- Shared schemes: `QuizPlease Debug`, `QuizPlease Staging`, `QuizPlease Production`, `QuizPleaseTests`.
- Main app targets: `QuizPlease` and `QuizPlease Production`. Test target: `QuizPleaseTests`.
- `QuizPlease Production` is intentionally separate from `QuizPlease` so production builds exclude debug-only SwiftPM products such as Wormholy.
- Dependency management is mixed: SwiftPM + CocoaPods + checked-in local frameworks.
- CocoaPods dependencies must be integrated for both app targets. The production target uses its own Pods aggregate and target-specific xcconfigs.
- App composition is assembly-based: global infra is wired in `CoreAssembly` and `ServiceAssembly`, feature screens are wired in per-module assemblies.
- Navigation and external entry points are centralized in `TransitionFacade` and the applink/deeplink stack.
- Networking is in transition: there is both a global `NetworkService.shared` facade and an injected `NetworkServiceProtocol` / `NetworkServiceImpl` path.

## Build And Config Snapshot

### Workspace and targets

- Workspace file: `QuizPlease.xcworkspace`
- Workspace contents: app project + `Pods/Pods.xcodeproj`
- Native targets:
  - `QuizPlease` (`com.apple.product-type.application`)
  - `QuizPlease Production` (`com.apple.product-type.application`)
  - `QuizPleaseTests` (`com.apple.product-type.bundle.unit-test`)

`QuizPlease Production` shares the app sources/resources with `QuizPlease`, but has its own Frameworks phase and package product list. Keep Wormholy out of this target.

### Schemes

- `QuizPlease Debug`
  - app launch/test/analyze/profile/archive on `Debug`
  - includes `QuizPleaseTests` in Build/Test actions
- `QuizPlease Staging`
  - app launch/profile/archive on `Staging`
  - no explicit testables in the scheme
- `QuizPlease Production`
  - app launch/profile/archive on `Production`
  - points at the separate `QuizPlease Production` native target
  - no explicit testables in the scheme
- `QuizPleaseTests`
  - tests only, `Debug`

### Configurations

- App configurations: `Debug`, `Staging`, `Production`
- App deployment target: `iOS 15.1`
- Test target deployment target: `iOS 12.0`
- Swift version in project settings: `5.0`
- App bundle identifier in project settings: `com.quizplease.app`

### xcconfig layering

- Base config: `QuizPlease/Config/Base.xcconfig`
- Environment overlays:
  - `QuizPlease/Config/Debug.xcconfig`
  - `QuizPlease/Config/Staging.xcconfig`
  - `QuizPlease/Config/Production.xcconfig`
- Debug and Staging also customize icon names / app name suffixes.
- The regular `QuizPlease` app target uses `Debug.xcconfig` and `Staging.xcconfig`.
- The `QuizPlease Production` app target uses `Production.xcconfig`.
- `Production.xcconfig` includes `Pods-QuizPlease Production.production.xcconfig`; `Debug.xcconfig` and `Staging.xcconfig` include the regular `Pods-QuizPlease.*.xcconfig` files. Do not swap these between targets, or production archives can miss embedded pod frameworks.

### Info.plist / runtime configuration

- Main plist: `QuizPlease/PropertyLists/Info.plist`
- `Configuration.current` is derived from the plist key `Configuration`.
- `Debug` and `Staging` both route standard API traffic to staging hosts.
- `Production` routes to production hosts.
- URL scheme: `quizplease`
- Scene-based lifecycle is enabled with `SceneDelegate`.
- Main storyboard: `Main`
- Launch storyboard: `LaunchScreen`
- Localizations found: `Base`, `en`, `ru`

## Entry Points And Startup Flow

### App boot

- `AppDelegate` is still the primary entry point via `@UIApplicationMain`.
- `AppDelegate` responsibilities:
  - configures Firebase
  - sets `MessagingDelegate`
  - sets `UNUserNotificationCenter` delegate
  - configures `IQKeyboardManager`
  - configures `PhoneNumberKit` country picker
  - forwards launch / URL / user activity handling to `TransitionFacade`
  - refreshes auth token on foreground

### Scene lifecycle

- `SceneDelegate` forwards:
  - connection URL contexts
  - user activities
  - open URL contexts
  - foreground token refresh

### Transition system

- `CoreAssembly.shared.transitionFacade` is the main external routing facade.
- `TransitionFacade` handles:
  - custom URL scheme and universal links
  - YooKassa SDK callback URLs
  - push notification routing
  - web fallback via in-app Safari
- Deep links are parsed into `Applink` values.
- `ApplinkRouterImpl` discovers `ApplinkEndpoint` implementations dynamically through Objective-C runtime scanning.
- Pending applinks wait for `.mainScreenLoaded` before navigation.
- `.mainScreenLoaded` is posted from `MainMenuInteractor`.

Implication: changes to startup or deep links often involve `AppDelegate`, `SceneDelegate`, `Core/Transitions/*`, and `Modules/MainMenu/*` together.

## Internal Architecture

### High-level layers

- `QuizPlease/AppDelegates`
  - app and scene lifecycle
- `QuizPlease/Core`
  - cross-cutting infra: config, executors, logger, protocols, transitions
- `QuizPlease/Services`
  - service layer: auth, user, network, analytics, notifications, geocoder, payment helpers
- `QuizPlease/Modules`
  - feature modules / screens
- `QuizPlease/Shared`
  - cross-feature models and reusable views
- `QuizPlease/Extensions`
  - UIKit/Foundation helpers and wrappers
- `QuizPlease/Config`
  - xcconfig files
- `QuizPlease/PropertyLists`
  - Info.plist, GoogleService-Info.plist, etc.
- `QuizPlease/Resources`
  - assets, fonts, strings
- `QuizPlease/Storyboards`
  - `Main.storyboard`, launch screen

### Composition / dependency style

- Global infra is assembled through `CoreAssembly`.
- App services are assembled through `ServiceAssembly`.
- Feature screens often have their own `*Assembly` or `*Configurator`.
- A common feature shape is:
  - `Assembly`
  - `Configurator`
  - `Presenter`
  - `Interactor`
  - `Router`
  - `View` / `ViewController`
  - `Model` / `Entity`
- The codebase is not fully DI-pure:
  - many flows use injected services from `ServiceAssembly`
  - some older code still calls singletons directly, especially `NetworkService.shared`, `DefaultsManager.shared`, `Utilities.main`

### Important global assemblies

- `QuizPlease/Core/CoreAssembly.swift`
  - transition stack
  - JSON encoder/decoder
  - executors
  - logger
  - defaults
- `QuizPlease/Services/ServiceAssembly.swift`
  - analytics
  - geocoder / place geocoder
  - user location services
  - network service
  - notifications
  - auth service
  - user service
  - YooKassa payment module

## Feature Map

### Largest / highest-complexity modules by file count

- `GamePage` (~78 files): custom registration, payment, item builders, game details
- `MainMenu` (~21 files): hub screen, menu routing, posts `mainScreenLoaded`
- `Rating` (~21 files): rating flow and cells
- `WarmUp` (~17 files): warmup mini-domain, questions flow
- `Schedule` (~13 files): schedule list + filters
- `Shop` (~12 files): shop flow and confirmation popups

### Functional module overview

- `Splash`
  - early loading / startup screen
- `MainMenu`
  - central hub and menu composition
- `Schedule`
  - games list and filter UX
- `GamePage`
  - current game details / registration flow
- `GameOrderCompletion`
  - standalone post-registration result UI, presented from `GamePage`
- `HomeGame`
  - home game listing / details
- `WarmUp`
  - question flow, progress ring, answer persistence
- `Shop`
  - merchandise and purchase flow
- `Profile`
  - user info / profile UI
- `Rating`
  - rating table flow
- `Map`
  - location and route helpers
- `PickCity`
  - city selection
- `Auth`
  - login / phone-based auth UI
- `Consent`, `Welcome`, `Onboarding`
  - onboarding/legal gates
- `Settings`
  - includes debug settings screen
- `QrScanner`
  - QR flow
- `YooKassaPaymentModule`
  - local wrapper around YooKassa payment SDK UI flow
- `QPAlert`
  - custom alert module
- `AddGame`
  - add game flow

### Notable architecture split inside features

- `GamePage` is the clearest example of newer composition:
  - explicit assembly
  - interactor
  - presenter
  - router
  - builder/factory objects for table sections/items
  - separate registration and payment services
- Legacy `GameOrder` module was removed on 2026-03-28.

Implication: registration and payment logic now lives in `GamePage` plus shared models under `Shared/Models/GameRegistration`.

## Networking

### Current structure

- `QuizPlease/Services/Network/Configuration/NetworkConfiguration.swift`
  - resolves API hosts from `Configuration.current`
- `QuizPlease/Services/Network/NetworkServiceProtocol.swift`
  - protocol abstraction
- `QuizPlease/Services/Network/NetworkResponseDecoder.swift`
  - decode abstraction
- `QuizPlease/Services/Network/NetworkServiceImpl.swift`
  - concrete implementation with logging
- `QuizPlease/Services/Network/NetworkService.swift`
  - large legacy facade with endpoint-specific methods
- `QuizPlease/Shared/Models/ApiConstants.swift`
  - endpoint path constants

### Hosts

- Standard staging host: `https://mobile.qpdv.ru/`
- Standard production host: `https://quizplease.ru/`
- Rating staging host: `https://rating-api.dev.quizplease.ru/`
- Rating production host: `https://quizplease.ru/`

### Important observation

- The codebase currently mixes:
  - endpoint methods on `NetworkService.shared`
  - lower-level generic requests through injected `NetworkServiceProtocol`
- That suggests an in-progress migration rather than a single finalized networking style.

### Working guidance

- For surgical fixes, stay within the style already used by the touched feature.
- For refactors, check whether the caller already depends on `ServiceAssembly.shared.networkService` before extending `NetworkService.shared`.

## State, Persistence, And Settings

### UserDefaults wrapper

- `DefaultsManager.shared` is the main persistence wrapper.
- Stores:
  - auth info
  - default city
  - FCM token
  - answered warmup question IDs
  - client settings
  - onboarding / welcome / consent markers
  - version info

### Global mutable settings

- `AppSettings` contains mutable app-wide flags and URLs.
- Important flags include:
  - `defaultCity`
  - `isShopEnabled`
  - `isProfileEnabled`
  - `geoChecksAlwaysSuccessful`
  - `inAppPaymentOnlyForOnlineGamesEnabled`

Implication: behavior may be controlled partly by server-loaded client settings and partly by local global state, not only by explicit module dependencies.

## Payments

### Payment-related locations

- `QuizPlease/Modules/GamePage/Service/PaymentService.swift`
- `QuizPlease/Shared/Models/GameRegistration/*`
- `QuizPlease/Services/PaymentProvider/*`
- `QuizPlease/Modules/YooKassaPaymentModule/*`

### External payment stack

- YooKassa SDK is integrated through CocoaPods.
- `TransitionFacade` explicitly delegates callback URLs to `YKSdk.shared.handleOpen(...)`.
- Registration payment flow is centered in `GamePage`; `GameOrderCompletion` only shows the result UI.

### Risk area

- Payment behavior is split across:
  - feature module state
  - payment provider abstractions
  - YooKassa wrapper module
  - transition callback handling

Any payment change should be traced across all four layers.

## External Dependencies

### SwiftPM packages pinned in `Package.resolved`

Directly relevant packages visible in the project:

- `firebase-ios-sdk` `12.11.0`
  - `FirebaseAnalytics`
  - `FirebaseCrashlytics`
  - `FirebaseMessaging`
- `Alamofire` `5.2.2`
- `BottomPopup` `0.6.0`
- `input-mask-ios` `6.0.0`
- `IQKeyboardManager` `6.5.6`
- `Kingfisher` `5.15.8`
- `PhoneNumberKit` `3.8.0`
- `UICircularProgressRing` `6.5.0`
- `Wormholy` `2.3.0`

### CocoaPods

- Podfile directly declares:
  - `YooKassaPayments` from the YooMoney git repo, tag `8.1.1`
  - `FMobileSdk` `2.0.0-1231`
  - `FunctionalSwift` `~> 2.0`
  - `YooMoneySessionProfiler` `< 6.0`
- These pods are shared through `quizplease_pods` and attached to both `QuizPlease` and `QuizPlease Production`.
- Pod lock shows large transitive trees, especially:
  - AppMetrica*
  - MoneyAuth
  - SPaySDK
  - YooKassaPaymentsApi
  - YooKassaWalletApi
  - YooMoney*

Production target CocoaPods integration must include:
  - `Pods_QuizPlease_Production.framework` in the production target Frameworks phase
  - `[CP] Check Pods Manifest.lock`
  - `[CP] Embed Pods Frameworks`
  - `Pods/Target Support Files/Pods-QuizPlease Production/Pods-QuizPlease Production-frameworks.sh`

This matters because missing embed phases caused TestFlight launch crashes such as `DYLD error: Library not loaded: @rpath/AppMetricaAdSupport.framework/AppMetricaAdSupport`.

## Release Automation

- `make archive` runs `scripts/release.sh archive`.
- It is allowed on `develop` and `release/*` branches.
- It increments `CURRENT_PROJECT_VERSION` in `QuizPlease/Config/Base.xcconfig`, archives scheme `QuizPlease Production` with configuration `Production`, then commits `#build <version> (<build>)`.
- After `xcodebuild archive`, it verifies that the archive embeds critical production frameworks:
  - `AppMetricaAdSupport.framework`
  - `FMobileSdk.framework`
  - `YooKassaPayments.framework`
- The same check fails the archive if `Wormholy.framework` appears in the production app bundle.

### Checked-in local frameworks

- `Frameworks/TMXProfiling.xcframework`
- `Frameworks/TMXProfilingConnections.xcframework`

I did not find active Swift `import TMX...` usages in app sources during the initial scan. Treat these as suspicious-but-intentional until proven otherwise; verify project linkage before removing or touching them.

## Resources And UI Stack

- Main UI stack is UIKit.
- `Main.storyboard` is still used.
- There are also many code-built views and cells in feature folders.
- Custom fonts in repo:
  - `Gilroy-Bold`
  - `Gilroy-SemiBold`
  - `Gilroy-Medium`
  - `Gilroy-Heavy`
- Common third-party UI helpers:
  - `BottomPopup`
  - `InputMask`
  - `PhoneNumberKit`
  - `Kingfisher`
  - `UICircularProgressRing`
  - `IQKeyboardManager`

## Tests And Tooling

### Tests

- Test target exists: `QuizPleaseTests`
- Current unit tests appear narrow:
  - `GameInfoLoaderTest`
  - `PlaceGeocoderTest`
- Test support folders:
  - `Mocks/*`
  - `TestData/*`

Implication: most features do not appear to have direct automated coverage. Expect manual verification for UI-heavy changes.

### Linting

- `.swiftlint.yml` is minimal.
- Disabled rules:
  - `identifier_name`
  - `for_where`
- `Pods` are excluded.

## Hotspots And Migration Notes

- `GamePage` is the highest-value module to understand first for current product work.
- Legacy `GameOrder` flow has been removed; shared registration models live in `Shared/Models/GameRegistration`.
- Networking appears partially modernized, not fully converged.
- Global mutable state is used heavily through `DefaultsManager`, `AppSettings`, and some singleton services.
- Deep-link routing depends on `mainScreenLoaded`, which makes app-start navigation timing-sensitive.
- `xcodebuild -list` was not reliable in the current sandbox, so scheme/target/config data in this file was taken directly from shared scheme XML and `project.pbxproj`.

## Practical Working Rules For Future Sessions

- Always build from `QuizPlease.xcworkspace`.
- Prefer running Xcode/xcodebuild outside the filesystem sandbox. Sandboxed runs have failed before real compilation with CoreSimulator service/log permission errors and misleading workspace errors.
- Keep the separate `QuizPlease Production` target unless explicitly asked to remove it; it protects production archives from debug-only SwiftPM products.
- After Podfile or target membership changes, run `pod install` and verify both app targets have the correct `[CP] Embed Pods Frameworks` phase.
- Before modifying a feature, check its assembly/configurator first to understand wiring.
- For anything touching registration or payment:
  - inspect `Modules/GamePage`
  - inspect `Shared/Models/GameRegistration`
  - inspect `Modules/GameOrderCompletion`
  - inspect `Services/PaymentProvider`
  - inspect `Modules/YooKassaPaymentModule`
  - inspect `Core/Transitions/TransitionFacade.swift`
- For anything touching startup, deeplinks, or push:
  - inspect `AppDelegates/*`
  - inspect `Core/Transitions/*`
  - inspect `Modules/MainMenu/*`
- For anything touching backend behavior:
  - inspect `Services/Network/*`
  - inspect `Shared/Models/ApiConstants.swift`
  - inspect `Core/Configuration.swift`
  - inspect `Config/*.xcconfig`
- Keep `AGENTS.md` stable and compact. Update this file after major architecture, dependency, target, build, or release workflow changes.
