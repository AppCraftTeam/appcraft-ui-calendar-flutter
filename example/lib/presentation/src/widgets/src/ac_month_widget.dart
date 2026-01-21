import 'package:flutter/material.dart';

import '../../../../data/src/ac_calendar_repository.dart';
import '../../../presentation.dart';

class ACMonthWidget extends StatelessWidget {
  const ACMonthWidget({
    required this.monthDate,
    this.weekStart,
    this.theme,
    this.selectStyleForDay,
    this.shouldSelectDay,
    this.onSelectDay,
    super.key
  });

  final DateTime monthDate;
  final int? weekStart;
  final ACCalendarThemeData? theme;
  final ACDaySelectStyle? Function(DateTime day)? selectStyleForDay;
  final bool Function(DateTime day)? shouldSelectDay;
  final void Function(DateTime day)? onSelectDay;

  @override
  Widget build(BuildContext context) {
    final days = const ACCalendarRepository().getMonthDays(
      monthDate,
      weekStart: weekStart
    );

    return GridView.builder(
      shrinkWrap: true,
      itemCount: days.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 6,
        mainAxisSpacing: 8
      ),
      itemBuilder: (context, index) {
        final day = days[index];

        final shouldSelectDay = (this.shouldSelectDay?.call(day) ?? true) &&
          day.month == monthDate.month;

        return ACDayWidget(
          dayDate: day,
          theme: theme,
          active: shouldSelectDay,
          selectStyle: shouldSelectDay ?
            selectStyleForDay?.call(day) :
            null,
          onTap: shouldSelectDay ?
            () => onSelectDay?.call(day) :
            null
        );
      }
    );
  }
}