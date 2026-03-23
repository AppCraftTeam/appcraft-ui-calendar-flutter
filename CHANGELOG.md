# Changelog

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
