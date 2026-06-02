import 'package:flutter/material.dart';

import '../../../../../../domain/src/ac_day_month_position.dart';
import '../../../../ac_calendar_scope.dart';
import '../../../../theme/src/ac_calendar_theme_data.dart';
import '../../../../theme/src/ac_day_theme_data.dart';
import 'ac_day_widget.dart';

/// "Smart" day widget — reads data from [ACCalendarScope].
///
/// Accepts only [dayDate] and [monthPosition]; the rest is
/// taken from the scope and subscribes to selection changes
/// via [ListenableBuilder].
class ACCalendarDayWidget extends StatelessWidget {
  /// Creates a "smart" day widget.
  const ACCalendarDayWidget({
    required this.dayDate,
    this.monthPosition,
    this.theme,
    super.key,
  });

  /// Date of the day displayed in the widget.
  final DateTime dayDate;

  /// Position of the day relative to the displayed month.
  final ACDayMonthPosition? monthPosition;

  /// Day theme. If not set, taken from [ACCalendarThemeData].
  final ACDayThemeData? theme;

  @override
  Widget build(BuildContext context) {
    final scope = ACCalendarScope.maybeOf(context);
    final selectController = scope?.selectController;

    final shouldSelect = monthPosition != ACDayMonthPosition.leading &&
        monthPosition != ACDayMonthPosition.trailing &&
        (scope?.shouldSelectDay(dayDate) ?? true);

    final onTap =
        shouldSelect ? () => selectController?.selectDay(dayDate) : null;

    if (selectController != null) {
      return ListenableBuilder(
        listenable: selectController,
        builder: (context, _) => ACDayWidget(
          dayDate: dayDate,
          monthPosition: monthPosition,
          shouldSelect: shouldSelect,
          theme: theme,
          selectState:
              shouldSelect ? selectController.selectStateForDay(dayDate) : null,
          onTap: onTap,
        ),
      );
    }

    return ACDayWidget(
      dayDate: dayDate,
      monthPosition: monthPosition,
      shouldSelect: shouldSelect,
      theme: theme,
      onTap: onTap,
    );
  }
}
