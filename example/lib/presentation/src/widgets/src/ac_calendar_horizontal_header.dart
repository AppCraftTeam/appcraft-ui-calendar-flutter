import 'package:flutter/material.dart';

import '../../../../domain/domain.dart';
import '../../../../utils/utils.dart';
import '../../../presentation.dart';
// TODO: Добавить стрелку справа от title, добавить анимацию вращения
class ACCalendarHorizontalHeader extends StatelessWidget {
  const ACCalendarHorizontalHeader({
    required this.monthDate,
    this.monthPickerShow = false,
    this.locale,
    this.theme,
    this.onPrevious,
    this.onNext,
    this.onMonthTap,
    super.key
  });

  final DateTime monthDate;
  final bool monthPickerShow;
  final String? locale;
  final ACCalendarHeaderThemeData? theme;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;
  final void Function()? onMonthTap;

  static const height = 40.0;

  @override
  Widget build(BuildContext context) {
    final theme = this.theme ?? ACCalendarTheme.of(context).calendarHeaderTheme;
    final locale = this.locale ?? Localizations.maybeLocaleOf(context)?.toLanguageTag();

    Widget arrow( 
      IconData icon,
      { VoidCallback? onPressed }
    ) => SizedBox.square(
      dimension: 24,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        iconSize: 20,
        color: theme.primaryColor,
        padding: const EdgeInsets.all(2)
      ),
    );

    return SizedBox(
      height: height,
      child: Row(
        children: [
          GestureDetector(
            onTap: onMonthTap,
            child: Text(
              ACDateFormat
                .monthYear(locale)
                .format(monthDate)
                .toUpperCaseFirstLetter(),
              style: theme.titleTextStyle.copyWith(
                color: theme.primaryColor
              )
            ),
          ),
  
          const Spacer(),
  
          if (!monthPickerShow)...[
            arrow(
              Icons.arrow_back_ios_rounded,
              onPressed: onPrevious
            ),
  
            const SizedBox(width: 12),

            arrow(
              Icons.arrow_forward_ios_rounded,
              onPressed: onNext
            )
          ]
        ],
      ),
    );
  }

}