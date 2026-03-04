# Задача 23: Переписать ACCalendarWidget как обёртку

**План:** `.claude/plans/raw-widgets-plan.md` — Фаза 2
**Зависимости:** Задача 22
**Файл:** `lib/src/presentation/src/widgets/src/calendar/src/ac_calendar_widget.dart`

## Что сделать

1. Переписать `ACCalendarWidget` из `StatefulWidget` в `StatelessWidget`
2. Сохранить все текущие параметры (range, repository, theme, selectController, scrollViewController, initialDate, onVisibleDateChanged, timeWidget, scrollViewPadding, weekPadding, timeWidgetPadding)
3. В `build()`:
   - Обернуть `ACRawCalendarWidget` в `ACCalendarScope`
   - Передать `theme`, `selectController`, `range` в scope
   - Передать остальные параметры в raw-виджет

## Важно

- Публичный API виджета не меняется
