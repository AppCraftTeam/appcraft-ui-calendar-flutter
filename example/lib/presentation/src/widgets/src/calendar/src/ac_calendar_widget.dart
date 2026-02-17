import 'package:flutter/material.dart';

import '../../../../../../data/data.dart';
import '../../../../../../domain/domain.dart';
import '../../../../../presentation.dart';

class ACCalendarWidget extends StatefulWidget {
  const ACCalendarWidget({
    required this.range,
    required this.layout,
    required this.childrenDelegate,
    this.selectController,
    this.initialDate,
    super.key,
  });

  ACCalendarWidget.vertical({
    required this.range,
    int? weekStart,
    // TODO: Implement
    String? locale,
    ACCalendarThemeData? theme,
    this.selectController,
    this.initialDate,
    super.key,
  }) : 
    layout = const VerticalCalendarLayout(),
    childrenDelegate = VerticalCalendarChildDelegate(
      range: range,
      theme: theme,
      weekStart: weekStart
    );

  final ACDateRange range;
  final ACCalendarLayout layout;
  final ACCalendarSelectController? selectController;
  final DateTime? initialDate;
  final ACCalendarChildDelegate childrenDelegate;

  @override
  State<ACCalendarWidget> createState() => _ACCalendarWidgetState();
}

class _ACCalendarWidgetState extends State<ACCalendarWidget> {
  final _calendarRepository = const ACCalendarRepository();

  late DateTime _minMonth;
  late DateTime _maxMonth;
  late ACCalendarChildDelegate _childrenDelegate;

  @override
  void initState() {
    super.initState();
    
    _setupRange();
    _childrenDelegate = widget.childrenDelegate;
    widget.selectController?.addListener(_selectControllerListener);
  }

  @override
  void didUpdateWidget(ACCalendarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.selectController != widget.selectController) {
      oldWidget.selectController?.removeListener(_selectControllerListener);
      widget.selectController?.addListener(_selectControllerListener);
    }

    if (oldWidget.childrenDelegate != widget.childrenDelegate) {
      _childrenDelegate.dispose();

      setState(() {
        _childrenDelegate = widget.childrenDelegate;
        _setupRange();
      });
    }
  }

  void _setupRange() {
    _minMonth = _calendarRepository.startOfMonth(widget.range.min);
    _maxMonth = _calendarRepository.startOfMonth(widget.range.max);
  }

  void _selectControllerListener() => setState(() {});

  @override
  void dispose() {
    widget.selectController?.removeListener(_selectControllerListener);
    _childrenDelegate.dispose();
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
        final controller = DefaultScrollViewController<DateTime>(
          initialItem: clampedInitialMonth,
          onBefore: getPreviousMonth,
          onAfter: getNextMonth,
          itemExtentBuilder: (monthDate) =>
            _childrenDelegate.itemExtentBuilder(monthDate, constraints),
        );

        return ACScrollView<DateTime>(
          controller: controller,
          itemBuilder: (context, monthDate) =>
            _childrenDelegate.itemBuilder(context, monthDate, constraints),
          scrollDirection: widget.layout.scrollDirection,
          physics: widget.layout.physics,
        );
      },
    );
  }
}