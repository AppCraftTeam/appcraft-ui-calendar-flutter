import 'package:example/ac_calendar_day.dart';
import 'package:flutter/material.dart';

class ACCalendarDayWidget extends StatelessWidget {
  const ACCalendarDayWidget({
    required this.day,
    this.color,
    super.key
  });

  final ACCalendarDay day;
  final Color? color;

  @override
  Widget build(BuildContext context) => Container(
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: color,
      shape: BoxShape.circle
    ),
    child: Text(
      day.date.day.toString(),
      // TODO: Add to styles
      style: TextStyle(
        color: day.isCurrentMonth ?
          Color(0XFF000000) :
          Color(0XFFD5DDE7),
        fontSize: 20,
        fontWeight: FontWeight.w400,
        height: 20/25
      ),
    ),
  );
}