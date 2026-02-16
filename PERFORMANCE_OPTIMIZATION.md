# Оптимизация производительности ACCalendarWidget

## Проблемы с производительностью

### 🔴 Критические проблемы

#### 4. Полное перестроение при изменении выбора
**Файл:** `ac_calendar_widget.dart:61`

**Проблема:** `_selectControllerListener() => setState(() {})` перестраивает весь календарь включая:
- LayoutBuilder
- Все видимые месяцы
- Все GridView внутри месяцев
- Все 30+ дней в каждом месяце

**Влияние:** При выборе даты перестраивается вся иерархия виджетов

#### 5. GridView с shrinkWrap внутри SliverList
**Файл:** `ac_month_widget.dart:41-46`

**Проблема:** `GridView.builder` с `shrinkWrap: true` и `NeverScrollableScrollPhysics` внутри прокручиваемого списка

**Влияние:** Flutter должен вычислить высоту GridView до рендеринга, что дорого

#### 6. Отсутствие изоляции перерисовок
**Проблема:** Нет `RepaintBoundary` между месяцами

**Влияние:** Изменение в одном месяце может вызвать перерисовку соседних

---

## ✅ Решения

### Приоритет 1: Кэширование вычислений дней и layout

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

Для измерения эффекта оптимизаций используйте:

```dart
// Включить Performance Overlay
void main() {
  runApp(
    MaterialApp(
      showPerformanceOverlay: true,
      // ...
    ),
  );
}

// Профилирование в Flutter DevTools
// 1. Запустить flutter run --profile
// 2. Открыть Flutter DevTools
// 3. Перейти в Performance tab
// 4. Записать профиль до и после оптимизаций
```

**Метрики для отслеживания:**
- Frame rendering time (должно быть < 16ms для 60 FPS)
- Количество rebuilds при прокрутке
- Количество rebuilds при выборе даты
- Использование памяти

---

## 📝 Дополнительные рекомендации

### Если тормоза остаются:

1. **Lazy loading месяцев** - загружать только видимые ±1 месяц
2. **Пул объектов для ACDayWidget** - переиспользовать виджеты дней
3. **Кэширование render objects** - сохранять RenderObject между rebuilds
4. **Оптимизация DefaultMonthChildDelegate.buildDay** - кэшировать результаты getBackgroundColor, getTextColor, getTextStyle
5. **Рассмотреть использование RenderBox вместо Widget** для критичных частей

### Инструменты для профилирования:

```bash
# Профилирование build
flutter run --profile --trace-skia

# Анализ производительности
flutter analyze --watch

# Проверка переусложнения виджетов
flutter run --profile --trace-widget-builds
```
