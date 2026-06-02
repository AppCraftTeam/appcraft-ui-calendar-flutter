import 'package:flutter/material.dart';

import '../../../../../../data/src/ac_cache.dart';
import '../../../../../../data/src/ac_calendar_repository.dart';
import '../../../../../../data/src/ac_default_calendar_repository.dart';
import '../../../../../../domain/src/ac_date_range.dart';
import '../../../../theme/src/ac_calendar_theme_data.dart';
import '../../ac_week_widget.dart';
import '../../month/src/ac_month_layout.dart';
import '../../month/src/ac_month_widget.dart';
import '../../month_picker/src/ac_month_picker.dart';
import '../../scroll_view/src/ac_scroll_view.dart';
import '../../scroll_view/src/ac_scroll_view_controller.dart';
import '../../scroll_view/src/ac_scroll_view_data_source.dart';
import 'ac_pages_calendar_header.dart';

/// Calendar with paged navigation by months without ACCalendarScope.
///
/// A low-level widget that does not wrap itself in ACCalendarScope.
/// Used inside ACPagesCalendarWidget and ACPagesCalendarSheet.
class ACRawPagesCalendarWidget extends StatefulWidget {
  /// Creates a calendar with paged navigation.
  const ACRawPagesCalendarWidget({
    required this.range,
    this.scrollViewController,
    this.scrollViewDataSource,
    this.repository,
    this.locale,
    this.initialMonth,
    this.spacing,
    this.theme,
    this.dayBuilder,
    this.monthBuilder,
    this.monthLayout,
    this.monthHeight,
    this.weekWidget,
    this.headerWidget,
    this.timeWidget,
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
  /// If not specified, [ACDefaultCalendarRepository] is used.
  final ACCalendarRepository? repository;

  /// Allowed date range for navigation.
  final ACDateRange range;

  /// Locale for formatting dates (for example, `'ru'`, `'en'`).
  ///
  /// If not specified, the system locale is used.
  final String? locale;

  /// Month displayed when the calendar is first opened.
  ///
  /// If not specified or outside [range], the current month
  /// (or the nearest allowed one) is used.
  final DateTime? initialMonth;

  /// Spacing between calendar elements (header, weekday row, date grid).
  ///
  /// If not specified, the default value `12.0` is used.
  final double? spacing;

  /// Custom weekday row widget.
  ///
  /// If set, used instead of the standard [ACWeekWidget].
  /// Must implement [PreferredSizeWidget].
  final PreferredSizeWidget? weekWidget;

  /// Custom calendar header widget.
  ///
  /// If set, used instead of the standard [ACPagesCalendarHeader].
  /// Must implement [PreferredSizeWidget].
  final PreferredSizeWidget? headerWidget;

  /// Calendar visual theme data.
  final ACCalendarThemeData? theme;

  /// Widget displayed below the date grid (for example, time input).
  ///
  /// Must implement [PreferredSizeWidget] for correct height calculation.
  final PreferredSizeWidget? timeWidget;

  /// External scroll controller for navigating between months.
  ///
  /// If provided, the widget uses it instead of creating an internal one.
  /// The caller is responsible for calling [ACScrollViewController.dispose].
  final ACScrollViewController<DateTime>? scrollViewController;

  /// External data source for the [ACScrollView].
  ///
  /// If provided, the widget uses it instead of creating an internal one.
  /// The caller is responsible for calling [ACScrollViewDataSource.dispose].
  final ACScrollViewDataSource<DateTime>? scrollViewDataSource;

  /// Returns the preferred widget height for the given [width].
  ///
  /// Used for dynamically computing the height of `ACPagesCalendarSheet`
  /// without hardcoding. Accounts for the header, weekday row, date grid,
  /// and the optional [timeWidget].
  static double preferredHeight(
    double width, {
    double spacing = 12.0,
    PreferredSizeWidget? timeWidget,
    EdgeInsets padding = const EdgeInsets.all(16),
  }) {
    const headerHeight = 40.0;
    const weekHeight = 24.0;
    final effectiveWidth = width - padding.horizontal;
    final monthHeight =
        ACDefaultMonthLayout.mainAxisCount6.calculateHeight(effectiveWidth);

    final contentHeight = weekHeight +
        spacing +
        monthHeight +
        (timeWidget != null ? spacing + timeWidget.preferredSize.height : 0);

    return headerHeight + spacing + contentHeight + padding.vertical;
  }

  @override
  State<ACRawPagesCalendarWidget> createState() =>
      _ACRawPagesCalendarWidgetState();
}

class _ACRawPagesCalendarWidgetState extends State<ACRawPagesCalendarWidget> {
  late final ACCalendarRepository _repository =
      widget.repository ?? const ACDefaultCalendarRepository();

  /// Cache of day lists for each month (the last 12 months).
  final _daysCache = ACCache<DateTime, List<DateTime>>(12);

  ACMonthLayout get _layout =>
      widget.monthLayout ?? ACDefaultMonthLayout.mainAxisCount6;

  /// Range of allowed months, normalized to the start of the month.
  late ACDateRange _range;

  /// Current visible month.
  late DateTime _currentMonth;

  /// Controller for horizontal scrolling between months.
  late ACScrollViewController<DateTime> _scrollViewController;

  /// Data source for ACScrollView.
  late ACScrollViewDataSource<DateTime> _scrollViewDataSource;

  /// Flag for showing the month picker instead of the date grid.
  var _monthPickerShow = false;

  @override
  void initState() {
    super.initState();

    _range = ACDateRange(
      min: _repository.startOfMonth(widget.range.min),
      max: _repository.startOfMonth(widget.range.max),
    );

    _currentMonth = _range.clampDate(
      _repository.startOfMonth(widget.initialMonth ?? DateTime.now()),
    );

    _scrollViewController =
        widget.scrollViewController ?? ACScrollViewController<DateTime>();

    _scrollViewDataSource = widget.scrollViewDataSource ??
        ACDefaultScrollViewDataSource<DateTime>(
          initialItem: _currentMonth,
          onBefore: (month) {
            final prev = _repository.addMonths(month, -1);
            return prev.isBefore(_range.min) ? null : prev;
          },
          onAfter: (month) {
            final next = _repository.addMonths(month, 1);
            return next.isAfter(_range.max) ? null : next;
          },
        );
  }

  @override
  void didUpdateWidget(ACRawPagesCalendarWidget oldWidget) {
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
      _scrollViewDataSource = widget.scrollViewDataSource ??
          ACDefaultScrollViewDataSource<DateTime>(
            initialItem: _currentMonth,
            onBefore: (month) {
              final prev = _repository.addMonths(month, -1);
              return prev.isBefore(_range.min) ? null : prev;
            },
            onAfter: (month) {
              final next = _repository.addMonths(month, 1);
              return next.isAfter(_range.max) ? null : next;
            },
          );
    }

    if (widget.range.min != oldWidget.range.min ||
        widget.range.max != oldWidget.range.max) {
      _range = ACDateRange(
        min: _repository.startOfMonth(widget.range.min),
        max: _repository.startOfMonth(widget.range.max),
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

  /// Returns the list of dates to display in the grid for [monthDate].
  ///
  /// The result is cached to avoid recomputation on rebuilds.
  List<DateTime> _getDays(DateTime monthDate) => _daysCache.putIfAbsent(
        monthDate,
        () => _repository.getMonthDays(monthDate),
      );

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final spacing = widget.spacing ?? 12.0;
          final monthWidth = constraints.maxWidth;
          final monthHeight =
              widget.monthHeight ?? _layout.calculateHeight(monthWidth);

          final weekWidget = widget.weekWidget ??
              ACWeekWidget(
                repository: widget.repository,
                locale: widget.locale,
                theme: widget.theme?.weekTheme,
              );

          final headerWidget = widget.headerWidget ??
              ACPagesCalendarHeader(
                monthDate: _currentMonth,
                locale: widget.locale,
                monthPickerShow: _monthPickerShow,
                theme: widget.theme?.pagesCalendarHeaderTheme,
                onPrevious: _scrollViewDataSource.shouldBefore
                    ? _scrollViewController.animateToBeforeItem
                    : null,
                onNext: _scrollViewDataSource.shouldAfter
                    ? _scrollViewController.animateToAfterItem
                    : null,
                onMonthTap: () => setState(() {
                  _monthPickerShow = !_monthPickerShow;
                }),
              );

          Widget scrollView() => SizedBox(
                width: monthWidth,
                height: monthHeight,
                child: ACScrollView<DateTime>(
                  physics: const PageScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  controller: _scrollViewController,
                  dataSource: _scrollViewDataSource,
                  itemExtentBuilder: (_) => monthWidth,
                  onVisibleItemChanged: (monthDate) => setState(() {
                    _currentMonth = monthDate;
                  }),
                  itemBuilder: (context, monthDate) => SizedBox(
                    width: monthWidth,
                    height: monthHeight,
                    child: RepaintBoundary(
                      child: widget.monthBuilder?.call(context, monthDate) ??
                          ACMonthWidget(
                            dayTheme: widget.theme?.dayTheme,
                            layout: _layout,
                            days: _getDays(monthDate),
                            monthDate: monthDate,
                            dayBuilder: widget.dayBuilder,
                          ),
                    ),
                  ),
                ),
              );

          Widget monthPicker() => ACMonthPicker(
                repository: widget.repository,
                range: _range,
                onDateChanged: _scrollViewController.jumpToItem,
                initialDate: _currentMonth,
                locale: widget.locale,
                theme: widget.theme,
              );

          final timeWidget = widget.timeWidget;

          final contentHeight = [
            weekWidget.preferredSize.height,
            spacing,
            monthHeight,
            if (timeWidget != null) ...[
              spacing,
              timeWidget.preferredSize.height,
            ],
          ].fold<double>(0, (sum, v) => sum + v);

          return Column(
            spacing: spacing,
            children: [
              headerWidget,
              SizedBox(
                height: contentHeight,
                child: _monthPickerShow
                    ? monthPicker()
                    : Column(
                        spacing: spacing,
                        children: [
                          weekWidget,
                          scrollView(),
                          if (timeWidget != null) timeWidget
                        ],
                      ),
              )
            ],
          );
        },
      );
}
