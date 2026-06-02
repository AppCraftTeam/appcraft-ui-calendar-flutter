import 'package:flutter/material.dart';

import '../../../../../../domain/src/ac_date_range.dart';
import '../../../../ac_calendar_scope.dart';
import '../../../../select_controller/ac_calendar_select_controller.dart';
import '../../../../theme/src/ac_calendar_theme_data.dart';
import '../../scroll_view/src/ac_scroll_view_controller.dart';
import '../../scroll_view/src/ac_scroll_view_data_source.dart';
import 'ac_raw_pages_calendar_widget.dart';

/// Calendar card built on top of `ACPagesCalendarWidget`.
///
/// Displays `ACPagesCalendarWidget` inside a decorated container.
/// If needed, the card's appearance can be overridden via [decoration],
/// or set selectively via [backgroundColor] and [borderRadius].
class ACPagesCalendarCard extends StatelessWidget {
  /// Creates a card with a paged calendar.
  const ACPagesCalendarCard({
    required this.range,
    this.locale,
    this.theme,
    this.selectController,
    this.initialMonth,
    this.spacing,
    this.timeWidget,
    this.scrollViewController,
    this.scrollViewDataSource,
    this.dayBuilder,
    this.padding,
    this.decoration,
    this.borderRadius,
    this.backgroundColor,
    super.key,
  });

  /// Allowed date range for navigation.
  final ACDateRange range;

  /// Locale for formatting dates (for example, `'ru'`, `'en'`).
  final String? locale;

  /// Calendar visual theme.
  final ACCalendarThemeData? theme;

  /// Date selection controller.
  final ACCalendarSelectController? selectController;

  /// Month displayed when first opened.
  final DateTime? initialMonth;

  /// Spacing between calendar elements (header, weekday row, date grid).
  final double? spacing;

  /// Widget displayed below the date grid (for example, time input).
  final PreferredSizeWidget? timeWidget;

  /// External scroll controller for navigating between months.
  ///
  /// If provided, used instead of the default one.
  /// The caller is responsible for [ACScrollViewController.dispose].
  final ACScrollViewController<DateTime>? scrollViewController;

  /// External data source for navigating between months.
  ///
  /// If provided, used instead of the default one.
  /// The caller is responsible for [ACScrollViewDataSource.dispose].
  final ACScrollViewDataSource<DateTime>? scrollViewDataSource;

  /// Custom builder for the day widget.
  ///
  /// If set, used instead of the standard `ACCalendarDayWidget`.
  final Widget Function(BuildContext context, DateTime day)? dayBuilder;

  /// Inner padding of the card.
  ///
  /// If not specified, `EdgeInsets.all(16)` is used.
  final EdgeInsetsGeometry? padding;

  /// Decoration of the card container.
  ///
  /// If provided, takes priority over [backgroundColor] and [borderRadius].
  final BoxDecoration? decoration;

  /// Corner radius of the card.
  ///
  /// Ignored if [decoration] is set.
  /// Defaults to `BorderRadius.all(Radius.circular(16))`.
  final BorderRadius? borderRadius;

  /// Background color of the card.
  ///
  /// Ignored if [decoration] is set.
  /// Defaults to `Colors.white`.
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = backgroundColor ??
        theme?.backgroundColor ??
        ACCalendarThemeExtension.of(context).backgroundColor;

    final effectiveDecoration = decoration ??
        BoxDecoration(
          color: effectiveBackgroundColor,
          borderRadius:
              borderRadius ?? const BorderRadius.all(Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, 4),
            ),
          ],
        );

    return Container(
      decoration: effectiveDecoration,
      padding: padding ?? const EdgeInsets.all(16),
      child: ACCalendarScope(
        dateRange: range,
        selectController: selectController,
        child: ACRawPagesCalendarWidget(
          range: range,
          locale: locale,
          initialMonth: initialMonth,
          spacing: spacing,
          timeWidget: timeWidget,
          scrollViewController: scrollViewController,
          scrollViewDataSource: scrollViewDataSource,
          dayBuilder: dayBuilder,
        ),
      ),
    );
  }
}
