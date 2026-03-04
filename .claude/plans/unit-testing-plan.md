# План unit-тестирования библиотеки appcraft-ui-calendar-flutter

## Обзор

Покрытие тестами компонентов с бизнес-логикой. Чистый Dart-код тестируется через `package:test`, виджеты — через `package:flutter_test`.

---

## Фаза 1 — Domain-модели (чистый Dart, без зависимостей)

### 1.1 `ACDateTimeExt` (`lib/src/utils/src/ac_date_time_ext.dart`)

Файл: `test/utils/ac_date_time_ext_test.dart`

Тест-кейсы:

- `equalToDay()` возвращает `true` для одинаковых дат с разным временем
- `equalToDay()` возвращает `false` для разных дней
- `equalToDay()` возвращает `true` для идентичных дат
- Граничный случай: сравнение полуночи `00:00` и `23:59` одного дня

### 1.2 `ACDateRange` (`lib/src/domain/src/ac_date_range.dart`)

Файл: `test/domain/ac_date_range_test.dart`

Тест-кейсы:

- `clampDate()` — дата внутри диапазона возвращается без изменений
- `clampDate()` — дата до `min` возвращает `min`
- `clampDate()` — дата после `max` возвращает `max`
- `clampDate()` — дата равна `min` / `max` — возвращается как есть

### 1.3 `ACDateSelectRange` (`lib/src/domain/src/ac_date_select_range.dart`)

Файл: `test/domain/ac_date_select_range_test.dart`

Тест-кейсы:

- Конструктор: передан только `end` → нормализуется в `start`
- Конструктор: `start` без `end` → `end` = null
- Конструктор: `start` и `end` установлены корректно
- `single` — возвращает `start`, если `end` == null
- `single` — возвращает `end`, если `start` == null
- `single` — возвращает `null`, если оба установлены
- `isEmpty` — true при отсутствии обоих
- `copyWith()` — изменяет только указанные поля

### 1.4 `ACTimeSelectRange` (`lib/src/domain/src/ac_time_select_range.dart`)

Файл: `test/domain/ac_time_select_range_test.dart`

Тест-кейсы:

- Аналогичные `ACDateSelectRange`, но с `TimeOfDay`
- Конструктор: нормализация при передаче только `end`
- `single`, `isEmpty`, `copyWith()` — корректное поведение

---

## Фаза 2 — Data-слой (кэш и репозиторий)

### 2.1 `ACCache` (`lib/src/data/src/ac_cache.dart`)

Файл: `test/data/ac_cache_test.dart`

Тест-кейсы:

- `put()` / `get()` — базовое сохранение и получение
- LRU-вытеснение: при достижении `maxSize` удаляется наименее используемый
- `get()` обновляет порядок доступа (элемент не вытесняется после обращения)
- `putIfAbsent()` — не перезаписывает существующее значение
- `putIfAbsent()` — вызывает `ifAbsent` при отсутствии ключа
- `remove()` — удаляет элемент и уменьшает `length`
- `clear()` — очищает всё, `isEmpty` == true
- `containsKey()` — корректная проверка наличия
- Граничный случай: `maxSize` = 1

### 2.2 `ACCalendarRepository` (`lib/src/data/src/ac_calendar_repository.dart`)

Файл: `test/data/ac_calendar_repository_test.dart`

Тест-кейсы:

#### `getMonthDays()`

- Возвращает 42 дня (6 рядов × 7 дней) для стандартного месяца
- Первый день сетки — понедельник (или заданный `weekStart`)
- Содержит дни предыдущего/следующего месяца для заполнения сетки
- Корректная работа для февраля високосного года
- Корректная работа с `weekStart` = воскресенье (DateTime.sunday)

#### `startOfMonth()`

- Возвращает 1-е число текущего месяца
- Время сбрасывается в 00:00

#### `addMonths()`

- Прибавление положительного числа месяцев
- Вычитание (отрицательное число)
- Переход через границу года (декабрь + 1 = январь следующего)

#### `getWeekDays()`

- Возвращает 7 дней
- Первый день соответствует `weekStart`
- По умолчанию начинается с понедельника

#### `getMonths()`

- Возвращает 1–12 для года внутри диапазона
- Обрезает начало/конец по `ACDateRange`

#### `getYears()`

- Возвращает список лет от `min.year` до `max.year`

---

## Фаза 3 — Select Controllers

### 3.1 `ACCalendarSingleSelectController`

Файл: `test/presentation/select_controller/ac_calendar_single_select_controller_test.dart`

Тест-кейсы:

- `selectDay()` — выбор дня устанавливает `selected`
- `selectDay()` — повторный клик по выбранному дню сбрасывает `selected` в `null`
- `selectDay()` — клик по другому дню заменяет выбор
- `selectStateForDay()` — возвращает `ACDaySelectState.single` для выбранного дня
- `selectStateForDay()` — возвращает `null` для невыбранного
- `onChanged` callback вызывается при изменении
- `notifyListeners()` срабатывает при изменении
- Setter `selected` — уведомляет слушателей

### 3.2 `ACCalendarMultiSelectController`

Файл: `test/presentation/select_controller/ac_calendar_multi_select_controller_test.dart`

Тест-кейсы:

- `selectDay()` — добавляет новый день в список
- `selectDay()` — повторный клик удаляет день из списка
- `selected` — список отсортирован по дате
- `selectStateForDay()` — возвращает `ACDaySelectState.multi` для выбранного
- `selectStateForDay()` — возвращает `null` для невыбранного
- `onChanged` вызывается с отсортированным списком
- Setter `selected` — принимает внешний список, сортирует

### 3.3 `ACCalendarRangeSelectController`

Файл: `test/presentation/select_controller/ac_calendar_range_select_controller_test.dart`

Тест-кейсы:

#### Выбор при пустом диапазоне

- Клик → `start` = day, `end` = null

#### Выбор при наличии только `start`

- Клик по `start` → очистка (пустой диапазон)
- Клик после `start` → устанавливает `end`
- Клик до `start` → новый `start`, старый `start` → `end`

#### Выбор при полном диапазоне (start + end)

- Клик по `start` → очистка
- Клик по `end` → очистка
- Клик внутри диапазона ближе к `start` → меняет `start`
- Клик внутри диапазона ближе к `end` → меняет `end`
- Клик за пределами диапазона после `end` → меняет `end`
- Клик за пределами диапазона перед `start` → меняет `start`

#### `selectStateForDay()`

- `startOfRange` — для дня == `start`
- `endOfRange` — для дня == `end`
- `middleInRange` — для дня между `start` и `end`
- `null` — для дня вне диапазона

---

## Фаза 4 — Scroll View Data Source

### 4.1 `ACDefaultScrollViewDataSource`

Файл: `test/presentation/widgets/scroll_view/ac_scroll_view_data_source_test.dart`

Тест-кейсы:

- `initialize()` — предзагружает `preloadCount` элементов до и после
- `currentItem` — возвращает `initialItem` после инициализации
- `currentIndex` — 0 после инициализации
- `setCurrentIndex()` — обновляет `currentItem`
- `loadMore()` — подгружает элементы при достижении `bufferThreshold`
- `shouldBefore` / `shouldAfter` — корректные граничные флаги
- `reachedEndBefore` / `reachedEndAfter` — true когда callback возвращает null
- `loadBefore()` / `loadAfter()` — добавляют по одному элементу
- Отрицательные индексы для `beforeItems`

---

## Фаза 5 — Layout и Input (Flutter-зависимости)

### 5.1 `ACDefaultMonthLayout`

Файл: `test/presentation/widgets/month/ac_month_layout_test.dart`

Тест-кейсы:

- `calculateHeight()` — корректная формула для ширины 350
- `calculateHeight()` — учитывает `mainAxisSpacing` и `crossAxisSpacing`
- `calculateHeight()` — корректна при `childAspectRatio` != 1
- `shouldRelayout()` — `true` при изменении параметров, `false` при одинаковых

### 5.2 `_TimeInputFormatter` (из `ac_time_input_widget.dart`)

Файл: `test/presentation/widgets/time_input/time_input_formatter_test.dart`

> Примечание: `_TimeInputFormatter` — приватный класс. Потребуется либо сделать его публичным/внутренним, либо тестировать через виджет-тесты `ACTimeInputWidget`.

Тест-кейсы (через widget test):

- Ввод "1234" → отображается "12:34"
- Ввод "25" → отклоняется (час > 23)
- Ввод "2400" → отклоняется (час = 24)
- Ввод "1260" → отклоняется (минуты > 59)
- Автоматическая вставка двоеточия
- Удаление символов

---

## Структура файлов тестов

```
test/
├── utils/
│   └── ac_date_time_ext_test.dart
├── domain/
│   ├── ac_date_range_test.dart
│   ├── ac_date_select_range_test.dart
│   └── ac_time_select_range_test.dart
├── data/
│   ├── ac_cache_test.dart
│   └── ac_calendar_repository_test.dart
└── presentation/
    ├── select_controller/
    │   ├── ac_calendar_single_select_controller_test.dart
    │   ├── ac_calendar_multi_select_controller_test.dart
    │   └── ac_calendar_range_select_controller_test.dart
    └── widgets/
        ├── scroll_view/
        │   └── ac_scroll_view_data_source_test.dart
        └── month/
            └── ac_month_layout_test.dart
```

---

## Порядок реализации

| Шаг | Файл теста | Приоритет | Зависимости |
|-----|-----------|-----------|-------------|
| 1   | `ac_date_time_ext_test.dart` | Высокий | Нет |
| 2   | `ac_date_range_test.dart` | Высокий | Нет |
| 3   | `ac_date_select_range_test.dart` | Высокий | Нет |
| 4   | `ac_time_select_range_test.dart` | Высокий | Flutter (TimeOfDay) |
| 5   | `ac_cache_test.dart` | Высокий | Нет |
| 6   | `ac_calendar_repository_test.dart` | Высокий | ACDateRange |
| 7   | `ac_calendar_single_select_controller_test.dart` | Высокий | ACDateTimeExt |
| 8   | `ac_calendar_multi_select_controller_test.dart` | Высокий | ACDateTimeExt |
| 9   | `ac_calendar_range_select_controller_test.dart` | Высокий | ACDateSelectRange, ACDateTimeExt |
| 10  | `ac_scroll_view_data_source_test.dart` | Средний | ChangeNotifier |
| 11  | `ac_month_layout_test.dart` | Средний | Flutter (Size) |

---

## Tasks

- .claude/tasks/01-ac-date-time-ext-test.md
- .claude/tasks/02-ac-date-range-test.md
- .claude/tasks/03-ac-date-select-range-test.md
- .claude/tasks/04-ac-time-select-range-test.md
- .claude/tasks/05-ac-cache-test.md
- .claude/tasks/06-ac-calendar-repository-test.md
- .claude/tasks/07-ac-single-select-controller-test.md
- .claude/tasks/08-ac-multi-select-controller-test.md
- .claude/tasks/09-ac-range-select-controller-test.md
- .claude/tasks/10-ac-scroll-view-data-source-test.md
- .claude/tasks/11-ac-month-layout-test.md

---

## Инструменты

- `flutter test` — запуск всех тестов
- `flutter test test/data/` — запуск тестов конкретной папки
- `flutter test --coverage` — генерация отчёта покрытия
