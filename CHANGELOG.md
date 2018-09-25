# Change Log

## Unreleased

## [0.1.5] - 2018-09-25
- [Fixed] warnings reported by Flutter publisher.

## [0.1.4] - 2018-09-25
- [Added] Android Headless mode.  See docs for `enableHeadless`.
- [Added] an "event list" screen to "AdvancedApp" example.
- [Added] `error` callback for `BackgroundGeolocation.onLocation`.
- [Fixed] Issue #5 podspec property `s.static_framework = true` to allow the plugin to work in apps where `use_frameworks!` directive is applied in `Podfile` (Thanks to @vova-beloded).

## [0.1.3] - 2018-09-20
- Implementing Dart-style docs with `dartdoc`
- Re-organize `/lib` dir; remove `/src` folder (hides classes from `dartdoc`).

## [0.1.2] - 2018-09-17
- Implementing advanced example app.
- Fix missing `removeListener` methods for `enabledchange`, `connectivitychange`
- Implement `destroyLog`
- Implement instrumented testing in `example/test_driver`.  See `examples/scripts/test.sh`
- Fix warnings.

## [0.1.1] - 2018-09-15
- Implementing advanced example app.
- Fix bug in `getGeofences`

## [0.1.0] - 2018-09-13
- First working beta release.

## [0.0.1] - 2018-07-07
- Reserve namespace.  Plugin not yet implemented.