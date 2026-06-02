import 'package:flutter/material.dart';

import '../../../../../../data/src/ac_calendar_repository.dart';
import '../../../../../../data/src/ac_default_calendar_repository.dart';
import '../../../../../../domain/src/ac_date_range.dart';
import '../../../../ac_calendar_scope.dart';
import '../../../../select_controller/ac_calendar_select_controller.dart';
import '../../../../theme/src/ac_calendar_theme_data.dart';
import '../../month/src/ac_month_layout.dart';
import '../../scroll_view/src/ac_scroll_view_controller.dart';
import '../../scroll_view/src/ac_scroll_view_data_source.dart';
import 'ac_raw_pages_calendar_widget.dart';

/// Calendar with paged navigation by months.
///
/// Displays one month at a time with the ability to scroll horizontally
/// between months within the given [range].
///
/// Includes a header with navigation, a weekday row, and the month's date grid.
/// Tapping the header opens an `ACMonthPicker` for quickly
/// jumping to a desired month.
///
/// Wraps [ACRawPagesCalendarWidget] in an [ACCalendarScope],
/// providing the theme and selection controller to child widgets.
class ACPagesCalendarWidget extends StatelessWidget {
  /// Creates a paged calendar.
  const ACPagesCalendarWidget({
    required this.range,
    this.repository,
    this.locale,
    this.theme,
    this.selectController,
    this.initialMonth,
    this.spacing,
    this.timeWidget,
    this.scrollViewController,
    this.dayBuilder,
    this.monthBuilder,
    this.monthLayout,
    this.monthHeight,
    this.weekWidget,
    this.headerWidget,
    this.scrollViewDataSource,
    super.key,
  });

  /// Custom builder for the day widget.
  ///
  /// If set, used instead of the standard `ACCalendarDayWidget`.
  final Widget Function(BuildContext context, DateTime day)? dayBuilder;

  /// Custom builder for the month widget.
  ///
  /// If set, used instead of the standard `ACMonthWidget`.
  /// When `monthBuilder` is provided, the `dayBuilder` parameter is ignored.
  final Widget Function(BuildContext context, DateTime month)? monthBuilder;

  /// Fixed month grid layout.
  ///
  /// If set, used for all months instead of
  /// [ACDefaultMonthLayout.mainAxisCount6].
  final ACMonthLayout? monthLayout;

  /// Fixed month grid height.
  ///
  /// If set, used instead of the height computed
  /// by `layout.calculateHeight`.
  final double? monthHeight;

  /// Repository for calendar computations.
  ///
  /// If not specified, `ACDefaultCalendarRepository` is used.
  final ACCalendarRepository? repository;

  /// Allowed date range for navigation.
  final ACDateRange range;

  /// Locale for formatting dates (for example, `'ru'`, `'en'`).
  ///
  /// If not specified, the system locale is used.
  final String? locale;

  /// Calendar visual theme.
  ///
  /// If not specified, [ACLightCalendarThemeData] is used.
  final ACCalendarThemeData? theme;

  /// Date selection controller.
  ///
  /// If not specified, date selection is not supported.
  final ACCalendarSelectController? selectController;

  /// Month displayed when the calendar is first opened.
  ///
  /// If not specified or outside [range], the current month
  /// (or the nearest allowed one) is used.
  final DateTime? initialMonth;

  /// Spacing between calendar elements (header, weekday row, date grid).
  ///
  /// If not specified, the default value `12.0` is used.
  final double? spacing;

  /// Widget displayed below the date grid (for example, time input).
  ///
  /// Must implement [PreferredSizeWidget] for correct height calculation.
  final PreferredSizeWidget? timeWidget;

  /// External scroll controller for navigating between months.
  ///
  /// If provided, used instead of the default one.
  /// The caller is responsible for [ACScrollViewController.dispose].
  final ACScrollViewController<DateTime>? scrollViewController;

  /// Custom weekday row widget.
  ///
  /// If set, used instead of the standard `ACWeekWidget`.
  /// Must implement [PreferredSizeWidget].
  final PreferredSizeWidget? weekWidget;

  /// Custom calendar header widget.
  ///
  /// If set, used instead of the standard `ACPagesCalendarHeader`.
  /// Must implement [PreferredSizeWidget].
  final PreferredSizeWidget? headerWidget;

  /// External data source for navigating between months.
  ///
  /// If provided, used instead of the default one.
  /// The caller is responsible for [ACScrollViewDataSource.dispose].
  final ACScrollViewDataSource<DateTime>? scrollViewDataSource;

  @override
  Widget build(BuildContext context) => ACCalendarScope(
        repository: repository ?? const ACDefaultCalendarRepository(),
        dateRange: range,
        selectController: selectController,
        child: ACRawPagesCalendarWidget(
          range: range,
          repository: repository,
          locale: locale,
          theme: theme,
          initialMonth: initialMonth,
          spacing: spacing,
          timeWidget: timeWidget,
          scrollViewController: scrollViewController,
          dayBuilder: dayBuilder,
          monthBuilder: monthBuilder,
          monthLayout: monthLayout,
          monthHeight: monthHeight,
          weekWidget: weekWidget,
          headerWidget: headerWidget,
          scrollViewDataSource: scrollViewDataSource,
        ),
      );
}
