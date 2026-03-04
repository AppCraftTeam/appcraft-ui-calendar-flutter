# Задача 8: Тесты для ACCalendarMultiSelectController

**Приоритет:** Высокий
**Зависимости:** ACDateTimeExt
**Исходный файл:** `lib/src/presentation/src/select_controller/ac_calendar_multi_select_controller.dart`
**Тестовый файл:** `test/presentation/select_controller/ac_calendar_multi_select_controller_test.dart`

## Тест-кейсы

- `selectDay()` — добавляет новый день в список
- `selectDay()` — повторный клик удаляет день из списка
- `selected` — список отсортирован по дате
- `selectStateForDay()` — возвращает `ACDaySelectState.multi` для выбранного
- `selectStateForDay()` — возвращает `null` для невыбранного
- `onChanged` вызывается с отсортированным списком
- Setter `selected` — принимает внешний список, сортирует

## Указания

- Использовать `package:flutter_test` (ChangeNotifier)
- Проверить, что внутренний список — копия (не мутирует входной)
- Добавлять даты в произвольном порядке, проверять сортировку
