# Changelog

## 0.2.0 (Draft)

### Added
- Опциональный параметр `ACCalendarThemeData? theme` в корневых виджетах (`ACCalendarWidget`, `ACPagesCalendarWidget`, `ACCalendarScreen`) теперь пробрасывается в дочерние виджеты
- Параметр `ACCalendarThemeData? theme` в `ACRawCalendarWidget` и `ACRawPagesCalendarWidget` для прямой передачи темы без `ThemeExtension`
- Параметр `ACDayThemeData? dayTheme` в `ACMonthWidget`, `ACTitledMonthWidget` и `ACCalendarDayWidget` для точечного переопределения темы дней
- Приоритет разрешения темы: параметр виджета > `ThemeExtension` > значения по умолчанию
- Параметр `dayBuilder` в виджетах календарей для кастомного построения ячеек дней
- Параметр `monthBuilder` в `ACPagesCalendarWidget` / `ACRawPagesCalendarWidget` для полной замены виджета месяца
- Параметр `monthLayout` для фиксированной раскладки сетки месяца
- Параметр `monthHeight` для фиксированной высоты сетки месяца
- Параметр `monthBuilder` в `ACCalendarWidget` / `ACRawCalendarWidget` / `ACCalendarScreen` для полной замены виджета месяца в скролл-календаре
- Параметр `monthLayoutBuilder` — коллбэк раскладки месяца для скролл-календаря (разные месяцы — разная раскладка)
- Параметр `monthHeightBuilder` — коллбэк высоты месяца для скролл-календаря
- Параметр `weekWidget` для замены стандартного `ACWeekWidget` кастомным виджетом строки дней недели
- Параметр `headerWidget` для замены стандартного `ACPagesCalendarHeader` кастомным заголовком

## 0.1.1

- Исправлены все dart analyze предупреждения (deprecated lint-правила, сортировка импортов)
- Добавлен entrypoint для замера производительности (`example/lib/main_perf.dart`)

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
