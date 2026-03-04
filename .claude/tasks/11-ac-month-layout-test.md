# Задача 11: Тесты для ACDefaultMonthLayout

**Приоритет:** Средний
**Зависимости:** Flutter (Size)
**Исходный файл:** `lib/src/presentation/src/widgets/src/month/src/ac_month_layout.dart`
**Тестовый файл:** `test/presentation/widgets/month/ac_month_layout_test.dart`

## Тест-кейсы

- `calculateHeight()` — корректная формула для ширины 350
- `calculateHeight()` — учитывает `mainAxisSpacing` и `crossAxisSpacing`
- `calculateHeight()` — корректна при `childAspectRatio` != 1
- `shouldRelayout()` — `true` при изменении параметров, `false` при одинаковых

## Указания

- Использовать `package:flutter_test`
- Формула: height = mainAxisCount * cellHeight + (mainAxisCount - 1) * mainAxisSpacing
- Где cellHeight = cellWidth / childAspectRatio
- Проверить статические пресеты: `mainAxisCount4`, `mainAxisCount5`, `mainAxisCount6`
