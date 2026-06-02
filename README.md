# appcraft_ui_calendar_flutter

[![Pub Version](https://img.shields.io/pub/v/appcraft_ui_calendar_flutter)](https://pub.dev/packages/appcraft_ui_calendar_flutter)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A Flutter calendar package with date selection, theming and multiple display
modes. It provides ready-to-use widgets — the full-screen vertical calendar
`ACCalendarScreen`, the paged horizontal `ACPagesCalendarWidget` and the
card-based `ACPagesCalendarCard` — three selection modes (single, range,
multi), fine-grained theming via `ThemeExtension`, a time-picker widget and
localization. Suitable for any screen that needs a customizable date-selection
component — without writing calendar logic from scratch.

## Features

- **Three date-selection modes**: single (`ACCalendarSingleSelectController`),
  range (`ACCalendarRangeSelectController`),
  multi (`ACCalendarMultiSelectController`).
- **Ready-to-use widgets**: `ACCalendarScreen` (full-screen vertical calendar
  with `Scaffold` and `AppBar`) and `ACPagesCalendarWidget` (paged horizontal
  calendar).
- **Card component**: `ACPagesCalendarCard` — a card based on
  `ACPagesCalendarWidget`.
- **Built-in theme**: `ACLightCalendarThemeData` with fine-grained
  customization via `ACLightDayThemeData`, `ACLightWeekThemeData` and other
  sub-themes.
- **Time-picker widget**: `ACTitledTimeWidget` for display below the calendar.
- **Localization**: configured via the `locale` parameter (e.g. `'ru'`, `'en'`).
- **Navigation range limit**: `ACDateRange(min:, max:)` sets the allowed bounds.

## Installation

```bash
flutter pub add appcraft_ui_calendar_flutter
```

## Usage

### 1. Single selection — `ACCalendarSingleSelectController`

Select a single date with the full-screen `ACCalendarScreen`.

```dart
import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';

class SingleSelectPage extends StatefulWidget {
  const SingleSelectPage({super.key});

  @override
  State<SingleSelectPage> createState() => _SingleSelectPageState();
}

class _SingleSelectPageState extends State<SingleSelectPage> {
  final _selectController = ACCalendarSingleSelectController();

  @override
  void dispose() {
    _selectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ACCalendarScreen(
      range: ACDateRange(
        min: DateTime(2024, 1, 1),
        max: DateTime(2025, 12, 31),
      ),
      selectController: _selectController,
    );
  }
}
```

### 2. Range selection — `ACCalendarRangeSelectController`

Select a date range with a time widget below the calendar.

```dart
class RangeSelectPage extends StatefulWidget {
  const RangeSelectPage({super.key});

  @override
  State<RangeSelectPage> createState() => _RangeSelectPageState();
}

class _RangeSelectPageState extends State<RangeSelectPage> {
  final _selectController = ACCalendarRangeSelectController();

  @override
  void dispose() {
    _selectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ACCalendarScreen(
      range: ACDateRange(
        min: DateTime(2024, 1, 1),
        max: DateTime(2025, 12, 31),
      ),
      selectController: _selectController,
      timeWidget: ACTitledTimeWidget.range(),
    );
  }
}
```

### 3. Multi selection — `ACCalendarMultiSelectController`

Select multiple arbitrary dates.

```dart
class MultiSelectPage extends StatefulWidget {
  const MultiSelectPage({super.key});

  @override
  State<MultiSelectPage> createState() => _MultiSelectPageState();
}

class _MultiSelectPageState extends State<MultiSelectPage> {
  final _selectController = ACCalendarMultiSelectController();

  @override
  void dispose() {
    _selectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ACCalendarScreen(
      range: ACDateRange(
        min: DateTime(2024, 1, 1),
        max: DateTime(2025, 12, 31),
      ),
      selectController: _selectController,
    );
  }
}
```

### 4. Paged calendar — `ACPagesCalendarWidget`

A horizontal calendar with color overrides via `ThemeExtension` and
localization.

```dart
import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';

class CustomThemeCalendarPage extends StatefulWidget {
  const CustomThemeCalendarPage({super.key});

  @override
  State<CustomThemeCalendarPage> createState() =>
      _CustomThemeCalendarPageState();
}

class _CustomThemeCalendarPageState extends State<CustomThemeCalendarPage> {
  final _selectController = ACCalendarSingleSelectController();

  @override
  void dispose() {
    _selectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        extensions: [
          ACCalendarThemeExtension(
            data: ACLightCalendarThemeData(
              dayTheme: ACLightDayThemeData(
                selectedBackgroundColor: Colors.deepPurple,
                textColor: Colors.black,
                todayTextStyle: const TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: ACPagesCalendarWidget(
            range: ACDateRange(
              min: DateTime(2024, 1, 1),
              max: DateTime(2025, 12, 31),
            ),
            selectController: _selectController,
            locale: 'ru',
          ),
        ),
      ),
    );
  }
}
```

## Theming

The calendar theme integrates through Flutter's standard `ThemeExtension`
mechanism. This lets you define the theme at the application's `ThemeData`
level and override it for individual widget subtrees.

### Setting the theme at the application level

```dart
MaterialApp(
  theme: ThemeData(
    extensions: [
      ACCalendarThemeExtension(
        data: ACLightCalendarThemeData(
          backgroundColor: Colors.white,
          dayTheme: ACLightDayThemeData(
            selectedBackgroundColor: Colors.indigo,
            textColor: Colors.grey.shade800,
          ),
          weekTheme: ACLightWeekThemeData(
            textColor: Colors.grey.shade600,
          ),
        ),
      ),
    ],
  ),
  home: const MyHomePage(),
);
```

### Customizing sub-themes

`ACLightCalendarThemeData` combines several sub-theme classes, each responsible
for its own part of the calendar:

```dart
ACLightCalendarThemeData(
  // Day cell theme
  dayTheme: ACLightDayThemeData(
    selectedBackgroundColor: Colors.indigo,
    middleSelectedBackgroundColor: Colors.indigo.shade100,
    textColor: Colors.black,
    inactiveTextColor: Colors.grey,
    todayTextStyle: const TextStyle(
      color: Colors.indigo,
      fontWeight: FontWeight.bold,
    ),
  ),
  // Weekday row theme
  weekTheme: ACLightWeekThemeData(
    textColor: Colors.grey,
  ),
  // Month picker theme
  monthPickerTheme: ACLightMonthPickerThemeData(
    actionTextColor: Colors.indigo,
  ),
  // Paged calendar header theme
  pagesCalendarHeaderTheme: ACLightPagesCalendarHeaderThemeData(
    arrowRotateDuration: const Duration(milliseconds: 200),
  ),
  // Overall calendar background
  backgroundColor: Colors.white,
)
```

### Obtaining the theme from context

`ACCalendarThemeExtension.of(context)` returns the theme from the nearest
`Theme`. If the theme is not set explicitly, default values are returned
(the light theme):

```dart
@override
Widget build(BuildContext context) {
  final calendarTheme = ACCalendarThemeExtension.of(context);
  final dayColor = calendarTheme.dayTheme.textColor;
  // ...
}
```

## API Reference

**Widgets:**

- `ACCalendarScreen` — full-screen vertical scroll calendar with `Scaffold`
  and `AppBar`.
- `ACCalendarWidget` / `ACRawCalendarWidget` — vertical scroll calendar
  (with theming / without the theme wrapper).
- `ACPagesCalendarWidget` / `ACRawPagesCalendarWidget` — paged horizontal
  calendar.
- `ACPagesCalendarCard` — a card based on the paged calendar.
- `ACPagesCalendarSheet` — a bottom sheet with the paged calendar.
- `ACTitledTimeWidget`, `ACTimeInputWidget`, `ACTimeRangeInputWidget` —
  time-selection widgets.

**Selection controllers:**

- `ACCalendarSelectController` — base controller (`ChangeNotifier`).
- `ACCalendarSingleSelectController` — single date selection.
- `ACCalendarRangeSelectController` — date range selection.
- `ACCalendarMultiSelectController` — multiple date selection.

**Domain types:**

- `ACDateRange` — navigation bounds (`min`, `max`).
- `ACDateSelectRange`, `ACTimeSelectRange` — the selected date / time range.
- `ACDayMonthPosition` — a day's position in the month grid (`current`/`leading`/
  `trailing`); factory `ACDayMonthPosition.forDay(day, monthDate)`.
- `ACDaySelectState` — a day's selection state.
- `ACDateFormat` — date formatting.

**Theming:**

- `ACCalendarThemeExtension` — a `ThemeExtension` for integrating the calendar
  theme.
- `ACLightCalendarThemeData` — the light theme and its sub-themes
  (`ACLightDayThemeData`, `ACLightWeekThemeData`,
  `ACLightMonthPickerThemeData`, `ACLightPagesCalendarHeaderThemeData`, etc.).

**Localization:**

- `ACLocalizationManager` / `ACDefaultLocalizationManager` — the localization
  manager.
- `ACLocalization`, `ACLocalizationRu`, `ACLocalizationEn` — string sets.

Detailed documentation is available in the dartdoc on pub.dev.

## Example

A complete example app demonstrating all selection modes and package features
is available in the [`example/`](./example) folder.

To run it:

```bash
cd example
flutter pub get
flutter run
```

## License

MIT — see [LICENSE](./LICENSE).
