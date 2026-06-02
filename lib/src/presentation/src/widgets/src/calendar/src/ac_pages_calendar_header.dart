import 'package:flutter/material.dart';

import '../../../../../../domain/src/ac_date_format.dart';
import '../../../../../../utils/src/ac_string_ext.dart';
import '../../../../theme/src/ac_calendar_theme_data.dart';
import '../../../../theme/src/ac_pages_calendar_header_theme_data.dart';

/// Header of the paged calendar with month navigation.
///
/// Displays the current month and year names, forward/back navigation
/// buttons, and an icon for expanding the month picker.
class ACPagesCalendarHeader extends StatelessWidget
    implements PreferredSizeWidget {
  /// Creates a paged calendar header.
  const ACPagesCalendarHeader(
      {required this.monthDate,
      this.monthPickerShow = false,
      this.locale,
      this.theme,
      this.onPrevious,
      this.onNext,
      this.onMonthTap,
      this.arrowRotateDuration,
      super.key});

  /// Date that determines the displayed month and year.
  final DateTime monthDate;

  /// Whether the widget shows the open month picker state.
  /// When `true`, hides the navigation arrows and rotates the dropdown icon.
  final bool monthPickerShow;

  /// Locale for formatting the month and year.
  /// If not set, taken from [Localizations].
  final String? locale;

  /// Header theme. If not set, taken from [ACCalendarThemeData].
  final ACPagesCalendarHeaderThemeData? theme;

  /// Called when the "next month" button is pressed.
  final VoidCallback? onNext;

  /// Called when the "previous month" button is pressed.
  final VoidCallback? onPrevious;

  /// Duration of the dropdown icon rotation animation.
  final Duration? arrowRotateDuration;

  /// Called when the row with the month name is tapped.
  final void Function()? onMonthTap;

  @override
  Size get preferredSize => const Size.fromHeight(40);

  @override
  Widget build(BuildContext context) {
    final theme = this.theme ??
        ACCalendarThemeExtension.of(context).pagesCalendarHeaderTheme;
    final locale =
        this.locale ?? Localizations.maybeLocaleOf(context)?.toLanguageTag();
    final arrowRotateDuration =
        this.arrowRotateDuration ?? const Duration(milliseconds: 300);

    Widget navigateArrowButton(IconData icon, {VoidCallback? onPressed}) =>
        SizedBox.square(
          dimension: 24,
          child: IconButton(
              onPressed: onPressed,
              icon: Icon(icon),
              iconSize: 20,
              color: theme.arrowColor,
              padding: const EdgeInsets.all(2)),
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
                    ACDateFormat.monthYear(locale)
                        .format(monthDate)
                        .toUpperCaseFirstLetter(),
                    style: theme.titleTextStyle.copyWith(
                      color: theme.monthTextColor,
                    )),
                AnimatedRotation(
                  turns: monthPickerShow ? -.25 : 0,
                  duration: arrowRotateDuration,
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 24,
                    color: theme.monthTextColor,
                  ),
                )
              ],
            ),
          ),
          const Spacer(),
          if (!monthPickerShow) ...[
            navigateArrowButton(Icons.arrow_back_ios_rounded,
                onPressed: onPrevious),
            const SizedBox(width: 12),
            navigateArrowButton(Icons.arrow_forward_ios_rounded,
                onPressed: onNext)
          ]
        ],
      ),
    );
  }
}
