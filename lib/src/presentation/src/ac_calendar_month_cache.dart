import 'widgets/src/month/src/ac_month_layout.dart';

/// Cached month data used to optimize repainting.
class ACCalendarMonthCache {
  /// Creates cached month data.
  const ACCalendarMonthCache({
    required this.days,
    required this.layout,
  });

  /// List of days of the month, including days from adjacent months.
  final List<DateTime> days;

  /// Layout of the month grid.
  final ACMonthLayout layout;
}
