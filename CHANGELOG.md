# appcraft_ui_calendar_flutter

<!--
Шаблон для будущих версий CHANGELOG.md:
## <version>

- Краткое описание изменений (императивный стиль, настоящее время).
- Список ключевых изменений:
  - Что добавлено.
  - Что изменено.
  - Что исправлено.
  - Что удалено или устарело.
- Каждое изменение — отдельный пункт, без лишних деталей реализации.
-->

## 0.0.2

- Оптимизация производительности `ACMonthWidget`:
  - Заменена реализация с `GridView.builder` (shrinkWrap: true) на `CustomMultiChildLayout`.
  - Устранён overhead при вычислении размеров GridView внутри прокручиваемого списка.
  - Добавлен deprecated параметр `useGridView` для обратной совместимости.

- Рефакторинг архитектуры отображения календаря:
  - `ACCalendarWidget` теперь использует `ACMonthWidget` с новой оптимизированной реализацией.
  - Переход с `sliverBuilder` на `itemBuilder` в `ACScrollView`.
  - Удалён `sliverBuilder` из `ACScrollView` - упрощение API и уменьшение сложности кода.
  - Каждый месяц обёрнут в `RepaintBoundary` для изоляции перерисовок.

- Рефакторинг `ACMonthLayout`:
  - `ACMonthLayout` теперь напрямую наследует `MultiChildLayoutDelegate`.
  - Удалён геттер `gridDelegate` - параметры сетки теперь являются полями класса.
  - Удалён промежуточный `_ACMonthLayoutDelegate` - упрощение архитектуры.
  - `DefaultMonthLayout` теперь имеет явные поля для настройки сетки: `crossAxisCount`, `crossAxisSpacing`, `mainAxisSpacing`, `childAspectRatio`.

## 0.0.1

- Начальная версия.
