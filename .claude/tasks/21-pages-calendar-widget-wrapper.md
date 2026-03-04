# Задача 21: Переписать ACPagesCalendarWidget как обёртку

**План:** `.claude/plans/raw-widgets-plan.md` — Фаза 1
**Зависимости:** Задача 20
**Файл:** `lib/src/presentation/src/widgets/src/calendar/src/ac_pages_calendar_widget.dart`

## Что сделать

1. Переписать `ACPagesCalendarWidget` из `StatefulWidget` в `StatelessWidget`
2. Сохранить все текущие параметры (range, repository, locale, theme, selectController, initialMonth, spacing, timeWidget)
3. В `build()`:
   - Обернуть `ACRawPagesCalendarWidget` в `ACCalendarScope`
   - Передать `theme`, `selectController`, `range` в scope
   - Передать `range`, `repository`, `locale`, `initialMonth`, `spacing`, `timeWidget` в raw-виджет

## Важно

- Публичный API виджета не меняется — пользователи библиотеки не заметят разницы
