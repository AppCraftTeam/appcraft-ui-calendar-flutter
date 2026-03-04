# Задача 20: Создать ACRawPagesCalendarWidget

**План:** `.claude/plans/raw-widgets-plan.md` — Фаза 1
**Файл:** `lib/src/presentation/src/widgets/src/calendar/src/ac_raw_pages_calendar_widget.dart`

## Что сделать

1. Создать `ACRawPagesCalendarWidget` (StatefulWidget) — копия текущего `ACPagesCalendarWidget`, но:
   - Убрать поля `theme` и `selectController`
   - В `build()` убрать обёртку `ACCalendarScope(...)`, возвращать `Column` напрямую

2. Параметры:
   - `range` (required)
   - `repository`
   - `locale`
   - `initialMonth`
   - `spacing`
   - `timeWidget`

3. Вся State-логика (_range, _currentMonth, _scrollViewController, _scrollViewDataSource, кэш, didUpdateWidget, dispose) переносится без изменений.
