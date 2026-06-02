import 'package:flutter/material.dart';

import '../../../../../../data/src/ac_cache.dart';
import '../../../../../../data/src/ac_calendar_repository.dart';
import '../../../../../../data/src/ac_default_calendar_repository.dart';
import '../../../../../../domain/src/ac_date_range.dart';
import '../../../../ac_calendar_month_cache.dart';
import '../../../../theme/src/ac_calendar_theme_data.dart';
import '../../ac_week_widget.dart';
import '../../month/src/ac_month_layout.dart';
import '../../month/src/ac_titled_month_widget.dart';
import '../../scroll_view/src/ac_scroll_view.dart';
import '../../scroll_view/src/ac_scroll_view_controller.dart';
import '../../scroll_view/src/ac_scroll_view_data_source.dart';

/// Calendar with vertical scrolling by months without ACCalendarScope.
///
/// A low-level widget that does not wrap itself in ACCalendarScope.
/// Used inside ACCalendarWidget and ACCalendarScreen.
class ACRawCalendarWidget extends StatefulWidget {
  /// Creates a calendar with vertical scrolling.
  const ACRawCalendarWidget({
    required this.range,
    this.repository,
    this.scrollViewController,
    this.scrollViewDataSource,
    this.initialDate,
    this.onVisibleDateChanged,
    this.timeWidget,
    this.scrollViewPadding,
    this.theme,
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
  /// If not specified, [ACDefaultCalendarRepository] is used.
  final ACCalendarRepository? repository;

  /// Allowed date range for navigation.
  final ACDateRange range;

  /// Scroll controller.
  ///
  /// If not specified, it is created automatically inside the widget.
  final ACScrollViewController<DateTime>? scrollViewController;

  /// Data source for scrolling by months.
  ///
  /// If not specified, it is created automatically based on [range].
  /// The owner of a provided source is responsible for calling [dispose()].
  final ACScrollViewDataSource<DateTime>? scrollViewDataSource;

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

  /// Calendar visual theme data.
  final ACCalendarThemeData? theme;

  /// Padding around the month feed.
  final EdgeInsetsGeometry? scrollViewPadding;

  /// Custom weekday row widget.
  ///
  /// If set, used instead of the standard [ACWeekWidget].
  /// Must implement [PreferredSizeWidget].
  final PreferredSizeWidget? weekWidget;

  /// Padding around the [ACWeekWidget].
  final EdgeInsetsGeometry? weekPadding;

  /// Padding around the [timeWidget].
  final EdgeInsetsGeometry? timeWidgetPadding;

  @override
  State<ACRawCalendarWidget> createState() => _ACRawCalendarWidgetState();
}

class _ACRawCalendarWidgetState extends State<ACRawCalendarWidget> {
  late final ACCalendarRepository _calendarRepository =
      widget.repository ?? const ACDefaultCalendarRepository();

  /// Month data cache (up to 12 months).
  final _monthDataCache = ACCache<DateTime, ACCalendarMonthCache>(12);

  /// Range of allowed months, normalized to the start of the month.
  late ACDateRange _range;

  /// Current visible month.
  late DateTime _currentMonth;

  /// Controller for vertical scrolling between months.
  late ACScrollViewController<DateTime> _scrollViewController;

  /// Data source for ACScrollView.
  late ACScrollViewDataSource<DateTime> _scrollViewDataSource;

  @override
  void initState() {
    super.initState();

    _range = ACDateRange(
      min: _calendarRepository.startOfMonth(widget.range.min),
      max: _calendarRepository.startOfMonth(widget.range.max),
    );

    _currentMonth = _range.clampDate(
      _calendarRepository.startOfMonth(widget.initialDate ?? DateTime.now()),
    );

    _scrollViewController =
        widget.scrollViewController ?? ACScrollViewController<DateTime>();

    _scrollViewDataSource =
        widget.scrollViewDataSource ?? _createDefaultDataSource();
  }

  /// Creates an internal data source based on the current range.
  ACDefaultScrollViewDataSource<DateTime> _createDefaultDataSource() =>
      ACDefaultScrollViewDataSource<DateTime>(
        initialItem: _currentMonth,
        onBefore: (month) {
          final prev = _calendarRepository.addMonths(month, -1);
          return prev.isBefore(_range.min) ? null : prev;
        },
        onAfter: (month) {
          final next = _calendarRepository.addMonths(month, 1);
          return next.isAfter(_range.max) ? null : next;
        },
      );

  @override
  void didUpdateWidget(ACRawCalendarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.scrollViewController != widget.scrollViewController) {
      if (_scrollViewController != oldWidget.scrollViewController) {
        _scrollViewController.dispose();
      }
      _scrollViewController =
          widget.scrollViewController ?? ACScrollViewController<DateTime>();
    }

    if (oldWidget.scrollViewDataSource != widget.scrollViewDataSource) {
      if (_scrollViewDataSource != oldWidget.scrollViewDataSource) {
        _scrollViewDataSource.dispose();
      }
      _scrollViewDataSource =
          widget.scrollViewDataSource ?? _createDefaultDataSource();
    }

    if (oldWidget.range.min != widget.range.min ||
        oldWidget.range.max != widget.range.max) {
      _range = ACDateRange(
        min: _calendarRepository.startOfMonth(widget.range.min),
        max: _calendarRepository.startOfMonth(widget.range.max),
      );

      _currentMonth = _range.clampDate(_currentMonth);
      _scrollViewController.jumpToItem(_currentMonth);
    }
  }

  @override
  void dispose() {
    if (_scrollViewController != widget.scrollViewController) {
      _scrollViewController.dispose();
    }
    if (_scrollViewDataSource != widget.scrollViewDataSource) {
      _scrollViewDataSource.dispose();
    }
    super.dispose();
  }

  /// Returns cached month data or computes it.
  ACCalendarMonthCache _getMonthCache(DateTime monthDate) =>
      _monthDataCache.putIfAbsent(monthDate, () {
        final days = _calendarRepository.getMonthDays(monthDate);

        final weeksCount = (days.length / 7).toInt();
        final ACMonthLayout layout = switch (weeksCount) {
          4 => ACDefaultMonthLayout.mainAxisCount4,
          5 => ACDefaultMonthLayout.mainAxisCount5,
          6 => ACDefaultMonthLayout.mainAxisCount6,
          _ => ACDefaultMonthLayout(mainAxisCount: weeksCount),
        };

        return ACCalendarMonthCache(days: days, layout: layout);
      });

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final timeWidget = widget.timeWidget;

          double itemExtentBuilder(DateTime monthDate) =>
              widget.monthHeightBuilder?.call(context, monthDate) ??
              (ACTitledMonthWidget.headerHeight +
                  ACTitledMonthWidget.spacing +
                  (widget.monthLayoutBuilder?.call(context, monthDate) ??
                          _getMonthCache(monthDate).layout)
                      .calculateHeight(constraints.maxWidth));

          Widget itemBuilder(BuildContext context, DateTime monthDate) {
            final monthData = _getMonthCache(monthDate);
            final layout =
                widget.monthLayoutBuilder?.call(context, monthDate) ??
                    monthData.layout;
            final height =
                widget.monthHeightBuilder?.call(context, monthDate) ??
                    (ACTitledMonthWidget.headerHeight +
                        ACTitledMonthWidget.spacing +
                        layout.calculateHeight(constraints.maxWidth));

            return SizedBox(
              width: constraints.maxWidth,
              height: height,
              child: RepaintBoundary(
                child: widget.monthBuilder?.call(context, monthDate) ??
                    ACTitledMonthWidget(
                      layout: layout,
                      days: monthData.days,
                      monthDate: monthDate,
                      theme: widget.theme?.titledMonthTheme,
                      dayTheme: widget.theme?.dayTheme,
                      dayBuilder: widget.dayBuilder,
                    ),
              ),
            );
          }

          final scrollView = ACScrollView<DateTime>(
              controller: _scrollViewController,
              dataSource: _scrollViewDataSource,
              spacing: 40,
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              padding: widget.scrollViewPadding ?? EdgeInsets.zero,
              itemExtentBuilder: itemExtentBuilder,
              onVisibleItemChanged: (monthDate) {
                _currentMonth = monthDate;
                widget.onVisibleDateChanged?.call(monthDate);
              },
              itemBuilder: itemBuilder);

          return Column(
            children: [
              Padding(
                padding: widget.weekPadding ?? const EdgeInsets.only(bottom: 8),
                child: widget.weekWidget ??
                    ACWeekWidget(
                      repository: widget.repository,
                      theme: widget.theme?.weekTheme,
                    ),
              ),
              Expanded(child: scrollView),
              if (timeWidget != null)
                Padding(
                  padding:
                      widget.timeWidgetPadding ?? const EdgeInsets.only(top: 8),
                  child: timeWidget,
                ),
            ],
          );
        },
      );
}
