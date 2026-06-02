import 'package:flutter/material.dart';

import '../../../../../../localization/src/ac_default_localization_manager.dart';
import '../../../../ac_calendar_scope.dart';
import '../../../../theme/src/ac_calendar_theme_data.dart';
import '../../../../theme/src/ac_titled_time_theme_data.dart';
import 'ac_time_input_controller.dart';
import 'ac_time_input_widget.dart';
import 'ac_time_range_input_controller.dart';
import 'ac_time_range_input_widget.dart';

/// Widget with a title and a time input field.
///
/// Displays a row: title on the left, time input field on the right.
/// Has two named constructors:
/// - [ACTitledTimeWidget.single] — for single time input;
/// - [ACTitledTimeWidget.range] — for time range input.
///
/// Implements [PreferredSizeWidget] with a height of [preferredHeight].
class ACTitledTimeWidget extends StatelessWidget
    implements PreferredSizeWidget {
  /// Creates a widget with a single time input field.
  ACTitledTimeWidget.single({
    this.title,
    ACTimeInputController? controller,
    this.theme,
    this.preferredHeight = 34,
    super.key,
  }) : child = IntrinsicWidth(
          child: ACTimeInputWidget(
            controller: controller,
          ),
        );

  /// Creates a widget with a time range input field.
  ACTitledTimeWidget.range({
    this.title,
    ACTimeRangeInputController? controller,
    this.theme,
    this.preferredHeight = 34,
    super.key,
  }) : child = IntrinsicWidth(
          child: ACTimeRangeInputWidget(
            controller: controller,
          ),
        );

  /// Title. If `null`, `'Time'` is displayed.
  final String? title;

  /// Child time input widget wrapped in a [SizedBox].
  final Widget child;

  /// Visual theme. If not set, taken from [ACCalendarThemeData].
  final ACTitledTimeThemeData? theme;

  /// Preferred widget height.
  final double preferredHeight;

  @override
  Size get preferredSize => Size.fromHeight(preferredHeight);

  @override
  Widget build(BuildContext context) {
    final theme =
        this.theme ?? ACCalendarThemeExtension.of(context).titledTimeTheme;
    final locale = Localizations.maybeLocaleOf(context)?.toLanguageTag();
    final effectiveTitle = title ??
        (ACCalendarScope.maybeOf(context)?.localization(locale) ??
                const ACDefaultLocalizationManager().localization(locale))
            .time;

    return SizedBox(
      height: preferredHeight,
      child: Row(
        children: [
          Expanded(
            child: Text(
              effectiveTitle,
              style: theme.titleTextStyle.copyWith(
                color: theme.titleColor,
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
