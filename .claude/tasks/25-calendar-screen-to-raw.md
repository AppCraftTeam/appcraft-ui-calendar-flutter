# Задача 25: Перевести ACCalendarScreen на Raw + scope

**План:** `.claude/plans/raw-widgets-plan.md` — Фаза 3.2
**Зависимости:** Задача 22
**Файл:** `lib/src/presentation/src/widgets/src/calendar/src/ac_calendar_screen.dart`

## Что сделать

1. Заменить `ACCalendarWidget` на `ACCalendarScope` + `ACRawCalendarWidget`
2. Scope оборачивает raw-виджет в `SafeArea.child`, передавая `theme`, `selectController`, `range`
3. Raw-виджет получает `range`, `scrollViewController`, `initialDate`, `onVisibleDateChanged`, `timeWidget`, padding-параметры

## Примечание

- `ACCalendarScreen` не передаёт `repository` — scope подставит дефолтный
