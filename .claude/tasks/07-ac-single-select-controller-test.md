# Задача 7: Тесты для ACCalendarSingleSelectController

**Приоритет:** Высокий
**Зависимости:** ACDateTimeExt
**Исходный файл:** `lib/src/presentation/src/select_controller/ac_calendar_single_select_controller.dart`
**Тестовый файл:** `test/presentation/select_controller/ac_calendar_single_select_controller_test.dart`

## Тест-кейсы

- `selectDay()` — выбор дня устанавливает `selected`
- `selectDay()` — повторный клик по выбранному дню сбрасывает `selected` в `null`
- `selectDay()` — клик по другому дню заменяет выбор
- `selectStateForDay()` — возвращает `ACDaySelectState.single` для выбранного дня
- `selectStateForDay()` — возвращает `null` для невыбранного
- `onChanged` callback вызывается при изменении
- `notifyListeners()` срабатывает при изменении
- Setter `selected` — уведомляет слушателей

## Указания

- Использовать `package:flutter_test` (ChangeNotifier)
- Проверять `notifyListeners` через `addListener()` счётчик
- Toggle-логика: повторный selectDay того же дня = deselect
