import 'package:flutter/material.dart';

import '../../../../data/src/ac_calendar_repository.dart';
import '../../../presentation.dart';
// TODO: Refactoring
class ACMonthWidget extends StatelessWidget {
  const ACMonthWidget({
    required this.monthDate,
    this.weekStart,
    this.theme,
    this.selectStateForDay,
    this.shouldSelectDay,
    this.onSelectDay,
    this.layout = const ACDefaultMonthLayout(),
    super.key
  });

  final DateTime monthDate;
  final int? weekStart;
  final ACCalendarThemeData? theme;
  final ACDaySelectState? Function(DateTime day)? selectStateForDay;
  final bool Function(DateTime day)? shouldSelectDay;
  final void Function(DateTime day)? onSelectDay;
  final ACMonthLayout layout;

  @override
  Widget build(BuildContext context) {
    final resolvedTheme = theme ?? ACCalendarTheme.of(context);
    final dayTheme = resolvedTheme.dayTheme;
    final now = DateTime.now();

    final days = const ACCalendarRepository().getMonthDays(
      monthDate,
      weekStart: weekStart
    );

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: days.length,
      gridDelegate: layout.gridDelegate,
      itemBuilder: (context, index) {
        final day = days[index];

        final isToday = day.year == now.year &&
          day.month == now.month &&
          day.day == now.day;

        final shouldSelectDay = (this.shouldSelectDay?.call(day) ?? true) &&
          day.month == monthDate.month;

        final selectState = shouldSelectDay ?
          selectStateForDay?.call(day) :
          null;

        final backgroundColor = switch (selectState) {
          ACDaySelectState.single => dayTheme.selectedBackgroundColor,
          ACDaySelectState.multi => dayTheme.selectedBackgroundColor,
          ACDaySelectState.startOfRange => dayTheme.selectedBackgroundColor,
          ACDaySelectState.endOfRange => dayTheme.selectedBackgroundColor,
          ACDaySelectState.middleInRange => dayTheme.middleSelectedBackgroudColor,
          null => null
        };

        return ACDayWidget(
          dayDate: day,
          theme: theme?.dayTheme,
          backgroundColor: backgroundColor,
          textColor: shouldSelectDay ?
            dayTheme.textColor :
            dayTheme.inactiveTextColor,
          textStyle: isToday ?
            dayTheme.todayTextStyle :
            dayTheme.textStyle,
          onTap: shouldSelectDay ?
            () => onSelectDay?.call(day) :
            null
        );
      }
    );
  }
}