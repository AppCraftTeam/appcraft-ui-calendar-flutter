import 'package:flutter/material.dart';

import '../../../../../../domain/src/ac_day_month_position.dart';
import '../../../../../../domain/src/ac_day_select_state.dart';
import '../../../../theme/src/ac_calendar_theme_data.dart';
import '../../../../theme/src/ac_day_theme_data.dart';

/// Widget that renders a single day in the calendar grid.
///
/// Displays the day number, accounting for the selection state [selectState],
/// the position within the month [monthPosition], and selectability [shouldSelect].
class ACDayWidget extends StatelessWidget {
  /// Creates a day widget.
  const ACDayWidget({
    required this.dayDate,
    this.shouldSelect,
    this.monthPosition,
    this.theme,
    this.selectState,
    this.onTap,
    super.key,
  });

  /// Date of the day displayed in the widget.
  final DateTime dayDate;

  /// Position of the day relative to the displayed month.
  final ACDayMonthPosition? monthPosition;

  /// Day theme. If not specified, taken from [ACCalendarThemeData].
  final ACDayThemeData? theme;

  /// Whether this day can be selected.
  final bool? shouldSelect;

  /// Current selection state of the day.
  final ACDaySelectState? selectState;

  /// Tap handler.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = this.theme ?? ACCalendarThemeExtension.of(context).dayTheme;

    final backgroundColor = switch (selectState) {
      null => null,
      ACDaySelectState.single => theme.selectedBackgroundColor,
      ACDaySelectState.multi => theme.selectedBackgroundColor,
      ACDaySelectState.startOfRange => theme.selectedBackgroundColor,
      ACDaySelectState.endOfRange => theme.selectedBackgroundColor,
      ACDaySelectState.middleInRange => theme.middleSelectedBackgroundColor,
    };

    final shouldSelect = this.shouldSelect ?? true;
    final now = DateTime.now();

    final isToday = dayDate.year == now.year &&
        dayDate.month == now.month &&
        dayDate.day == now.day;

    final textStyle =
        (isToday ? theme.todayTextStyle : theme.textStyle).copyWith(
      color: shouldSelect ? theme.textColor : theme.inactiveTextColor,
    );

    Widget child = Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Text(
        dayDate.day.toString(),
        style: textStyle,
      ),
    );

    if (onTap != null) {
      child = GestureDetector(
        onTap: onTap,
        child: child,
      );
    }

    return child;
  }
}
