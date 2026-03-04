# План разделения виджетов на Raw + Scope-обёртки

## Цель

Разделить виджеты календаря на "глупые" (Raw) и "умные" (со scope).
Raw-виджеты содержат всю логику отображения, но не оборачивают результат в `ACCalendarScope`.
Обёртки — тонкие `StatelessWidget`, которые добавляют `ACCalendarScope` поверх Raw-виджета.

Родительские виджеты (`ACCalendarScreen`, `ACPagesCalendarCard`) переходят на Raw-виджеты и сами оборачивают в `ACCalendarScope`.

---

## Фаза 1 — ACRawPagesCalendarWidget

Файл: `lib/src/presentation/src/widgets/src/calendar/src/ac_raw_pages_calendar_widget.dart`

### Что делать

1. Создать `ACRawPagesCalendarWidget` — копия текущего `ACPagesCalendarWidget`, но:
   - Убрать поля `theme` и `selectController` (они нужны только для scope)
   - В `build()` убрать обёртку `ACCalendarScope(...)`, возвращать `Column` напрямую

2. Параметры `ACRawPagesCalendarWidget`:
   - `range` (required) — используется внутри для пагинации
   - `repository` — используется внутри для расчётов месяцев
   - `locale` — используется для форматирования
   - `initialMonth` — начальный месяц
   - `spacing` — отступы
   - `timeWidget` — виджет под сеткой дат

### Изменить ACPagesCalendarWidget

Файл: `lib/src/presentation/src/widgets/src/calendar/src/ac_pages_calendar_widget.dart`

Переписать как тонкий `StatelessWidget`:

```dart
class ACPagesCalendarWidget extends StatelessWidget {
  // Все текущие параметры сохраняются (range, repository, locale,
  // theme, selectController, initialMonth, spacing, timeWidget)

  @override
  Widget build(BuildContext context) =>
    ACCalendarScope(
      repository: repository,
      theme: theme,
      dateRange: range,
      selectController: selectController,
      child: ACRawPagesCalendarWidget(
        range: range,
        repository: repository,
        locale: locale,
        initialMonth: initialMonth,
        spacing: spacing,
        timeWidget: timeWidget,
      ),
    );
}
```

---

## Фаза 2 — ACRawCalendarWidget

Файл: `lib/src/presentation/src/widgets/src/calendar/src/ac_raw_calendar_widget.dart`

### Что делать

1. Создать `ACRawCalendarWidget` — копия текущего `ACCalendarWidget`, но:
   - Убрать поля `theme` и `selectController`
   - В `build()` убрать обёртку `ACCalendarScope(...)`, начинать с `LayoutBuilder` напрямую

2. Параметры `ACRawCalendarWidget`:
   - `range` (required) — используется для пагинации
   - `repository` — используется для расчётов
   - `scrollViewController` — внешний контроллер прокрутки
   - `initialDate` — начальная дата
   - `onVisibleDateChanged` — callback при смене месяца
   - `timeWidget` — виджет под лентой
   - `scrollViewPadding`, `weekPadding`, `timeWidgetPadding` — отступы

### Изменить ACCalendarWidget

Файл: `lib/src/presentation/src/widgets/src/calendar/src/ac_calendar_widget.dart`

Переписать как тонкий `StatelessWidget`:

```dart
class ACCalendarWidget extends StatelessWidget {
  // Все текущие параметры сохраняются

  @override
  Widget build(BuildContext context) =>
    ACCalendarScope(
      repository: repository,
      theme: theme,
      dateRange: range,
      selectController: selectController,
      child: ACRawCalendarWidget(
        range: range,
        repository: repository,
        scrollViewController: scrollViewController,
        initialDate: initialDate,
        onVisibleDateChanged: onVisibleDateChanged,
        timeWidget: timeWidget,
        scrollViewPadding: scrollViewPadding,
        weekPadding: weekPadding,
        timeWidgetPadding: timeWidgetPadding,
      ),
    );
}
```

---

## Фаза 3 — Родительские виджеты на Raw + свой scope

### 3.1 ACPagesCalendarCard

Файл: `lib/src/presentation/src/widgets/src/calendar/src/ac_pages_calendar_card.dart`

Заменить `ACPagesCalendarWidget` на `ACCalendarScope` + `ACRawPagesCalendarWidget`:

```dart
@override
Widget build(BuildContext context) {
  // ... effectiveDecoration ...

  return Container(
    decoration: effectiveDecoration,
    padding: padding ?? const EdgeInsets.all(16),
    child: ACCalendarScope(
      repository: repository,
      theme: theme,
      dateRange: range,
      selectController: selectController,
      child: ACRawPagesCalendarWidget(
        range: range,
        repository: repository,
        locale: locale,
        initialMonth: initialMonth,
        spacing: spacing,
        timeWidget: timeWidget,
      ),
    ),
  );
}
```

> Примечание: сейчас `ACPagesCalendarCard` не имеет поля `repository`.
> Нужно добавить `final ACCalendarRepository? repository;` в конструктор.

### 3.2 ACCalendarScreen

Файл: `lib/src/presentation/src/widgets/src/calendar/src/ac_calendar_screen.dart`

Заменить `ACCalendarWidget` на `ACCalendarScope` + `ACRawCalendarWidget`:

```dart
body: SafeArea(
  child: ACCalendarScope(
    theme: widget.theme,
    dateRange: widget.range,
    selectController: widget.selectController,
    child: ACRawCalendarWidget(
      scrollViewController: _scrollViewController,
      range: widget.range,
      initialDate: widget.initialDate,
      onVisibleDateChanged: _onVisibleDateChanged,
      timeWidget: widget.timeWidget,
      scrollViewPadding: ...,
      weekPadding: ...,
      timeWidgetPadding: ...,
    ),
  ),
),
```

---

## Фаза 4 — Barrel export

Файл: `lib/src/presentation/src/widgets/src/calendar/calendar.dart`

Добавить экспорты:

```dart
export 'src/ac_raw_calendar_widget.dart';
export 'src/ac_raw_pages_calendar_widget.dart';
```

---

## Порядок реализации

| Шаг | Действие | Файл |
|-----|----------|------|
| 1 | Создать `ACRawPagesCalendarWidget` | `ac_raw_pages_calendar_widget.dart` |
| 2 | Переписать `ACPagesCalendarWidget` как обёртку | `ac_pages_calendar_widget.dart` |
| 3 | Создать `ACRawCalendarWidget` | `ac_raw_calendar_widget.dart` |
| 4 | Переписать `ACCalendarWidget` как обёртку | `ac_calendar_widget.dart` |
| 5 | Обновить `ACPagesCalendarCard` | `ac_pages_calendar_card.dart` |
| 6 | Обновить `ACCalendarScreen` | `ac_calendar_screen.dart` |
| 7 | Обновить barrel export | `calendar.dart` |

---

## Открытые вопросы

1. **`ACPagesCalendarCard` не имеет поля `repository`** — нужно ли добавить, или `ACCalendarScope` может получить дефолтный репозиторий самостоятельно? Сейчас `ACCalendarScope` принимает `repository` как nullable и подставляет `ACDefaultCalendarRepository()` по умолчанию — значит можно не добавлять поле, передавать `null`.

2. **`ACCalendarScreen` не передаёт `repository` в `ACCalendarWidget`** — аналогично, scope создаст дефолтный. Но `ACRawCalendarWidget` тоже внутри создаёт дефолтный. Дублирования не будет, потому что Raw-виджет не использует repository из scope, а scope нужен только для дочерних виджетов (`ACCalendarDayWidget`).
