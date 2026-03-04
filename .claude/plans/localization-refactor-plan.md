# План рефакторинга локализации

## Цель

1. `ACLocalizationManager` → abstract class
2. `ACDefaultLocalizationManager` → конкретная реализация с `localizations` в const конструкторе
3. Добавить `ACLocalizationManager` в `ACCalendarScope`
4. Виджеты вне scope (ACMonthPickerSheet) принимают менеджер через параметр

---

## Фаза 1 — Рефакторинг ACLocalizationManager

### 1.1 ACLocalizationManager → abstract

Файл: `lib/src/localization/src/ac_localization_manager.dart`

```text
abstract class ACLocalizationManager {
  const ACLocalizationManager();

  ACLocalization localization(String? localeName);
}
```

### 1.2 Создать ACDefaultLocalizationManager

Файл: `lib/src/localization/src/ac_default_localization_manager.dart`

```text
class ACDefaultLocalizationManager extends ACLocalizationManager {
  const ACDefaultLocalizationManager({
    this.localizations = const {
      'ru': ACLocalizationRu(),
      'en': ACLocalizationEn(),
    },
    this.fallback = const ACLocalizationRu(),
  });

  final Map<String, ACLocalization> localizations;
  final ACLocalization fallback;

  @override
  ACLocalization localization(String? localeName) {
    if (localeName == null) return fallback;
    return localizations[localeName]
        ?? localizations[localeName.split('-').first]
        ?? fallback;
  }
}
```

### 1.3 Обновить barrel

Файл: `lib/src/localization/localization.dart`

Добавить:

```text
export 'src/ac_default_localization_manager.dart';
```

---

## Фаза 2 — Добавить в ACCalendarScope

Файл: `lib/src/presentation/src/ac_calendar_scope.dart`

1. Добавить поле `ACLocalizationManager? localizationManager`
2. В factory-конструкторе: принимать как nullable, передавать в `.raw()`
3. В `.raw()`: хранить как nullable
4. Добавить геттер/метод для удобного получения локализации:

```text
ACLocalization localization(String? locale) =>
  (localizationManager ?? const ACDefaultLocalizationManager())
    .localization(locale);
```

5. Обновить `updateShouldNotify` — добавить проверку `localizationManager`

---

## Фаза 3 — Обновить виджеты-потребители

### 3.1 ACTitledTimeWidget

Файл: `lib/src/presentation/src/widgets/src/time_input/src/ac_titled_time_widget.dart`

Текущий код (строка 66-68):

```text
title ?? ACLocalizationManager.instance.localization(
  Localizations.maybeLocaleOf(context)?.toLanguageTag(),
).time,
```

Заменить на:

```text
title ?? ACCalendarScope.maybeOf(context)?.localization(
  Localizations.maybeLocaleOf(context)?.toLanguageTag(),
).time ?? const ACDefaultLocalizationManager().localization(
  Localizations.maybeLocaleOf(context)?.toLanguageTag(),
).time,
```

Или проще — вынести в переменную:

```text
final locale = Localizations.maybeLocaleOf(context)?.toLanguageTag();
final effectiveTitle = title
  ?? (ACCalendarScope.maybeOf(context)?.localization(locale)
    ?? const ACDefaultLocalizationManager().localization(locale)).time;
```

### 3.2 ACMonthPickerSheet

Файл: `lib/src/presentation/src/widgets/src/month_picker/src/ac_month_picker_sheet.dart`

1. Добавить поле `ACLocalizationManager? localizationManager` в конструктор и в `show()`
2. Заменить (строки 116-118):

```text
final localization = ACLocalizationManager.instance.localization(
  widget.locale ?? Localizations.maybeLocaleOf(context)?.toLanguageTag(),
);
```

На:

```text
final localization = (widget.localizationManager
  ?? const ACDefaultLocalizationManager()
).localization(
  widget.locale ?? Localizations.maybeLocaleOf(context)?.toLanguageTag(),
);
```

---

## Tasks

- .claude/tasks/30-localization-manager-abstract.md
- .claude/tasks/31-default-localization-manager.md
- .claude/tasks/32-scope-localization-manager.md
- .claude/tasks/33-titled-time-widget-localization.md
- .claude/tasks/34-month-picker-sheet-localization.md

---

## Порядок реализации

| Шаг | Действие | Файл |
|-----|----------|------|
| 1 | ACLocalizationManager → abstract | `ac_localization_manager.dart` |
| 2 | Создать ACDefaultLocalizationManager | `ac_default_localization_manager.dart` |
| 3 | Обновить barrel localization.dart | `localization.dart` |
| 4 | Добавить localizationManager в ACCalendarScope | `ac_calendar_scope.dart` |
| 5 | Обновить ACTitledTimeWidget | `ac_titled_time_widget.dart` |
| 6 | Обновить ACMonthPickerSheet + show() | `ac_month_picker_sheet.dart` |
