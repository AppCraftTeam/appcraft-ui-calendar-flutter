import 'package:example/presentation/src/ac_calendar_day_widget.dart';
import 'package:example/ac_calendar_repository.dart';
import 'package:flutter/material.dart';

class ACCalendarMonthWidget extends StatelessWidget {
  const ACCalendarMonthWidget({
    required this.monthDate,
    this.weekStart = DateTime.monday,
    super.key
  });

  final DateTime monthDate;
  final int weekStart;

  @override
  Widget build(BuildContext context) {
    final days = ACCalendarRepository().getMonthDays(
      monthDate,
      weekStart: weekStart
    );

    return GridView.builder(
      shrinkWrap: true,
      itemCount: days.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 6,
        mainAxisSpacing: 8
      ),
      itemBuilder: (context, index) =>
        ACCalendarDayWidget(
          day: days[index],
        )
    );
  }
}