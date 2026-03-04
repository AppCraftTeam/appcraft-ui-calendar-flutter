# Задача 31: Создать ACDefaultLocalizationManager

**План:** `.claude/plans/localization-refactor-plan.md` — Фаза 1.2
**Зависимости:** Задача 30
**Файл:** `lib/src/localization/src/ac_default_localization_manager.dart`

## Что сделать

1. Создать `ACDefaultLocalizationManager extends ACLocalizationManager`
2. Const конструктор с параметрами:
   - `Map<String, ACLocalization> localizations` — дефолт: `{'ru': ACLocalizationRu(), 'en': ACLocalizationEn()}`
   - `ACLocalization fallback` — дефолт: `ACLocalizationRu()`
3. Реализовать `localization(String? localeName)` — текущая логика поиска (точное совпадение → код языка → fallback)
4. Обновить barrel `localization.dart` — добавить экспорт
