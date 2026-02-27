# Localization: выбор подхода

## Контекст

Текущая реализация использует синглтон `ACLocalizationManager.instance.localization(locale)`.
Нужно определиться с финальным подходом.

## Варианты

### Вариант 1: Статические методы (самый простой)

Убрать `instance`, сделать `localizations` и метод статическими.
`ACLocalizationManager` по сути stateless — нет смысла в синглтоне.

```dart
class ACLocalizationManager {
  static final Map<String, ACLocalization> localizations = { ... };

  static ACLocalization localization(String? localeName) => ...;
}

// Использование:
ACLocalizationManager.localization(locale)
```

### Вариант 2: Добавить в ACCalendarScope ✅ рекомендуется

Локализация — такой же контекстный параметр как тема.
`ACCalendarScope` уже оборачивает все виджеты, можно добавить туда `localization`.

```dart
ACCalendarScope(
  dateRange: ...,
  localization: const ACLocalizationEn(), // опционально
  child: ...
)

// Внутри виджетов:
ACCalendarScope.maybeOf(context)?.localization
  ?? ACLocalizationManager.localization(locale)
```

**Плюсы:** органично вписывается в существующий API, не нужен новый scope,
пользователи уже оборачивают виджеты в `ACCalendarScope`.

### Вариант 3: Отдельный InheritedWidget

Аналогично `ACCalendarTheme.of(context)`.

```dart
ACLocalizationScope(
  localization: const ACLocalizationEn(),
  child: ...
)

// Внутри виджетов:
ACLocalizationScope.of(context)
```

**Минус:** избыточен ради 3 строк.

## Итог

- **Вариант 2** — наиболее органичен: расширяет уже существующий `ACCalendarScope`.
- **Вариант 1** — простой рефакторинг, если не хочется трогать `ACCalendarScope`.
- **Вариант 3** — избыточен.
