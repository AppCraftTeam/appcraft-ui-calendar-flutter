# Задача 3: Тесты для ACDateSelectRange

**Приоритет:** Высокий
**Зависимости:** Нет
**Исходный файл:** `lib/src/domain/src/ac_date_select_range.dart`
**Тестовый файл:** `test/domain/ac_date_select_range_test.dart`

## Тест-кейсы

- Конструктор: передан только `end` → нормализуется в `start`
- Конструктор: `start` без `end` → `end` = null
- Конструктор: `start` и `end` установлены корректно
- `single` — возвращает `start`, если `end` == null
- `single` — возвращает `end`, если `start` == null
- `single` — возвращает `null`, если оба установлены
- `isEmpty` — true при отсутствии обоих
- `copyWith()` — изменяет только указанные поля

## Указания

- Чистый Dart, без Flutter-зависимостей
- Обратить внимание на нормализацию в конструкторе (end без start)
