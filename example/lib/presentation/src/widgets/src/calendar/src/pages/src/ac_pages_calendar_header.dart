import 'package:flutter/material.dart';

import '../../../../../../../../domain/domain.dart';
import '../../../../../../../../utils/utils.dart';
import '../../../../../../../presentation.dart';
// TODO: refactoring
class ACPagesCalendarHeader extends StatelessWidget implements PreferredSizeWidget {
  const ACPagesCalendarHeader({
    required this.monthDate,
    this.monthPickerShow = false,
    this.locale,
    this.theme,
    this.onPrevious,
    this.onNext,
    this.onMonthTap,
    this.arrowRoateDuration,
    super.key
  });

  final DateTime monthDate;
  final bool monthPickerShow;
  final String? locale;
  final ACCalendarHeaderThemeData? theme;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;
  final Duration? arrowRoateDuration;
  final void Function()? onMonthTap;

  @override
  Size get preferredSize => const Size.fromHeight(40);

  @override
  Widget build(BuildContext context) {
    final theme = this.theme ?? ACCalendarScope.maybeOf(context)?.theme.calendarHeaderTheme ?? ACLightCalendarThemeData().calendarHeaderTheme;
    final locale = this.locale ?? Localizations.maybeLocaleOf(context)?.toLanguageTag();
    final arrowRoateDuration = this.arrowRoateDuration ?? const Duration(milliseconds: 300);

    Widget navigateArrowButton( 
      IconData icon,
      { VoidCallback? onPressed }
    ) => SizedBox.square(
      dimension: 24,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        iconSize: 20,
        // TODO: Add to props
        color: theme.primaryColor,
        padding: const EdgeInsets.all(2)
      ),
    );

    return SizedBox(
      height: preferredSize.height,
      child: Row(
        children: [
          GestureDetector(
            onTap: onMonthTap,
            child: Row(
              children: [
                Text(
                  ACDateFormat
                    .monthYear(locale)
                    .format(monthDate)
                    .toUpperCaseFirstLetter(),
                  style: theme.titleTextStyle.copyWith(
                    // TODO: Add to props
                    color: theme.primaryColor
                  )
                ),

                AnimatedRotation(
                  turns: monthPickerShow ? -.25 : 0,
                  duration: arrowRoateDuration,
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 24,
                    // TODO: Add to props
                    color: theme.primaryColor,
                  ),
                )
              ],
            ),
          ),
  
          const Spacer(),
  
          if (!monthPickerShow)...[
            navigateArrowButton(
              Icons.arrow_back_ios_rounded,
              onPressed: onPrevious
            ),
  
            const SizedBox(width: 12),

            navigateArrowButton(
              Icons.arrow_forward_ios_rounded,
              onPressed: onNext
            )
          ]
        ],
      ),
    );
  }
}