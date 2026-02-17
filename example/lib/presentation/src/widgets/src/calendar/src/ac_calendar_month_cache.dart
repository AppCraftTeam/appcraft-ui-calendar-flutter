import '../../../../../presentation.dart';

/// Кэшированные данные месяца
class ACCalendarMonthCache {
  const ACCalendarMonthCache({
    required this.days,
    required this.layout,
  });

  final List<DateTime> days;
  final DefaultMonthLayout layout;
}
