import 'package:example/ac_calendar_repository.dart';
import 'package:flutter/material.dart';

class ACCalendarWeekWidget extends StatelessWidget {
  const ACCalendarWeekWidget({
    this.weekStart = DateTime.monday,
    super.key
  });

  final int weekStart;

  @override
  Widget build(BuildContext context) {
    final days = ACCalendarRepository().getWeekDaysRu(
      weekStart: weekStart
    );

    return SizedBox(
      height: 24,
      child: Row(
        spacing: 6,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (final day in days)
            Text(
              day,
              // TODO: Add to theme
              style: TextStyle(
                fontSize: 13,
                height: 13/18,
                fontWeight: FontWeight.w600,
                color: Color(0XFFD5DDE7)
              ),
            )
        ],
      ),
    );
  }
}