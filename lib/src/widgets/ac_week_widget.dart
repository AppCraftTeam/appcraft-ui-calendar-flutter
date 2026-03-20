import 'package:flutter/material.dart';

import '../data/ac_calendar_repository.dart';
import '../data/ac_default_calendar_repository.dart';
import '../domain/ac_date_format.dart';
import '../theme/ac_calendar_theme_data.dart';
import '../theme/ac_week_theme_data.dart';

class ACWeekWidget extends StatelessWidget implements PreferredSizeWidget {
  const ACWeekWidget({this.repository, this.locale, this.theme, super.key});

  /// Репозиторий для вычислений календаря.
  ///
  /// Если не указан, используется [ACDefaultCalendarRepository].
  final ACCalendarRepository? repository;

  /// Локаль для форматирования названий дней недели.
  /// Если не задана, берётся из [Localizations].
  final String? locale;

  /// Тема строки дней недели. Если не задана, берётся из [ACCalendarThemeData].
  final ACWeekThemeData? theme;

  @override
  Size get preferredSize => const Size.fromHeight(24);

  @override
  Widget build(BuildContext context) {
    final theme = this.theme ?? ACCalendarThemeData.of(context).weekTheme;
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
