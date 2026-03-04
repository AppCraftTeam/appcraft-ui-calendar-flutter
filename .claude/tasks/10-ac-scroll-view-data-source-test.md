# Задача 10: Тесты для ACDefaultScrollViewDataSource

**Приоритет:** Средний
**Зависимости:** ChangeNotifier
**Исходный файл:** `lib/src/presentation/src/widgets/src/scroll_view/src/ac_scroll_view_data_source.dart`
**Тестовый файл:** `test/presentation/widgets/scroll_view/ac_scroll_view_data_source_test.dart`

## Тест-кейсы

- `initialize()` — предзагружает `preloadCount` элементов до и после
- `currentItem` — возвращает `initialItem` после инициализации
- `currentIndex` — 0 после инициализации
- `setCurrentIndex()` — обновляет `currentItem`
- `loadMore()` — подгружает элементы при достижении `bufferThreshold`
- `shouldBefore` / `shouldAfter` — корректные граничные флаги
- `reachedEndBefore` / `reachedEndAfter` — true когда callback возвращает null
- `loadBefore()` / `loadAfter()` — добавляют по одному элементу
- Отрицательные индексы для `beforeItems`

## Указания

- Использовать `package:flutter_test` (ChangeNotifier)
- Создать простые `onBefore`/`onAfter` callbacks с числовой последовательностью
- Проверить корректность индексации: отрицательные для before, неотрицательные для after
