import 'package:flutter/material.dart';

import '../../../../../../data/src/ac_calendar_repository.dart';
import '../../../../../../data/src/ac_default_calendar_repository.dart';
import '../../../../../../domain/src/ac_date_range.dart';
import '../../../../ac_calendar_scope.dart';
import '../../../../select_controller/ac_calendar_select_controller.dart';
import '../../../../theme/src/ac_calendar_theme_data.dart';
import '../../month/src/ac_month_layout.dart';
import '../../scroll_view/src/ac_scroll_view_controller.dart';
import 'ac_raw_calendar_widget.dart';

/// Calendar with vertical scrolling by months.
///
/// Displays a continuous feed of months with the ability to scroll vertically
/// within the given [range].
///
/// Wraps [ACRawCalendarWidget] in an [ACCalendarScope],
/// providing the theme and selection controller to child widgets.
class ACCalendarWidget extends StatelessWidget {
  /// Creates a calendar with vertical scrolling.
  const ACCalendarWidget({
    required this.range,
    this.repository,
    this.theme,
    this.selectController,
    this.scrollViewController,
    this.initialDate,
    this.onVisibleDateChanged,
    this.timeWidget,
    this.scrollViewPadding,
    this.weekPadding,
    this.dayBuilder,
    this.monthBuilder,
    this.monthLayoutBuilder,
    this.monthHeightBuilder,
    this.weekWidget,
    this.timeWidgetPadding,
    super.key,
  });

  /// Custom builder for the day widget.
  ///
  /// If set, used instead of the standard `ACCalendarDayWidget`.
  final Widget Function(BuildContext context, DateTime day)? dayBuilder;

  /// Custom builder for the month widget.
  ///
  /// If set, used instead of the standard `ACTitledMonthWidget`.
  /// When `monthBuilder` is provided, the `dayBuilder` parameter is ignored.
  final Widget Function(BuildContext context, DateTime month)? monthBuilder;

  /// Custom builder for the month layout.
  ///
  /// Called for each month, allowing the layout to be set individually.
  /// If not set, the layout is computed automatically.
  final ACMonthLayout Function(BuildContext context, DateTime month)?
      monthLayoutBuilder;

  /// Custom builder for the month height.
  ///
  /// Called for each month, allowing the height to be set individually.
  /// If not set, the height is computed automatically.
  final double Function(BuildContext context, DateTime month)?
      monthHeightBuilder;

  /// Repository for calendar computations.
  ///
  /// If not specified, `ACDefaultCalendarRepository` is used.
  final ACCalendarRepository? repository;

  /// Allowed date range for navigation.
  final ACDateRange range;

  /// Calendar visual theme.
  ///
  /// If not specified, `ACLightCalendarThemeData` is used.
  final ACCalendarThemeData? theme;

  /// Date selection controller.
  ///
  /// If not specified, date selection is not supported.
  final ACCalendarSelectController? selectController;

  /// Scroll controller.
  ///
  /// If not specified, it is created automatically inside the widget.
  final ACScrollViewController<DateTime>? scrollViewController;

  /// Date to scroll to when first opened.
  ///
  /// If not specified or outside [range], the current date
  /// (or the nearest allowed month) is used.
  final DateTime? initialDate;

  /// Called when the visible month changes during scrolling.
  final void Function(DateTime visibleDate)? onVisibleDateChanged;

  /// Widget displayed below the month feed (for example, time input).
  ///
  /// Must implement [PreferredSizeWidget] for correct height calculation.
  final PreferredSizeWidget? timeWidget;

  /// Padding around the month feed.
  final EdgeInsetsGeometry? scrollViewPadding;

  /// Custom weekday row widget.
  ///
  /// If set, used instead of the standard `ACWeekWidget`.
  /// Must implement [PreferredSizeWidget].
  final PreferredSizeWidget? weekWidget;

  /// Padding around the `ACWeekWidget`.
  final EdgeInsetsGeometry? weekPadding;

  /// Padding around the [timeWidget].
  final EdgeInsetsGeometry? timeWidgetPadding;

  @override
  Widget build(BuildContext context) => ACCalendarScope(
        repository: repository ?? const ACDefaultCalendarRepository(),
        dateRange: range,
        selectController: selectController,
        child: ACRawCalendarWidget(
          range: range,
          repository: repository,
          theme: theme,
          scrollViewController: scrollViewController,
          initialDate: initialDate,
          onVisibleDateChanged: onVisibleDateChanged,
          timeWidget: timeWidget,
          scrollViewPadding: scrollViewPadding,
          weekPadding: weekPadding,
          dayBuilder: dayBuilder,
          monthBuilder: monthBuilder,
          monthLayoutBuilder: monthLayoutBuilder,
          monthHeightBuilder: monthHeightBuilder,
          weekWidget: weekWidget,
          timeWidgetPadding: timeWidgetPadding,
        ),
      );
}
