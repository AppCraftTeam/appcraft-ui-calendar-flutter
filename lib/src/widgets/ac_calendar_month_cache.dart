import 'ac_month_layout.dart';

/// Кэшированные данные месяца для оптимизации перерисовки.
class ACCalendarMonthCache {
  /// Создаёт кэшированные данные месяца.
  const ACCalendarMonthCache({
    required this.days,
    required this.layout,
  });

  /// Список дней месяца, включая дни из соседних месяцев.
  final List<DateTime> days;

  /// Компоновка (layout) сетки месяца.
  final ACMonthLayout layout;
}
