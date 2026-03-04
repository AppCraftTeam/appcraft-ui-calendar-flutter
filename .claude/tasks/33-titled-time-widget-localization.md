# Задача 33: Обновить ACTitledTimeWidget — локализация из scope

**План:** `.claude/plans/localization-refactor-plan.md` — Фаза 3.1
**Зависимости:** Задача 32
**Файл:** `lib/src/presentation/src/widgets/src/time_input/src/ac_titled_time_widget.dart`

## Что сделать

1. Заменить `ACLocalizationManager.instance.localization(...)` на получение через scope
2. Fallback на `ACDefaultLocalizationManager()` если scope не найден
3. Убрать импорт `ac_localization_manager.dart` если больше не нужен
