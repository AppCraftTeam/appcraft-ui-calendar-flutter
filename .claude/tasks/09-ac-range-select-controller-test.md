# Задача 9: Тесты для ACCalendarRangeSelectController

**Приоритет:** Высокий
**Зависимости:** ACDateSelectRange, ACDateTimeExt
**Исходный файл:** `lib/src/presentation/src/select_controller/ac_calendar_range_select_controller.dart`
**Тестовый файл:** `test/presentation/select_controller/ac_calendar_range_select_controller_test.dart`

## Тест-кейсы

### Выбор при пустом диапазоне

- Клик → `start` = day, `end` = null

### Выбор при наличии только `start`

- Клик по `start` → очистка (пустой диапазон)
- Клик после `start` → устанавливает `end`
- Клик до `start` → новый `start`, старый `start` → `end`

### Выбор при полном диапазоне (start + end)

- Клик по `start` → очистка
- Клик по `end` → очистка
- Клик внутри диапазона ближе к `start` → меняет `start`
- Клик внутри диапазона ближе к `end` → меняет `end`
- Клик за пределами диапазона после `end` → меняет `end`
- Клик за пределами диапазона перед `start` → меняет `start`

### `selectStateForDay()`

- `startOfRange` — для дня == `start`
- `endOfRange` — для дня == `end`
- `middleInRange` — для дня между `start` и `end`
- `null` — для дня вне диапазона

## Указания

- Самый сложный контроллер — state machine с множеством переходов
- Использовать конкретные даты для воспроизводимости (например, 1–30 января 2024)
- Проверять proximity-логику: середина диапазона, ближе к start/end
