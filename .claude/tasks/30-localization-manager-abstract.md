# Задача 30: ACLocalizationManager → abstract class

**План:** `.claude/plans/localization-refactor-plan.md` — Фаза 1.1
**Файл:** `lib/src/localization/src/ac_localization_manager.dart`

## Что сделать

1. Убрать приватный конструктор `ACLocalizationManager._()`
2. Убрать `static final instance`
3. Убрать `localizations` и метод `localization()`
4. Сделать класс `abstract` с const конструктором
5. Объявить абстрактный метод `ACLocalization localization(String? localeName)`
