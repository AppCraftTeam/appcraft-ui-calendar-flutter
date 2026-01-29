import 'package:flutter/material.dart';

import '../../../../data/data.dart';
import '../../../../domain/src/ac_date_range.dart';
import '../../../presentation.dart';
// TODO: Remove or use
class ACMonthPager extends StatelessWidget {
  const ACMonthPager({
    required this.initialMonth,
    required this.range,
    this.controller,
    this.theme,
    this.onMonthChanged,
    super.key
  });

  final DateTime initialMonth;
  final ACDateRange range;
  final ACPagerController<DateTime>? controller;
  final ACCalendarThemeData? theme;
  final void Function(DateTime month)? onMonthChanged;
  
  ACCalendarRepository get _calendarRepository =>
    const ACCalendarRepository();

  @override
  Widget build(BuildContext context) =>
    ACPager<DateTime>(
      controller: controller,
      initialItem: initialMonth,
      onBefore: (date) => date.isBefore(range.min) ?
        null :
        _calendarRepository.addMonths(date, -1),
      onAfter: (date) => date.isAfter(range.max) ?
        null :
        _calendarRepository.addMonths(date, 1),
      onPageChanged: onMonthChanged,
      itemBuilder: (context, date) =>
        ACMonthWidget(
          monthDate: date,
          theme: theme,
          // onSelectDay: widget.selectController?.selectDay,
          // selectStyleForDay: widget.selectController?.selectStyleForDay
        )
    );
}

// TODO: Clear or use