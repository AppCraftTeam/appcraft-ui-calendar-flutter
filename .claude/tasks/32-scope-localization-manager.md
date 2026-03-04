# Задача 32: Добавить ACLocalizationManager в ACCalendarScope

**План:** `.claude/plans/localization-refactor-plan.md` — Фаза 2
**Зависимости:** Задачи 30, 31
**Файл:** `lib/src/presentation/src/ac_calendar_scope.dart`

## Что сделать

1. Добавить поле `ACLocalizationManager? localizationManager` в оба конструктора (factory и `.raw()`)
2. Добавить метод для получения локализации:
   ```dart
   ACLocalization localization(String? locale) =>
     (localizationManager ?? const ACDefaultLocalizationManager())
       .localization(locale);
   ```
3. Обновить `updateShouldNotify` — добавить проверку `localizationManager`
