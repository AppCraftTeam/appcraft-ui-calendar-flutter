import 'package:flutter/material.dart';

import '../../../../data/data.dart';
import '../../../../domain/domain.dart';
import '../../../presentation.dart';

class ACWeekWidget extends StatelessWidget implements PreferredSizeWidget {
  const ACWeekWidget({
    this.weekStart,
    this.locale,
    this.theme,
    super.key
  });

  final int? weekStart;
  final String? locale;
  final ACWeekThemeData? theme;

  @override
  Size get preferredSize => const Size.fromHeight(24);

  @override
  Widget build(BuildContext context) {
    final theme = this.theme ?? ACCalendarTheme.of(context).weekTheme;
    final locale = this.locale ?? Localizations.maybeLocaleOf(context)?.toLanguageTag();

    final days = const ACCalendarRepository().getWeekDays(
      weekStart: weekStart
    );

    return SizedBox(
      height: preferredSize.height,
      child: Row(
        spacing: 6,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (final day in days)
            Text(
              ACDateFormat
                .weekday(locale)
                .format(day)
                .toUpperCase(),
              style: theme.textStyle.copyWith(
                // TODO: Add to props
                color: theme.textColor
              )
            )
        ],
      ),
    );
  }
}