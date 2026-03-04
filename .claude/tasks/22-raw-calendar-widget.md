# Задача 22: Создать ACRawCalendarWidget

**План:** `.claude/plans/raw-widgets-plan.md` — Фаза 2
**Файл:** `lib/src/presentation/src/widgets/src/calendar/src/ac_raw_calendar_widget.dart`

## Что сделать

1. Создать `ACRawCalendarWidget` (StatefulWidget) — копия текущего `ACCalendarWidget`, но:
   - Убрать поля `theme` и `selectController`
   - В `build()` убрать обёртку `ACCalendarScope(...)`, начинать с `LayoutBuilder` напрямую

2. Параметры:
   - `range` (required)
   - `repository`
   - `scrollViewController`
   - `initialDate`
   - `onVisibleDateChanged`
   - `timeWidget`
   - `scrollViewPadding`
   - `weekPadding`
   - `timeWidgetPadding`

3. Вся State-логика (_range, _currentMonth, _scrollViewController, _scrollViewDataSource, _monthDataCache, didUpdateWidget, dispose) переносится без изменений.
