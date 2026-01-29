import 'package:flutter/material.dart';

import '../../../presentation.dart';
// TODO: Refactoring
// Переделать selectStyle и active
class ACDayWidget extends StatelessWidget {
  const ACDayWidget({
    required this.dayDate,
    this.active = true,
    this.selectStyle,
    this.theme,
    this.onTap,
    super.key
  });

  final DateTime dayDate;
  final ACCalendarThemeData? theme;
  final ACDaySelectStyle? selectStyle;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = this.theme ?? ACCalendarTheme.of(context);
    final dayTheme = theme.dayTheme;

    final now = DateTime.now();

    final isToday = dayDate.year == now.year &&
      dayDate.month == now.month &&
      dayDate.day == now.day;

    final textStyle = isToday ?
      dayTheme.todayTextStyle :
      dayTheme.textStyle;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selectStyle?.backgroudColor(context, theme),
          shape: BoxShape.circle
        ),
        child: Text(
          dayDate.day.toString(),
          style: textStyle.copyWith(
            color: active ?
              dayTheme.activeTextColor :
              dayTheme.inactiveTextColor,
          )
        ),
      ),
    );
  }
}