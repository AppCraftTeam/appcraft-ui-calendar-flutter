import 'package:flutter/material.dart';

import '../../../../../../domain/src/ac_date_range.dart';
import '../../../../ac_calendar_scope.dart';
import '../../../../select_controller/ac_calendar_select_controller.dart';
import '../../../../theme/src/ac_calendar_theme_data.dart';
import '../../month/src/ac_month_layout.dart';
import '../../month_picker/src/ac_month_picker_sheet.dart';
import '../../scroll_view/src/ac_scroll_view_controller.dart';
import 'ac_raw_calendar_widget.dart';

/// Screen with a vertical calendar.
///
/// Wraps `ACCalendarWidget` in a [Scaffold] with an [AppBar],
/// which displays the current year of the visible month.
/// The year updates automatically during scrolling via [onVisibleDateChanged].
class ACCalendarScreen extends StatefulWidget {
  /// Creates a screen with a vertical calendar.
  const ACCalendarScreen({
    required this.range,
    this.theme,
    this.selectController,
    this.initialDate,
    this.onVisibleDateChanged,
    this.timeWidget,
    this.scrollViewPadding,
    this.weekPadding,
    this.timeWidgetPadding,
    this.dayBuilder,
    this.monthBuilder,
    this.monthLayoutBuilder,
    this.monthHeightBuilder,
    this.weekWidget,
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

  /// Allowed date range for navigation.
  final ACDateRange range;

  /// Calendar visual theme.
  final ACCalendarThemeData? theme;

  /// Date selection controller.
  final ACCalendarSelectController? selectController;

  /// Date to scroll to when first opened.
  final DateTime? initialDate;

  /// Called when the visible month changes during scrolling.
  final void Function(DateTime visibleDate)? onVisibleDateChanged;

  /// Widget displayed below the month feed (for example, time input).
  final PreferredSizeWidget? timeWidget;

  /// Padding around the month feed.
  final EdgeInsetsGeometry? scrollViewPadding;

  /// Padding around the weekday row.
  final EdgeInsetsGeometry? weekPadding;

  /// Padding around the [timeWidget].
  final EdgeInsetsGeometry? timeWidgetPadding;

  /// Custom weekday row widget.
  ///
  /// If set, used instead of the standard `ACWeekWidget`.
  /// Must implement [PreferredSizeWidget].
  final PreferredSizeWidget? weekWidget;

  @override
  State<ACCalendarScreen> createState() => _ACCalendarScreenState();
}

class _ACCalendarScreenState extends State<ACCalendarScreen> {
  late DateTime _currentDate;

  final _scrollViewController = ACScrollViewController<DateTime>();

  @override
  void initState() {
    super.initState();
    _currentDate = widget.initialDate ?? DateTime.now();
  }

  void _onVisibleDateChanged(DateTime date) {
    if (_currentDate != date) {
      setState(() => _currentDate = date);
    }
    widget.onVisibleDateChanged?.call(date);
  }

  @override
  Widget build(BuildContext context) {
    const titleStyle = TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 22,
    );

    final backgroundColor = widget.theme?.backgroundColor ??
        ACCalendarThemeExtension.of(context).backgroundColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: backgroundColor,
        title: GestureDetector(
          onTap: () => ACMonthPickerSheet.show(
            context,
            range: widget.range,
            initialDate: _currentDate,
            theme: widget.theme,
            onDone: (date) {
              _onVisibleDateChanged(date);
              _scrollViewController.jumpToItem(date);
            },
          ),
          child: Text('${_currentDate.year}', style: titleStyle),
        ),
      ),
      body: SafeArea(
        child: ACCalendarScope(
          dateRange: widget.range,
          selectController: widget.selectController,
          child: ACRawCalendarWidget(
            scrollViewController: _scrollViewController,
            range: widget.range,
            theme: widget.theme,
            initialDate: widget.initialDate,
            onVisibleDateChanged: _onVisibleDateChanged,
            timeWidget: widget.timeWidget,
            scrollViewPadding: widget.scrollViewPadding ??
                const EdgeInsets.symmetric(horizontal: 16),
            weekPadding: widget.weekPadding ??
                const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            dayBuilder: widget.dayBuilder,
            monthBuilder: widget.monthBuilder,
            monthLayoutBuilder: widget.monthLayoutBuilder,
            monthHeightBuilder: widget.monthHeightBuilder,
            weekWidget: widget.weekWidget,
            timeWidgetPadding: widget.timeWidgetPadding ??
                const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          ),
        ),
      ),
    );
  }
}
