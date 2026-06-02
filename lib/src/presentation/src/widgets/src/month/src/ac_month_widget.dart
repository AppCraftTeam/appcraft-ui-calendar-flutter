import 'package:flutter/material.dart';

import '../../../../../../domain/src/ac_day_month_position.dart';
import '../../../../theme/src/ac_calendar_theme_data.dart';
import '../../../../theme/src/ac_day_theme_data.dart';
import '../../day/src/ac_calendar_day_widget.dart';
import 'ac_month_layout.dart';

/// Month days grid widget.
///
/// Places days in a grid via [CustomMultiChildLayout] using
/// the provided [layout]. Each day is rendered via [ACCalendarDayWidget].
class ACMonthWidget extends StatelessWidget {
  /// Creates a month grid widget.
  const ACMonthWidget({
    required this.layout,
    required this.days,
    required this.monthDate,
    this.dayTheme,
    this.dayBuilder,
    super.key,
  });

  /// Month layout that determines the placement of elements in the grid
  final ACMonthLayout layout;

  /// List of days to display in the month grid,
  /// including days from adjacent months to fill the first and last weeks
  final List<DateTime> days;

  /// First day of the displayed month — used to compute the position of each day
  final DateTime monthDate;

  /// Day theme. If not set, taken from [ACCalendarThemeData].
  final ACDayThemeData? dayTheme;

  /// Custom builder for the day widget.
  ///
  /// If set, used instead of the standard [ACCalendarDayWidget].
  final Widget Function(BuildContext context, DateTime day)? dayBuilder;

  @override
  Widget build(BuildContext context) => CustomMultiChildLayout(
        delegate: layout,
        children: [
          for (int i = 0; i < days.length; i++)
            LayoutId(
              id: i,
              child: dayBuilder?.call(context, days[i]) ??
                  ACCalendarDayWidget(
                    dayDate: days[i],
                    monthPosition:
                        ACDayMonthPosition.forDay(days[i], monthDate),
                    theme: dayTheme,
                  ),
            ),
        ],
      );
}
