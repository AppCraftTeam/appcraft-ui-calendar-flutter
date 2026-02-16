import 'package:flutter/material.dart';

import '../../../../../../data/data.dart';
import '../../../../../../domain/domain.dart';
import '../../../../../presentation.dart';

/// Кэшированные данные месяца
class _MonthData {
  const _MonthData({
    required this.days,
    required this.layout,
  });

  final List<DateTime> days;
  final DefaultMonthLayout layout;
}

class ACCalendarWidget extends StatefulWidget {
  const ACCalendarWidget({
    required this.range,
    required this.layout,
    this.weekStart,
    this.locale,
    this.theme,
    this.selectController,
    this.initialDate,
    super.key,
  });

  final ACDateRange range;
  final ACCalendarLayout layout;
  final int? weekStart;
  final String? locale;
  final ACCalendarThemeData? theme;
  final ACCalendarSelectController? selectController;
  final DateTime? initialDate;

  @override
  State<ACCalendarWidget> createState() => _ACCalendarWidgetState();
}

class _ACCalendarWidgetState extends State<ACCalendarWidget> {
  final _calendarRepository = const ACCalendarRepository();
  final _monthDataCache = LRUCache<DateTime, _MonthData>(12); // Кэшируем до 12 месяцев

  late DateTime _minMonth;
  late DateTime _maxMonth;

  // Статические layout объекты для переиспользования (избегаем аллокаций)
  static const _vertical4WeeksLayout = DefaultMonthLayout(mainAxisCount: 4);
  static const _vertical5WeeksLayout = DefaultMonthLayout(mainAxisCount: 5);
  static const _vertical6WeeksLayout = DefaultMonthLayout(mainAxisCount: 6);

  @override
  void initState() {
    super.initState();
    _minMonth = _calendarRepository.startOfMonth(widget.range.min);
    _maxMonth = _calendarRepository.startOfMonth(widget.range.max);
    widget.selectController?.addListener(_selectControllerListener);
  }

  /// Выбирает оптимальный layout для заданного количества недель
  /// Возвращает const объект для частых случаев (4-6 недель)
  DefaultMonthLayout _getVerticalLayout(int weeksCount) {
    return switch (weeksCount) {
      4 => _vertical4WeeksLayout,
      5 => _vertical5WeeksLayout,
      6 => _vertical6WeeksLayout,
      _ => DefaultMonthLayout(mainAxisCount: weeksCount), // Fallback для редких случаев
    };
  }

  /// Получает кэшированные данные месяца или вычисляет их
  _MonthData _getMonthData(DateTime monthDate) {
    return _monthDataCache.putIfAbsent(monthDate, () {
      final days = _calendarRepository.getMonthDays(
        monthDate,
        weekStart: widget.weekStart,
      );

      final layout = widget.layout.scrollDirection == Axis.horizontal
          ? _vertical6WeeksLayout
          : _getVerticalLayout((days.length / 7).toInt());

      return _MonthData(days: days, layout: layout);
    });
  }

  @override
  void didUpdateWidget(ACCalendarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectController != widget.selectController) {
      oldWidget.selectController?.removeListener(_selectControllerListener);
      widget.selectController?.addListener(_selectControllerListener);
    }

    // Очищаем кэш при изменении параметров, влияющих на данные месяца
    if (oldWidget.weekStart != widget.weekStart ||
        oldWidget.layout.scrollDirection != widget.layout.scrollDirection) {
      _monthDataCache.clear();
    }

    if (oldWidget.range != widget.range) {
      setState(() {
        _minMonth = _calendarRepository.startOfMonth(widget.range.min);
        _maxMonth = _calendarRepository.startOfMonth(widget.range.max);
        _monthDataCache.clear(); // Очищаем кэш при изменении range
      });
    }
  }

  void _selectControllerListener() => setState(() {});

  @override
  void dispose() {
    widget.selectController?.removeListener(_selectControllerListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final initialMonth = _calendarRepository.startOfMonth(
      widget.initialDate ?? DateTime.now()
    );

    // Убедимся, что начальный месяц в пределах range
    final clampedInitialMonth = initialMonth.isBefore(_minMonth) ?
      _minMonth
      : (
        initialMonth.isAfter(_maxMonth) ?
          _maxMonth :
          initialMonth
      );

    /// Получает предыдущий месяц (если не вышли за границы range)
    DateTime? getPreviousMonth(DateTime current) {
      final previous = _calendarRepository.addMonths(current, -1);
      if (previous.isBefore(_minMonth)) return null;
      return previous;
    }

    /// Получает следующий месяц (если не вышли за границы range)
    DateTime? getNextMonth(DateTime current) {
      final next = _calendarRepository.addMonths(current, 1);
      if (next.isAfter(_maxMonth)) return null;
      return next;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final layout = widget.layout;
        final monthWidth = constraints.maxWidth;

        double itemExtentBuilder(DateTime monthDate) {
          switch (layout.scrollDirection) {
            case Axis.horizontal:
              return monthWidth;
            case Axis.vertical:
              final monthData = _getMonthData(monthDate);
              return monthData.layout.calculateHeight(monthWidth);
          }
        }

        Widget itemBuilder(BuildContext context, DateTime monthDate) {
          final monthData = _getMonthData(monthDate);

          return RepaintBoundary(
            child: SizedBox(
              width: monthWidth,
              height: monthData.layout.calculateHeight(monthWidth),
              child: ACMonthWidget(
                layout: monthData.layout,
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

        final controller = DefaultScrollViewController<DateTime>(
          initialItem: clampedInitialMonth,
          onBefore: getPreviousMonth,
          onAfter: getNextMonth,
          itemExtentBuilder: itemExtentBuilder
        );

        return ACScrollView<DateTime>(
          controller: controller,
          itemBuilder: itemBuilder,
          scrollDirection: layout.scrollDirection,
          physics: layout.physics,
        );
      },
    );
  }
}