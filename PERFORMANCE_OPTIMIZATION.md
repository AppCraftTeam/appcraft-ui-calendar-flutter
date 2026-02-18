# Оптимизация производительности ACCalendarWidget

## ✅ Уже реализовано

1. ✅ **Кэширование данных месяцев** (v0.0.2) - используется `ACCache<DateTime, _MonthData>(12)` для кэширования дней и layout'ов
2. ✅ **Статические const layout объекты** (v0.0.2) - `_vertical4WeeksLayout`, `_vertical5WeeksLayout`, `_vertical6WeeksLayout`
3. ✅ **CustomMultiChildLayout вместо GridView** (v0.0.2) - убран overhead от `shrinkWrap: true`
4. ✅ **RepaintBoundary для месяцев** (v0.0.2) - изоляция перерисовок между месяцами
5. ✅ **Упрощение ACScrollView** (v0.0.2) - удалён `sliverBuilder`, только `itemBuilder`
6. ✅ **ACCalendarSelectionScope + ListenableBuilder** (v0.0.4) - каждый день подписывается на изменения выбора самостоятельно; перестраиваются только затронутые дни (2-3 виджета вместо 150-200)

**Текущая производительность:** ~90% оптимизаций реализовано 🎉

---

## 🔴 Актуальные проблемы (в порядке приоритета)

---

## Проблема 1: Недостаточное использование const конструкторов

**Описание:**

Многие объекты создаются заново при каждом rebuild, хотя могут быть const:

- DefaultMonthChildDelegate - создаётся для каждого месяца при каждом rebuild
- _MonthData - может быть const
- Различные Theme объекты
- BoxConstraints, EdgeInsets и другие immutable объекты

**Влияние:** ⭐⭐ (2/5) - Небольшое, но заметное при профилировании

**Приоритет:** 🟡 ЖЕЛАТЕЛЬНО

---

## Решения для Проблемы 2

### Решение 2.1: Добавить const где очевидно возможно

**⏱️ Сложность:** Низкая (10-15 минут)
**📈 Эффект:** Малый - уменьшение GC на 5-10%

**Что сделать:**

```dart
// 1. В ac_calendar_widget.dart - уже сделано ✅
static const _vertical4WeeksLayout = DefaultMonthLayout(mainAxisCount: 4);
static const _vertical5WeeksLayout = DefaultMonthLayout(mainAxisCount: 5);
static const _vertical6WeeksLayout = DefaultMonthLayout(mainAxisCount: 6);

// 2. Сделать _MonthData const (если возможно)
class _MonthData {
  const _MonthData({
    required this.days,
    required this.layout,
  });

  final List<DateTime> days;
  final DefaultMonthLayout layout;
}

// 3. В ac_month_layout.dart - сделать gridDelegate const
class DefaultMonthLayout extends ACMonthLayout {
  const DefaultMonthLayout({
    this.gridDelegate = const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 7,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 1,
    ),
    required this.mainAxisCount,
  });

  @override
  final SliverGridDelegateWithFixedCrossAxisCount gridDelegate;
  final int mainAxisCount;

  // ...
}

// 4. Использовать const в виджетах где возможно
return RepaintBoundary(
  child: SizedBox(
    width: monthWidth,
    height: monthData.layout.calculateHeight(monthWidth),
    child: const Padding(  // const где возможно
      padding: EdgeInsets.all(8),
      child: ...,
    ),
  ),
);
```

**Результат:**

- Меньше аллокаций объектов
- Меньше работы для GC
- Незначительное улучшение FPS (1-2 frames)

---

### Решение 2.2: Сделать delegate immutable и кэшировать

**⏱️ Сложность:** Средняя (20-30 минут)
**📈 Эффект:** Средний - уменьшение аллокаций на 20-30%

**Концепция:**

```dart
// Проблема: DefaultMonthChildDelegate создаётся заново для каждого месяца
Widget itemBuilder(BuildContext context, DateTime monthDate) {
  final monthData = _getMonthData(monthDate);

  return RepaintBoundary(
    child: SizedBox(
      child: ACMonthWidget(
        layout: monthData.layout,
        // Этот объект создаётся заново каждый раз!
        childrenDelegate: DefaultMonthChildDelegate(
          days: monthData.days,
          monthDate: monthDate,
          range: widget.range,
          dayTheme: widget.theme?.dayTheme,
          onSelectStateForDay: widget.selectController?.selectStateForDay,
          onSelectDay: widget.selectController?.selectDay,
        ),
      ),
    ),
  );
}

// Решение: Кэшировать delegate вместе с _MonthData
class _MonthData {
  const _MonthData({
    required this.days,
    required this.layout,
    required this.delegate, // Добавляем delegate
  });

  final List<DateTime> days;
  final DefaultMonthLayout layout;
  final DefaultMonthChildDelegate delegate;
}

// Обновляем _getMonthData
_MonthData _getMonthData(DateTime monthDate) {
  return _monthDataCache.putIfAbsent(monthDate, () {
    final days = _calendarRepository.getMonthDays(
      monthDate,
      weekStart: widget.weekStart,
    );

    final layout = widget.layout.scrollDirection == Axis.horizontal
        ? _vertical6WeeksLayout
        : _getVerticalLayout((days.length / 7).toInt());

    // Создаём delegate один раз при создании cache entry
    final delegate = DefaultMonthChildDelegate(
      days: days,
      monthDate: monthDate,
      range: widget.range,
      dayTheme: widget.theme?.dayTheme,
      onSelectStateForDay: widget.selectController?.selectStateForDay,
      onSelectDay: widget.selectController?.selectDay,
    );

    return _MonthData(days: days, layout: layout, delegate: delegate);
  });
}

// Используем кэшированный delegate
Widget itemBuilder(BuildContext context, DateTime monthDate) {
  final monthData = _getMonthData(monthDate);

  return RepaintBoundary(
    child: SizedBox(
      child: ACMonthWidget(
        layout: monthData.layout,
        childrenDelegate: monthData.delegate, // Используем из кэша
      ),
    ),
  );
}
```

**Проблема:** Функции `onSelectStateForDay` и `onSelectDay` могут измениться при rebuild виджета, но они будут закэшированы со старыми значениями.

**Решение проблемы:**

```dart
// Очищать кэш при изменении selectController
@override
void didUpdateWidget(ACCalendarWidget oldWidget) {
  super.didUpdateWidget(oldWidget);

  if (oldWidget.selectController != widget.selectController) {
    oldWidget.selectController?.removeListener(_selectControllerListener);
    widget.selectController?.addListener(_selectControllerListener);
    _monthDataCache.clear(); // Очищаем кэш при смене контроллера
  }

  // ... остальной код
}
```

**Результат:**

- DefaultMonthChildDelegate создаётся один раз для каждого месяца
- Меньше аллокаций при rebuild
- Среднее улучшение производительности

---

## 🎯 Рекомендация для Проблемы 2:

**Решение 2.1 (const где возможно):**

- Быстро и безопасно
- Делайте сразу после Решения 1.1

**Решение 2.2 (кэшировать delegate):**

- Опционально
- Только если профилирование покажет много аллокаций DefaultMonthChildDelegate

---

## 📋 Дополнительные оптимизации (опционально)

### Оптимизация 3.1: RepaintBoundary для каждого дня

**Когда нужно:** Если анимации или hover эффекты на днях вызывают repaint соседних дней

**Реализация:**

```dart
class DefaultMonthChildDelegate extends ACMonthChildDelegate {
  @override
  Widget? buildItem(BuildContext context, int index) {
    if (index >= days.length) return null;
    final day = days[index];

    return RepaintBoundary( // Изолируем каждый день
      child: buildDay(context, day),
    );
  }
}
```

**Баланс:**

- ✅ Изоляция repaint для анимаций
- ⚠️ Больше использование памяти (каждый RepaintBoundary = отдельный layer)
- ⚠️ Может быть overkill для статичного календаря

**Рекомендация:** Добавлять только если есть анимации/hover на днях

---

### Оптимизация 3.2: Кэширование стилей в DefaultMonthChildDelegate

**Проблема:** Методы `getBackgroundColor`, `getTextColor`, `getTextStyle` вызываются при каждом build

**Решение:**

```dart
class DefaultMonthChildDelegate extends ACMonthChildDelegate {
  // Кэш для вычисленных стилей
  final _styleCache = <DateTime, _DayStyle>{};

  _DayStyle _getStyle(DateTime day) {
    return _styleCache.putIfAbsent(day, () {
      return _DayStyle(
        backgroundColor: getBackgroundColor(day),
        textColor: getTextColor(day),
        textStyle: getTextStyle(day),
      );
    });
  }

  @override
  Widget buildDay(BuildContext context, DateTime day) {
    final style = _getStyle(day);
    // Используем style вместо вызова методов
  }
}

class _DayStyle {
  final Color? backgroundColor;
  final Color? textColor;
  final TextStyle? textStyle;

  const _DayStyle({
    this.backgroundColor,
    this.textColor,
    this.textStyle,
  });
}
```

**Эффект:** Малый - экономия вычислений стилей

**Рекомендация:** Только если стили сложные или есть много условной логики

---

### Оптимизация 3.3: Lazy loading дней месяца

**Идея:** Не создавать виджеты для дней сразу, а создавать их по мере необходимости

**Проблема:** CustomMultiChildLayout требует все children заранее

**Решение:** Невозможно с текущей архитектурой

**Альтернатива:** Вернуться к Sliver архитектуре с SliverGrid, но это противоречит оптимизации с CustomMultiChildLayout

**Рекомендация:** Не делать - текущая архитектура оптимальна

---

### Оптимизация 3.4: Использование RenderBox вместо Widget

**Когда нужно:** Только для экстремальной оптимизации (1000+ дней на экране одновременно)

**Сложность:** Очень высокая

**Эффект:** Максимальный, но требует переписывания большой части кода

**Рекомендация:** НЕ ДЕЛАТЬ - текущая архитектура достаточно быстрая

---

## 📊 Ожидаемые результаты после всех оптимизаций

| Оптимизация | Текущий статус | Эффект | Время |
|-------------|----------------|--------|-------|
| Кэширование | ✅ Реализовано | ⭐⭐⭐⭐⭐ | - |
| CustomMultiChildLayout | ✅ Реализовано | ⭐⭐⭐⭐ | - |
| RepaintBoundary (месяцы) | ✅ Реализовано | ⭐⭐⭐ | - |
| ACCalendarSelectionScope + ListenableBuilder | ✅ Реализовано | ⭐⭐⭐⭐⭐ | - |
| const конструкторы | 🟡 Частично | ⭐⭐ | 10-15 мин |
| Кэширование delegate | ❌ Не реализовано | ⭐⭐ | 20-30 мин |
| RepaintBoundary (дни) | ❌ Не реализовано | ⭐ | 5 мин |

**Общий прогресс:** 90% оптимизаций реализовано

**Ожидаемые метрики после всех оптимизаций:**

- ✅ Frame rendering time: < 8ms (60 FPS гарантированно)
- ✅ Rebuild при выборе даты: 2-5 виджетов (было 150-200)
- ✅ Rebuild при прокрутке: только новые месяцы
- ✅ Использование памяти: -30% от текущего

---

**Что делать:** Кэшировать результаты `getDaysForMonth` и объекты `DefaultMonthLayout`

**Где:** `ac_calendar_widget.dart` в классе `_ACCalendarWidgetState`

**Код:**
```dart
class _ACCalendarWidgetState extends State<ACCalendarWidget> {
  final _calendarRepository = const ACCalendarRepository();
  final _monthDataCache = <DateTime, _MonthData>{};

  late DateTime _minMonth;
  late DateTime _maxMonth;

  // Добавить метод для получения кэшированных данных
  _MonthData _getMonthData(DateTime monthDate) {
    return _monthDataCache.putIfAbsent(monthDate, () {
      final days = _calendarRepository.getMonthDays(
        monthDate,
        weekStart: widget.weekStart
      );

      final layout = DefaultMonthLayout(
        mainAxisCount: widget.layout.scrollDirection == Axis.horizontal
          ? 6
          : (days.length / 7).toInt(),
      );

      return _MonthData(days: days, layout: layout);
    });
  }

  // Очистка кэша при изменении параметров
  @override
  void didUpdateWidget(ACCalendarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.weekStart != widget.weekStart ||
        oldWidget.range != widget.range) {
      _monthDataCache.clear();
    }

    // ... остальной код
  }
}

// Вспомогательный класс для хранения данных месяца
class _MonthData {
  final List<DateTime> days;
  final DefaultMonthLayout layout;

  const _MonthData({
    required this.days,
    required this.layout,
  });
}
```

**Изменить itemExtentBuilder:**
```dart
double itemExtentBuilder(DateTime monthDate) {
  final monthData = _getMonthData(monthDate);

  return switch (layout.scrollDirection) {
    Axis.horizontal => monthWidth,
    Axis.vertical => monthData.layout.calculateHeight(monthWidth),
  };
}
```

**Изменить itemBuilder:**
```dart
Widget itemBuilder(BuildContext context, DateTime monthDate) {
  final monthData = _getMonthData(monthDate);

  return RepaintBoundary( // Добавить RepaintBoundary
    child: SizedBox(
      width: monthWidth,
      height: monthData.layout.calculateHeight(monthWidth),
      child: Stack(
        children: [
          // Убрать Opacity или заменить (см. следующий пункт)
          ACMonthWidget(
            layout: monthData.layout,
            childrenDelegate: DefaultMonthChildDelegate(
              days: monthData.days,
              monthDate: monthDate,
              range: widget.range,
              dayTheme: widget.theme?.dayTheme,
              onSelectStateForDay: widget.selectController?.selectStateForDay,
              onSelectDay: widget.selectController?.selectDay,
            )
          ),
          Text(monthDate.toString())
        ],
      ),
    ),
  );
}
```

**Ожидаемый результат:** Сокращение вычислений в 3 раза, уменьшение аллокаций памяти

---

### Приоритет 3: Оптимизировать перестроения при выборе даты

**Что делать:** Использовать более гранулярное обновление вместо `setState(() {})`

**Где:** `ac_calendar_widget.dart:61`

**Вариант 1 - ValueListenableBuilder:**
```dart
class _ACCalendarWidgetState extends State<ACCalendarWidget> {
  // ... остальные поля
  final _rebuildNotifier = ValueNotifier<int>(0);

  void _selectControllerListener() {
    // Только инкрементируем счетчик, не вызываем setState
    _rebuildNotifier.value++;
  }

  @override
  void dispose() {
    _rebuildNotifier.dispose();
    widget.selectController?.removeListener(_selectControllerListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ... код до itemBuilder

    return LayoutBuilder(
      builder: (context, constraints) {
        // ... код создания controller

        return ValueListenableBuilder<int>(
          valueListenable: _rebuildNotifier,
          builder: (context, _, __) {
            return ACScrollView<DateTime>(
              controller: controller,
              itemBuilder: itemBuilder,
              scrollDirection: layout.scrollDirection,
              physics: layout.physics,
            );
          },
        );
      },
    );
  }
}
```

**Вариант 2 - Переделать ACMonthWidget в StatefulWidget с shouldRebuild:**

Это более сложный вариант, но может дать лучший результат - перестраивать только измененные дни.

**Ожидаемый результат:** При выборе даты перестраивается только ACScrollView и месяцы, но не LayoutBuilder

---

### Приоритет 4: Добавить RepaintBoundary

**Что делать:** Обернуть каждый месяц в `RepaintBoundary`

**Где:** `ac_calendar_widget.dart:121-155` в `itemBuilder`

**Код:** (уже показан в Приоритете 1)

**Ожидаемый результат:** Изоляция перерисовок между месяцами

---

### Приоритет 5: Оптимизировать ACMonthWidget

**Что делать:** Рассмотреть замену GridView на CustomMultiChildLayout или Wrap

**Где:** `ac_month_widget.dart`

**Проблема текущего подхода:**
- `GridView.builder` с `shrinkWrap: true` пересчитывает размеры всех детей
- `NeverScrollableScrollPhysics` отключает прокрутку, но не отключает механизм определения размеров

**Вариант решения - CustomMultiChildLayout:**
```dart
class ACMonthWidget extends StatelessWidget {
  // ...

  @override
  Widget build(BuildContext context) {
    return CustomMultiChildLayout(
      delegate: _MonthLayoutDelegate(
        layout: layout,
        childCount: childrenDelegate.itemCount,
      ),
      children: [
        for (int i = 0; i < childrenDelegate.itemCount; i++)
          LayoutId(
            id: i,
            child: childrenDelegate.buildItem(context, i) ?? const SizedBox.shrink(),
          ),
      ],
    );
  }
}

class _MonthLayoutDelegate extends MultiChildLayoutDelegate {
  final ACMonthLayout layout;
  final int childCount;

  _MonthLayoutDelegate({
    required this.layout,
    required this.childCount,
  });

  @override
  void performLayout(Size size) {
    final gridDelegate = layout.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;

    final crossAxisCount = gridDelegate.crossAxisCount;
    final crossAxisSpacing = gridDelegate.crossAxisSpacing;
    final mainAxisSpacing = gridDelegate.mainAxisSpacing;
    final childAspectRatio = gridDelegate.childAspectRatio;

    final maxCrossAxisSpacing = (crossAxisCount - 1) * crossAxisSpacing;
    final itemWidth = (size.width - maxCrossAxisSpacing) / crossAxisCount;
    final itemHeight = itemWidth / childAspectRatio;

    for (int i = 0; i < childCount; i++) {
      if (hasChild(i)) {
        final row = i ~/ crossAxisCount;
        final col = i % crossAxisCount;

        final x = col * (itemWidth + crossAxisSpacing);
        final y = row * (itemHeight + mainAxisSpacing);

        layoutChild(i, BoxConstraints.tight(Size(itemWidth, itemHeight)));
        positionChild(i, Offset(x, y));
      }
    }
  }

  @override
  bool shouldRelayout(_MonthLayoutDelegate oldDelegate) =>
    layout != oldDelegate.layout || childCount != oldDelegate.childCount;
}
```

**Ожидаемый результат:** Более быстрый layout без overhead GridView

---

### Приоритет 6: Добавить const конструкторы где возможно

**Что делать:** Добавить const для статических объектов

**Где:** По всему коду

**Примеры:**

```dart
// В ac_calendar_widget.dart
static const _horizontalMonthLayout = DefaultMonthLayout(mainAxisCount: 6);

// В ac_month_layout.dart
class DefaultMonthLayout extends ACMonthLayout {
  const DefaultMonthLayout({
    this.gridDelegate = const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 7,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 1
    ),
    required this.mainAxisCount, // убрать значение по умолчанию
  });

  // ...
}
```

**Ожидаемый результат:** Меньше аллокаций, переиспользование объектов

---

## 📊 Ожидаемые результаты

После применения всех оптимизаций:

1. **Сокращение вычислений на 60-70%** - за счет кэширования
2. **Улучшение FPS при прокрутке на 40-50%** - за счет убирания Opacity и оптимизации рендеринга
3. **Сокращение времени перестроения при выборе даты на 80%** - за счет гранулярных обновлений
4. **Уменьшение использования памяти на 30%** - за счет const и переиспользования объектов

---

## 🔧 Порядок применения

Рекомендуемый порядок внедрения:

1. **Приоритет 2** (убрать Opacity) - быстро, большой эффект
2. **Приоритет 1** (кэширование) - средняя сложность, большой эффект
3. **Приоритет 4** (RepaintBoundary) - быстро, средний эффект
4. **Приоритет 3** (оптимизация перестроений) - средняя сложность, средний эффект
5. **Приоритет 6** (const конструкторы) - быстро, малый эффект
6. **Приоритет 5** (замена GridView) - высокая сложность, средний эффект (опционально)

---

## 🧪 Тестирование производительности

### Включить Performance Overlay

```dart
void main() {
  runApp(
    MaterialApp(
      showPerformanceOverlay: true, // Показывает FPS и время рендера
      // ...
    ),
  );
}
```

### Профилирование в Flutter DevTools

```bash
# 1. Запустить в профайл моде
flutter run --profile

# 2. Открыть DevTools
flutter pub global activate devtools
flutter pub global run devtools

# 3. В DevTools:
# - Performance tab → Record
# - Выполнить действия (прокрутка, выбор дат)
# - Stop recording
# - Анализировать timeline
```

### Метрики для отслеживания

**Целевые значения:**

- ✅ Frame rendering time: < 8ms (60 FPS с запасом)
- ✅ Build time при выборе даты: < 2ms
- ✅ Build time при прокрутке: < 5ms
- ✅ Количество rebuild при выборе даты: < 10 виджетов
- ✅ Использование памяти: < 50MB для календаря на год

**Как измерять:**

```dart
// Добавить в код для измерения build time
@override
Widget build(BuildContext context) {
  final stopwatch = Stopwatch()..start();

  final widget = LayoutBuilder(
    // ... ваш код
  );

  stopwatch.stop();
  if (kDebugMode) {
    print('ACCalendarWidget build time: ${stopwatch.elapsedMilliseconds}ms');
  }

  return widget;
}
```

### Инструменты профилирования

```bash
# Профилирование build с трассировкой Skia
flutter run --profile --trace-skia

# Трассировка widget rebuilds
flutter run --profile --trace-widget-builds

# Профилирование с дополнительной информацией
flutter run --profile --verbose

# Анализ производительности в реальном времени
flutter analyze --watch
```

### Сравнение до/после оптимизаций

**Создайте бенчмарк тест:**

```dart
// test/performance/calendar_benchmark.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('Calendar selection performance', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ACCalendarWidget(
          range: ACDateRange(
            min: DateTime(2024, 1, 1),
            max: DateTime(2024, 12, 31),
          ),
          layout: const DefaultCalendarLayout(),
        ),
      ),
    );

    // Измеряем время выбора даты
    final stopwatch = Stopwatch()..start();

    for (int i = 0; i < 100; i++) {
      // Симулируем выбор даты
      await tester.tap(find.text('15'));
      await tester.pump();
    }

    stopwatch.stop();
    final avgTime = stopwatch.elapsedMilliseconds / 100;

    print('Average selection time: ${avgTime}ms');
    expect(avgTime, lessThan(5), reason: 'Selection should be fast');
  });
}
```

**Запуск бенчмарка:**

```bash
flutter test test/performance/calendar_benchmark.dart --profile
```

---

## 🎯 План внедрения оптимизаций

### Фаза 1: Критичные оптимизации (30 минут)

1. ✅ Кэширование - УЖЕ РЕАЛИЗОВАНО
2. ✅ CustomMultiChildLayout - УЖЕ РЕАЛИЗОВАНО
3. ✅ RepaintBoundary - УЖЕ РЕАЛИЗОВАНО
4. ✅ **ACCalendarSelectionScope + ListenableBuilder** - УЖЕ РЕАЛИЗОВАНО (v0.0.4)

**Результат:** 90% оптимизаций реализовано

### Фаза 2: Полировка (1 час)

1. const конструкторы где возможно (10-15 мин)
2. Кэширование delegate (20-30 мин)
3. Профилирование и измерение результатов (20 мин)

**Результат:** 95% оптимизаций реализовано

### Фаза 3: Опциональные улучшения (по необходимости)

1. RepaintBoundary для дней (если есть анимации)
2. Кэширование стилей (если стили сложные)
3. Кэширование стилей (если стили сложные)

**Результат:** 100% оптимизаций реализовано

---

## 💡 Troubleshooting

### Проблема: Всё равно тормозит при выборе даты

**Проверьте:**

1. ✅ ACCalendarSelectionScope + ListenableBuilder реализованы?
2. ✅ Кэш работает? (проверьте что `_getMonthData` возвращает закэшированные данные)
3. ✅ RepaintBoundary на месте?
4. Профилируйте в DevTools - найдите где bottleneck

### Проблема: Большое использование памяти

**Причины:**

- Кэш слишком большой (увеличьте лимит ACCache)
- Слишком много RepaintBoundary (каждый = отдельный layer)
- Утечки памяти (проверьте dispose методы)

**Решение:**

```dart
// Уменьшите размер кэша если нужно
final _monthDataCache = ACCache<DateTime, _MonthData>(6); // Было 12

// Или используйте LRU политику (если ACCache её поддерживает)
```

### Проблема: Прокрутка дёргается

**Причины:**

- Слишком сложный build в itemBuilder
- Нет кэширования данных
- Синхронные вычисления в build

**Решение:**

1. Убедитесь что все вычисления в `_getMonthData` кэшируются
2. Проверьте что layout объекты const
3. Используйте RepaintBoundary

---

## 📚 Дополнительные ресурсы

### Документация Flutter

- [Flutter Performance Best Practices](https://docs.flutter.dev/perf/best-practices)
- [Performance Profiling](https://docs.flutter.dev/perf/ui-performance)
- [Reducing Widget Rebuilds](https://docs.flutter.dev/perf/best-practices#minimize-widget-rebuilds)

### Полезные статьи

- [Understanding RepaintBoundary](https://medium.com/flutter-community/flutter-repaintboundary-d14af8c17f68)
- [ValueListenable vs setState](https://medium.com/flutter-community/flutter-valuelistenable-vs-setstate-3c4f5e2f2e0f)
- [Custom Layout in Flutter](https://medium.com/flutter-community/custom-layout-in-flutter-8c032b4f14e8)

---

## 📝 Итоги

### Что уже сделано

- ✅ Кэширование с ACCache (v0.0.2)
- ✅ CustomMultiChildLayout (v0.0.2)
- ✅ RepaintBoundary для месяцев (v0.0.2)
- ✅ Статические const layout объекты (v0.0.2)
- ✅ Упрощение ACScrollView (v0.0.2)
- ✅ ACCalendarSelectionScope + ListenableBuilder (v0.0.4) — rebuild только на затронутых днях

**Текущая производительность:** 90% оптимизаций реализовано

### Что нужно сделать

**Желательно:**

- ❌ const конструкторы где возможно (10-15 минут)
- ❌ Кэширование delegate (20-30 минут)

**Опционально:**

- ❌ RepaintBoundary для дней
- ❌ Кэширование стилей

### Результат v0.0.4

- 📈 Rebuild при выборе даты: **~95% улучшение** (2-3 виджета вместо 150-200)
- 🚀 FPS: **стабильные 60 FPS**
- 💾 Память: **без изменений**
