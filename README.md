# appcraft_ui_calendar_flutter

[![Pub Version](https://img.shields.io/pub/v/appcraft_ui_calendar_flutter)](https://pub.dev/packages/appcraft_ui_calendar_flutter)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Flutter-пакет календаря с поддержкой выбора дат, темизации и множества режимов
отображения. Предоставляет готовые виджеты — полноэкранный вертикальный
календарь `ACCalendarScreen`, постраничный горизонтальный `ACPagesCalendarWidget`
и карточный `ACPagesCalendarCard` — три режима выбора (одиночный, диапазон,
мульти), детальную темизацию через `ThemeExtension`, виджет выбора времени и
локализацию. Подходит для любого экрана, где нужен кастомизируемый компонент
выбора дат, — без написания календарной логики с нуля.

## Возможности

- **Три режима выбора дат**: одиночный (`ACCalendarSingleSelectController`),
  диапазон (`ACCalendarRangeSelectController`),
  мульти-выбор (`ACCalendarMultiSelectController`).
- **Готовые виджеты**: `ACCalendarScreen` (полноэкранный вертикальный календарь
  со `Scaffold` и `AppBar`) и `ACPagesCalendarWidget` (постраничный
  горизонтальный календарь).
- **Карточный компонент**: `ACPagesCalendarCard` — карточка на основе
  `ACPagesCalendarWidget`.
- **Встроенная тема**: `ACLightCalendarThemeData` с детальной кастомизацией
  через `ACLightDayThemeData`, `ACLightWeekThemeData` и другие sub-themes.
- **Виджет выбора времени**: `ACTitledTimeWidget` для отображения под календарём.
- **Локализация**: настройка через параметр `locale` (например, `'ru'`, `'en'`).
- **Ограничение диапазона навигации**: `ACDateRange(min:, max:)` задаёт
  допустимые границы.

## Установка

```bash
flutter pub add appcraft_ui_calendar_flutter
```

## Использование

### 1. Одиночный выбор — `ACCalendarSingleSelectController`

Выбор одной даты с полноэкранным представлением `ACCalendarScreen`.

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

### 2. Выбор диапазона — `ACCalendarRangeSelectController`

Выбор диапазона дат с виджетом времени под календарём.

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

### 3. Мульти-выбор — `ACCalendarMultiSelectController`

Выбор нескольких произвольных дат.

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

### 4. Постраничный календарь — `ACPagesCalendarWidget`

Горизонтальный календарь с переопределением цветов через `ThemeExtension`
и локализацией.

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

## Темизация

Тема календаря интегрируется через стандартный механизм Flutter
`ThemeExtension`. Это позволяет задавать тему на уровне `ThemeData`
приложения и переопределять её для отдельных поддеревьев виджетов.

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

`ACLightCalendarThemeData` объединяет несколько sub-theme классов, каждый из
которых отвечает за свою часть календаря:

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

`ACCalendarThemeExtension.of(context)` возвращает тему из ближайшего `Theme`.
Если тема не задана явно, возвращаются значения по умолчанию (светлая тема):

```dart
@override
Widget build(BuildContext context) {
  final calendarTheme = ACCalendarThemeExtension.of(context);
  final dayColor = calendarTheme.dayTheme.textColor;
  // ...
}
```

## Справочник API

**Виджеты:**

- `ACCalendarScreen` — полноэкранный вертикальный скролл-календарь со
  `Scaffold` и `AppBar`.
- `ACCalendarWidget` / `ACRawCalendarWidget` — вертикальный скролл-календарь
  (с темизацией / без обёртки темы).
- `ACPagesCalendarWidget` / `ACRawPagesCalendarWidget` — постраничный
  горизонтальный календарь.
- `ACPagesCalendarCard` — карточка на основе постраничного календаря.
- `ACPagesCalendarSheet` — bottom sheet с постраничным календарём.
- `ACTitledTimeWidget`, `ACTimeInputWidget`, `ACTimeRangeInputWidget` —
  виджеты выбора времени.

**Контроллеры выбора:**

- `ACCalendarSelectController` — базовый контроллер (`ChangeNotifier`).
- `ACCalendarSingleSelectController` — выбор одной даты.
- `ACCalendarRangeSelectController` — выбор диапазона дат.
- `ACCalendarMultiSelectController` — выбор нескольких дат.

**Доменные типы:**

- `ACDateRange` — границы навигации (`min`, `max`).
- `ACDateSelectRange`, `ACTimeSelectRange` — выбранный диапазон дат / времени.
- `ACDayMonthPosition` — позиция дня в сетке месяца (`current`/`leading`/
  `trailing`); factory `ACDayMonthPosition.forDay(day, monthDate)`.
- `ACDaySelectState` — состояние выбора дня.
- `ACDateFormat` — форматирование дат.

**Темизация:**

- `ACCalendarThemeExtension` — `ThemeExtension` для интеграции темы календаря.
- `ACLightCalendarThemeData` — светлая тема и её sub-themes
  (`ACLightDayThemeData`, `ACLightWeekThemeData`,
  `ACLightMonthPickerThemeData`, `ACLightPagesCalendarHeaderThemeData` и др.).

**Локализация:**

- `ACLocalizationManager` / `ACDefaultLocalizationManager` — менеджер локализации.
- `ACLocalization`, `ACLocalizationRu`, `ACLocalizationEn` — наборы строк.

Подробная документация доступна в dartdoc на pub.dev.

## Пример

Полноценный пример приложения с демонстрацией всех режимов выбора и
возможностей пакета находится в папке [`example/`](./example).

Запуск:

```bash
cd example
flutter pub get
flutter run
```

## Лицензия

MIT — см. [LICENSE](./LICENSE).
