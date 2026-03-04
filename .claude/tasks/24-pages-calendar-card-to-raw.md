# Задача 24: Перевести ACPagesCalendarCard на Raw + scope

**План:** `.claude/plans/raw-widgets-plan.md` — Фаза 3.1
**Зависимости:** Задача 20
**Файл:** `lib/src/presentation/src/widgets/src/calendar/src/ac_pages_calendar_card.dart`

## Что сделать

1. Заменить `ACPagesCalendarWidget` на `ACCalendarScope` + `ACRawPagesCalendarWidget`
2. Scope оборачивает raw-виджет, передавая `theme`, `selectController`, `range`
3. Raw-виджет получает `range`, `locale`, `initialMonth`, `spacing`, `timeWidget`

## Примечание

- `ACPagesCalendarCard` не имеет поля `repository` — scope подставит `ACDefaultCalendarRepository` по умолчанию, дополнительных изменений не нужно
