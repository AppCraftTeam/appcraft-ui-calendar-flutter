import 'package:flutter/material.dart';

import '../../../../../../data/src/ac_calendar_repository.dart';
import '../../../../../../domain/domain.dart';
import '../../../../../presentation.dart';

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

  late DateTime _minMonth;
  late DateTime _maxMonth;

  @override
  void initState() {
    super.initState();
    _minMonth = _calendarRepository.startOfMonth(widget.range.min);
    _maxMonth = _calendarRepository.startOfMonth(widget.range.max);
    widget.selectController?.addListener(_selectControllerListener);
  }

  @override
  void didUpdateWidget(ACCalendarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectController != widget.selectController) {
      oldWidget.selectController?.removeListener(_selectControllerListener);
      widget.selectController?.addListener(_selectControllerListener);
    }

    if (oldWidget.range != widget.range) {
      setState(() {
        _minMonth = _calendarRepository.startOfMonth(widget.range.min);
        _maxMonth = _calendarRepository.startOfMonth(widget.range.max);
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

    List<DateTime> getDaysForMonth(DateTime monthDate) =>
      _calendarRepository.getMonthDays(monthDate, weekStart: widget.weekStart);

    return LayoutBuilder(
      builder: (context, constraints) {
        final layout = widget.layout;
        final monthWidth = constraints.maxWidth;

        double itemExtentBuilder(DateTime monthDate) {
          switch (layout.scrollDirection) {
            case Axis.horizontal:
              return monthWidth;
            case Axis.vertical:
              final days = getDaysForMonth(monthDate);

              final monthLayout = DefaultMonthLayout(
                mainAxisCount: (days.length / 7).toInt()
              );

              return monthLayout.calculateHeight(monthWidth);
          }
        }
      
        Widget itemBuilder(BuildContext context, DateTime monthDate) {
          final days = getDaysForMonth(monthDate);

          final monthLayout = DefaultMonthLayout(
            mainAxisCount: switch (layout.scrollDirection) {
              Axis.horizontal => 6,
              Axis.vertical => (days.length / 7).toInt(),
            },
          );

          return SizedBox(
            width: monthWidth,
            height: monthLayout.calculateHeight(monthWidth),
            child: Stack(
              children: [
                Opacity(
                  opacity: .5,
                  child: ACMonthWidget(
                    layout: monthLayout,
                    childrenDelegate: DefaultMonthChildDelegate(
                      days: getDaysForMonth(monthDate),
                      monthDate: monthDate,
                      range: widget.range,
                      dayTheme: widget.theme?.dayTheme,
                      onSelectStateForDay: widget.selectController?.selectStateForDay,
                      onSelectDay: widget.selectController?.selectDay,
                    )
                  ),
                ),

                Text(monthDate.toString())
              ],
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