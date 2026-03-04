# Задача 34: Обновить ACMonthPickerSheet — локализация через параметр

**План:** `.claude/plans/localization-refactor-plan.md` — Фаза 3.2
**Зависимости:** Задача 31
**Файл:** `lib/src/presentation/src/widgets/src/month_picker/src/ac_month_picker_sheet.dart`

## Что сделать

1. Добавить `ACLocalizationManager? localizationManager` в конструктор и в `show()`
2. Заменить `ACLocalizationManager.instance.localization(...)` на:
   ```dart
   (widget.localizationManager ?? const ACDefaultLocalizationManager())
     .localization(locale)
   ```

## Примечание

ACMonthPickerSheet открывается через `showModalBottomSheet` с `useRootNavigator: true` — он вне дерева ACCalendarScope, поэтому менеджер передаётся явно через параметр.
