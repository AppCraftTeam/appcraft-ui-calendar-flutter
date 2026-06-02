import 'package:flutter/material.dart';

import '../../../../../../domain/src/ac_date_format.dart';
import '../../../../../../utils/src/ac_string_ext.dart';
import '../../../../theme/src/ac_calendar_theme_data.dart';
import '../../../../theme/src/ac_day_theme_data.dart';
import '../../../../theme/src/ac_titled_month_theme_data.dart';
import '../../day/src/ac_calendar_day_widget.dart';
import 'ac_month_layout.dart';
import 'ac_month_widget.dart';

/// Month widget with the month name title in the top-right corner.
///
/// Displays [ACMonthWidget] with a text title (the month name)
/// aligned to the top-right.
class ACTitledMonthWidget extends StatelessWidget {
  const ACTitledMonthWidget({
    required this.layout,
    required this.days,
    required this.monthDate,
    this.dayTheme,
    this.dayBuilder,
    this.locale,
    this.theme,
    super.key,
  });

  /// Fixed height of the header with the month name.
  static const double headerHeight = 24;

  /// Spacing between the header and the month grid.
  static const double spacing = 12;

  /// Month layout that determines the placement of elements in the grid.
  final ACMonthLayout layout;

  /// List of days to display in the month grid.
  final List<DateTime> days;

  /// First day of the displayed month.
  final DateTime monthDate;

  /// Day theme. If not set, taken from [ACCalendarThemeData].
  final ACDayThemeData? dayTheme;

  /// Custom builder for the day widget.
  ///
  /// If set, passed to [ACMonthWidget] and used
  /// instead of the standard [ACCalendarDayWidget].
  final Widget Function(BuildContext context, DateTime day)? dayBuilder;

  /// Locale for formatting the month name.
  ///
  /// If not specified, taken from [Localizations].
  final String? locale;

  /// Header theme. If not set, taken from [ACCalendarThemeData].
  final ACTitledMonthThemeData? theme;

  @override
  Widget build(BuildContext context) {
    final theme =
        this.theme ?? ACCalendarThemeExtension.of(context).titledMonthTheme;
    final locale =
        this.locale ?? Localizations.maybeLocaleOf(context)?.toLanguageTag();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: spacing,
      children: [
        SizedBox(
          height: headerHeight,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              ACDateFormat.month(locale)
                  .format(monthDate)
                  .toUpperCaseFirstLetter(),
              style: theme.titleTextStyle.copyWith(color: theme.titleColor),
            ),
          ),
        ),
        Expanded(
          child: ACMonthWidget(
            layout: layout,
            days: days,
            monthDate: monthDate,
            dayTheme: dayTheme,
            dayBuilder: dayBuilder,
          ),
        ),
      ],
    );
  }
}
