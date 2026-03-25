# appcraft-ui-calendar-flutter

[![version](https://img.shields.io/badge/version-0.2.0-white.svg)](https://semver.org)

Flutter-пакет календаря с поддержкой выбора дат, темизации и множества режимов отображения. Предназначен для мобильных приложений на Flutter, которым нужен готовый, кастомизируемый компонент выбора дат — без написания календарной логики с нуля.

## Возможности

- **Три режима выбора дат**: одиночный (`single`), диапазон (`range`), мульти-выбор (`multi`)
- **Два основных виджета**: `ACCalendarScreen` (полноэкранный вертикальный календарь со Scaffold и AppBar) и `ACPagesCalendarWidget` (постраничный горизонтальный календарь)
- **Карточный компонент**: `ACPagesCalendarCard` — карточка на основе `ACPagesCalendarWidget`
- **Встроенная тема**: `ACLightCalendarThemeData` с поддержкой детальной кастомизации через `ACLightDayThemeData` и `ACLightWeekThemeData`
- **Виджет выбора времени**: `ACTitledTimeWidget` для отображения под календарём
- **Локализация**: настройка через параметр `locale` (например, `'ru'`, `'en'`)
- **Ограничение диапазона навигации**: `ACDateRange(min:, max:)` задаёт допустимые границы

## Installation

Добавьте зависимость в `pubspec.yaml`:

```yaml
dependencies:
  appcraft_ui_calendar_flutter:
    git:
      url: https://github.com/AppCraftTeam/appcraft-ui-calendar-flutter.git
      ref: main
```

Затем выполните:

```bash
flutter pub get
```

## Quick Start

### ACCalendarScreen — Single Select

Выбор одной даты с полноэкранным представлением:

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

### ACCalendarScreen — Range Select

Выбор диапазона дат с виджетом времени:

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

### ACCalendarScreen — Multi Select

Выбор нескольких дат:

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

### ACPagesCalendarWidget — Кастомная тема

Постраничный горизонтальный календарь с переопределением цветов через `ThemeExtension`:

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

## Example

Полный пример приложения с демонстрацией всех режимов и возможностей пакета:
[example/](example/)

## Темизация

Тема календаря интегрируется через стандартный механизм Flutter `ThemeExtension`. Это позволяет задавать тему календаря на уровне `ThemeData` приложения и переопределять её для отдельных поддеревьев виджетов.

### Установка темы на уровне приложения

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

### Кастомизация sub-themes

`ACLightCalendarThemeData` объединяет несколько sub-theme классов, каждый из которых отвечает за свою часть календаря:

```dart
ACLightCalendarThemeData(
  // Тема ячейки дня
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
  // Тема строки дней недели
  weekTheme: ACLightWeekThemeData(
    textColor: Colors.grey,
  ),
  // Тема пикера месяцев
  monthPickerTheme: ACLightMonthPickerThemeData(
    actionTextColor: Colors.indigo,
  ),
  // Тема заголовка постраничного календаря
  pagesCalendarHeaderTheme: ACLightPagesCalendarHeaderThemeData(
    arrowRotateDuration: const Duration(milliseconds: 200),
  ),
  // Общий фон календаря
  backgroundColor: Colors.white,
)
```

### Получение темы из контекста

Метод `ACCalendarThemeExtension.of(context)` возвращает тему из ближайшего `Theme`. Если тема не была явно задана, возвращаются значения по умолчанию (светлая тема):

```dart
@override
Widget build(BuildContext context) {
  final calendarTheme = ACCalendarThemeExtension.of(context);
  final dayColor = calendarTheme.dayTheme.textColor;
  // ...
}
```
