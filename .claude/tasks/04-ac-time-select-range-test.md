# Задача 4: Тесты для ACTimeSelectRange

**Приоритет:** Высокий
**Зависимости:** Flutter (TimeOfDay)
**Исходный файл:** `lib/src/domain/src/ac_time_select_range.dart`
**Тестовый файл:** `test/domain/ac_time_select_range_test.dart`

## Тест-кейсы

- Аналогичные ACDateSelectRange, но с `TimeOfDay`
- Конструктор: нормализация при передаче только `end`
- Конструктор: `start` без `end` → `end` = null
- Конструктор: `start` и `end` установлены корректно
- `single` — корректное поведение
- `isEmpty` — true при отсутствии обоих
- `copyWith()` — изменяет только указанные поля

## Указания

- Использовать `package:flutter_test` (зависимость от `TimeOfDay`)
- Логика аналогична ACDateSelectRange
