import 'package:flutter/material.dart';

import '../../../../../../data/src/ac_calendar_repository.dart';
import '../../../../../../domain/domain.dart';
import '../../../../../../utils/utils.dart';
import '../../../../../presentation.dart';

class ACVerticalCalendarWidget extends StatefulWidget {
  const ACVerticalCalendarWidget({
    required this.range,
    this.weekStart,
    this.locale,
    this.theme,
    this.selectController,
    this.initialMonth,
    super.key,
  });

  final ACDateRange range;
  final int? weekStart;
  final String? locale;
  final ACCalendarThemeData? theme;
  final ACCalendarSelectController? selectController;
  final DateTime? initialMonth;

  @override
  State<ACVerticalCalendarWidget> createState() =>
      _ACVerticalCalendarWidgetState();
}

class _ACVerticalCalendarWidgetState extends State<ACVerticalCalendarWidget> {
  final _calendarRepository = const ACCalendarRepository();
  final _scrollViewController = ACScrollViewController<DateTime>();

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
  void didUpdateWidget(ACVerticalCalendarWidget oldWidget) {
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

  /// Получает предыдущий месяц (если не вышли за границы range)
  DateTime? _getPreviousMonth(DateTime current) {
    final previous = _calendarRepository.addMonths(current, -1);
    if (previous.isBefore(_minMonth)) return null;
    return previous;
  }

  /// Получает следующий месяц (если не вышли за границы range)
  DateTime? _getNextMonth(DateTime current) {
    final next = _calendarRepository.addMonths(current, 1);
    if (next.isAfter(_maxMonth)) return null;
    return next;
  }

  double _calculateMonthHeight(double width) {
    return ACMonthWidget.calculateHeight(width);
  }

  /// Полная высота элемента списка (месяц + заголовок + отступы)
  double _calculateItemHeight(double width) {
    const titleHeight = 24.0; // примерная высота заголовка titleMedium
    const titlePadding = 8.0;
    const itemPadding = 24.0;
    return titleHeight + titlePadding + _calculateMonthHeight(width) + itemPadding;
  }

  @override
  void dispose() {
    widget.selectController?.removeListener(_selectControllerListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final initialMonth = widget.initialMonth != null
        ? _calendarRepository.startOfMonth(widget.initialMonth!)
        : _calendarRepository.startOfMonth(DateTime.now());

    // Убедимся, что начальный месяц в пределах range
    final clampedInitialMonth = initialMonth.isBefore(_minMonth)
        ? _minMonth
        : (initialMonth.isAfter(_maxMonth) ? _maxMonth : initialMonth);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final monthHeight = _calculateMonthHeight(width);
        final itemHeight = _calculateItemHeight(width);

        return ACScrollView<DateTime>(
          initialItem: clampedInitialMonth,
          onBefore: _getPreviousMonth,
          onAfter: _getNextMonth,
          controller: _scrollViewController,
          preloadCount: 10,
          bufferThreshold: 3,
          itemHeight: itemHeight,
          headerBuilder: (context) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ACWeekWidget(
              weekStart: widget.weekStart,
              locale: widget.locale,
              theme: widget.theme?.weekTheme,
            ),
          ),
          itemBuilder: (BuildContext context, DateTime monthDate, int index) =>
              Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Заголовок месяца
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    ACDateFormat.monthYear(widget.locale)
                        .format(monthDate)
                        .toUpperCaseFirstLetter(),
                    style: widget.theme?.calendarHeaderTheme?.titleTextStyle ??
                        Theme.of(context).textTheme.titleMedium!,
                  ),
                ),

                // Сам календарь месяца
                SizedBox(
                  height: monthHeight,
                  child: ACMonthWidget(
                    monthDate: monthDate,
                    weekStart: widget.weekStart,
                    theme: widget.theme,
                    selectStyleForDay:
                        widget.selectController?.selectStyleForDay,
                    onSelectDay: widget.selectController?.selectDay,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
