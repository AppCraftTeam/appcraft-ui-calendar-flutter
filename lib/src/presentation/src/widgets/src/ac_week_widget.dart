import 'package:flutter/material.dart';

import '../../../../data/src/ac_calendar_repository.dart';
import '../../../../data/src/ac_default_calendar_repository.dart';
import '../../../../domain/src/ac_date_format.dart';
import '../../theme/src/ac_calendar_theme_data.dart';
import '../../theme/src/ac_week_theme_data.dart';

/// Weekday row widget (Mon, Tue, ..., Sun).
///
/// Displays abbreviated weekday names in the order
/// determined by [repository].
class ACWeekWidget extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a weekday row widget.
  const ACWeekWidget({this.repository, this.locale, this.theme, super.key});

  /// Repository for calendar computations.
  ///
  /// If not specified, [ACDefaultCalendarRepository] is used.
  final ACCalendarRepository? repository;

  /// Locale for formatting weekday names.
  /// If not set, taken from [Localizations].
  final String? locale;

  /// Weekday row theme. If not set, taken from [ACCalendarThemeData].
  final ACWeekThemeData? theme;

  @override
  Size get preferredSize => const Size.fromHeight(24);

  @override
  Widget build(BuildContext context) {
    final theme = this.theme ?? ACCalendarThemeExtension.of(context).weekTheme;
    final locale =
        this.locale ?? Localizations.maybeLocaleOf(context)?.toLanguageTag();

    final repository = this.repository ?? const ACDefaultCalendarRepository();

    final days = repository.getWeekDays();

    return SizedBox(
      height: preferredSize.height,
      child: Row(
        spacing: 6,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (final day in days)
            Text(ACDateFormat.weekday(locale).format(day).toUpperCase(),
                style: theme.textStyle.copyWith(color: theme.textColor))
        ],
      ),
    );
  }
}
