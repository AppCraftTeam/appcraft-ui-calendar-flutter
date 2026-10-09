# Changelog

## 0.2.3

### Changed
- Documented the breaking changes of 0.2.0 in this changelog (see the `Breaking Changes` section of 0.2.0). No code changes.

## 0.2.2

### Changed
- Translated documentation and code comments to English (`README.md`, `CHANGELOG.md`, doc-comments and inline comments) for pub.dev. Functional Russian localization strings (`ACLocalizationRu`) are unchanged.

## 0.2.1

### Added
- Factory constructor `ACDayMonthPosition.forDay(day, monthDate)` for determining a day's position relative to the displayed month (logic extracted from `ACMonthWidget`)

## 0.2.0

### Added
- Optional `ACCalendarThemeData? theme` parameter in root widgets (`ACCalendarWidget`, `ACPagesCalendarWidget`, `ACCalendarScreen`) is now propagated to child widgets
- `ACCalendarThemeData? theme` parameter in `ACRawCalendarWidget` and `ACRawPagesCalendarWidget` for passing the theme directly without `ThemeExtension`
- `ACDayThemeData? dayTheme` parameter in `ACMonthWidget`, `ACTitledMonthWidget` and `ACCalendarDayWidget` for fine-grained overriding of the day theme
- Theme resolution priority: widget parameter > `ThemeExtension` > default values
- `dayBuilder` parameter in calendar widgets for custom day cell building
- `monthBuilder` parameter in `ACPagesCalendarWidget` / `ACRawPagesCalendarWidget` for fully replacing the month widget
- `monthLayout` parameter for a fixed month grid layout
- `monthHeight` parameter for a fixed month grid height
- `monthBuilder` parameter in `ACCalendarWidget` / `ACRawCalendarWidget` / `ACCalendarScreen` for fully replacing the month widget in the scroll calendar
- `monthLayoutBuilder` parameter — a month layout callback for the scroll calendar (different months — different layouts)
- `monthHeightBuilder` parameter — a month height callback for the scroll calendar
- `weekWidget` parameter for replacing the default `ACWeekWidget` with a custom weekday row widget
- `headerWidget` parameter for replacing the default `ACPagesCalendarHeader` with a custom header

### Breaking Changes
- `ACCalendarThemeData.backgroundColor` is now non-nullable (`Color` instead of `Color?`); `ACLightCalendarThemeData.raw` requires it. The `ACLightCalendarThemeData` factory still accepts `backgroundColor` as optional and defaults to `Color(0xFFFFFFFF)`.
  - Migration: pass `backgroundColor` when using `ACLightCalendarThemeData.raw` or implementing `ACCalendarThemeData`.
- `ACCalendarScreen`: the `backgroundColor`, `titleColor` and `titleTextStyle` parameters are removed. The background now comes from `theme.backgroundColor` or `ACCalendarThemeExtension` (previously the default was `ColorScheme.surface`); the title uses the built-in style.
  - Migration: set the background via `theme: ACLightCalendarThemeData(backgroundColor: ...)` or the theme extension; drop `titleColor` and `titleTextStyle`.
- `ACMonthPicker` and `ACMonthPickerSheet`: the `monthPickerTheme` and `wheelPickerTheme` parameters are replaced with `ACCalendarThemeData? theme`; the picker themes are taken from `theme.monthPickerTheme` and `theme.wheelPickerTheme`.
  - Migration: pass `theme: ACLightCalendarThemeData(monthPickerTheme: ..., wheelPickerTheme: ...)` instead of the two parameters.

## 0.1.1

- Fixed all dart analyze warnings (deprecated lint rules, import sorting)
- Added an entrypoint for performance measurement (`example/lib/main_perf.dart`)

## 0.1.0

### Breaking Changes
- `ACCalendarTheme` (InheritedWidget) replaced by `ACCalendarThemeData` (plain data class) + `ACCalendarThemeExtension` (ThemeExtension)
- Fixed typos: `arrowRoateDuration` -> `arrowRotateDuration`, `middleSelectedBackgroudColor` -> `middleSelectedBackgroundColor`
- `ACCalendarThemeData` is now abstract; use concrete `ACLightCalendarThemeData` instead of `ACCalendarThemeData(...)` directly
- Use `ACCalendarThemeExtension(data: ACLightCalendarThemeData(...))` in `ThemeData.extensions`
- Static `lerpTheme()` methods in sub-theme abstract classes replaced with instance `lerp()` methods

### Added
- `ACCalendarThemeExtension` class wrapping `ACCalendarThemeData` as a `ThemeExtension`
- Theme is passed through `ThemeData(extensions: [ACCalendarThemeExtension(data: ACCalendarThemeData(...))])`
- `ACCalendarThemeExtension.of(context)` method for obtaining theme from context
- `copyWith()` and `lerp()` methods for all sub-theme classes
- `backgroundColor` property in `ACCalendarThemeData`
- `actionTextColor` property in `ACMonthPickerThemeData`
- Doc-comments for all public APIs

### Changed
- Simplified project structure: 7 -> 3 nesting levels from `lib/`
- All widgets moved to flat structure `lib/src/widgets/`
- Removed 17 intermediate barrel files
- Hard-coded colors in widgets replaced with theme reads
- Removed usage of deprecated `scaffoldBackgroundColor`

### Fixed
- Fixed bugs in `copyWith()` for 5 sub-theme classes (values were being reset instead of preserved)

## 0.0.1

- Initial version of the calendar library
