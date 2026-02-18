import 'package:flutter/material.dart';

import '../../../../../../../../data/data.dart';
import '../../../../../../../../domain/domain.dart';
import '../../../../../../../presentation.dart';

class ACCalendarWidget extends StatefulWidget {
  const ACCalendarWidget({
    required this.range,
    required this.layout,
    this.selectController,
    this.initialDate,
    this.onVisibleDateChanged,
    this.constraints,
    super.key,
  });

  ACCalendarWidget.vertical({
    required this.range,
    int? weekStart,
    ACCalendarThemeData? theme,
    this.selectController,
    this.initialDate,
    this.onVisibleDateChanged,
    this.constraints,
    super.key,
  }) :
    layout = ACVerticalCalendarLayout(
      range: range,
      theme: theme,
      weekStart: weekStart,
      onSelectStateForDay: selectController?.selectStateForDay,
      onSelectDay: selectController?.selectDay
    );

  ACCalendarWidget.pages({
    required this.range,
    int? weekStart,
    ACCalendarThemeData? theme,
    this.selectController,
    this.initialDate,
    this.onVisibleDateChanged,
    this.constraints,
    super.key,
  }) :
    layout = ACPagesCalendarLayout(
      range: range,
      theme: theme,
      weekStart: weekStart,
      onSelectStateForDay: selectController?.selectStateForDay,
      onSelectDay: selectController?.selectDay
    );

  final ACDateRange range;
  final ACCalendarSelectController? selectController;
  final DateTime? initialDate;
  final ACCalendarLayout layout;
  final void Function(DateTime visibleDate)? onVisibleDateChanged;
  final BoxConstraints? constraints;

  @override
  State<ACCalendarWidget> createState() => _ACCalendarWidgetState();
}

class _ACCalendarWidgetState extends State<ACCalendarWidget> {
  final _calendarRepository = const ACCalendarRepository();

  late DateTime _minMonth;
  late DateTime _maxMonth;
  late ACCalendarLayout _layout;

  @override
  void initState() {
    super.initState();

    _setupRange();
    _layout = widget.layout;
  }

  @override
  void didUpdateWidget(ACCalendarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.layout != widget.layout) {
      setState(() {
        _layout = widget.layout;
        _setupRange();
      });
    }
  }

  void _setupRange() {
    _minMonth = _calendarRepository.startOfMonth(widget.range.min);
    _maxMonth = _calendarRepository.startOfMonth(widget.range.max);
  }

  @override
  Widget build(BuildContext context) {
    final initialMonth = _calendarRepository.startOfMonth(
      widget.initialDate ?? DateTime.now()
    );

    // Убедимся, что начальный месяц в пределах range
    DateTime clampedInitialMonth;

    if (initialMonth.isBefore(_minMonth)) {
      clampedInitialMonth = _minMonth;
    } else if (initialMonth.isAfter(_maxMonth)) {
      clampedInitialMonth = _maxMonth;
    } else {
      clampedInitialMonth = initialMonth;
    }

    Widget buildScrollView(BuildContext context, BoxConstraints constraints) =>
      ACScrollView<DateTime>(
        controller: ACDateRangeScrollViewController(
          initialMonth: clampedInitialMonth,
          range: ACDateRange(
            min: _minMonth,
            max: _maxMonth
          ),
          onVisibleItemChanged: widget.onVisibleDateChanged,
          itemExtentBuilder: (monthDate) =>
            _layout.itemExtentBuilder(monthDate, constraints),
        ),
        itemBuilder: (context, monthDate) =>
          _layout.itemBuilder(context, monthDate, constraints),
        scrollDirection: widget.layout.scrollDirection,
        physics: widget.layout.physics
      );

    final scrollView = widget.constraints != null
        ? buildScrollView(context, widget.constraints!)
        : LayoutBuilder(builder: buildScrollView);

    return ACCalendarSelectionScope(
      selectController: widget.selectController,
      child: scrollView,
    );
  }
}