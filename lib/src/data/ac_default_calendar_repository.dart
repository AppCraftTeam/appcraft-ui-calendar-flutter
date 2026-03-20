import '../domain/ac_date_range.dart';

import 'ac_calendar_repository.dart';

/// Реализация [ACCalendarRepository] по умолчанию.
///
/// Поддерживает настройку первого дня недели через [weekStart].
class ACDefaultCalendarRepository extends ACCalendarRepository {
  /// Создаёт репозиторий с указанным первым днём недели [weekStart].
  const ACDefaultCalendarRepository({
    this.weekStart = DateTime.monday,
  }) : assert(
          weekStart >= DateTime.monday && weekStart <= DateTime.sunday,
          'weekStart must be DateTime.monday … DateTime.sunday',
        );

  @override
  final int weekStart;

  @override
  List<DateTime> getMonthDays(DateTime date) {
    final firstDayOfMonth = DateTime(date.year, date.month, 1);
    final lastDayOfMonth = DateTime(date.year, date.month + 1, 0);

    final weekEnd = ((weekStart + 5) % 7) + 1;

    final start = firstDayOfMonth.subtract(
      Duration(
        days: (firstDayOfMonth.weekday - weekStart + 7) % 7,
      ),
    );

    final end = lastDayOfMonth.add(
      Duration(
        days: (weekEnd - lastDayOfMonth.weekday + 7) % 7,
      ),
    );

    final days = <DateTime>[];

    for (var d = start; !d.isAfter(end); d = d.add(const Duration(days: 1))) {
      days.add(d);
    }

    return days;
  }

  @override
  DateTime startOfMonth(DateTime date) => DateTime(date.year, date.month);

  @override
  DateTime addMonths(DateTime date, int months) =>
      DateTime(date.year, date.month + months);

  @override
  List<DateTime> getWeekDays() {
    final now = DateTime.now();

    // Сдвиг до нужного дня начала недели
    final diff = (now.weekday - weekStart) % 7;
    final startOfWeek = now.subtract(Duration(days: diff));

    return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }

  @override
  List<int> getMonths({required int year, required ACDateRange range}) {
    final months = <int>[];

    var startMonth = 1;
    var endMonth = 12;

    // Если это минимальный год, начинаем с минимального месяца
    if (year == range.min.year) {
      startMonth = range.min.month;
    }

    // Если это максимальный год, заканчиваем максимальным месяцем
    if (year == range.max.year) {
      endMonth = range.max.month;
    }

    for (var month = startMonth; month <= endMonth; month++) {
      months.add(month);
    }

    return months;
  }

  @override
  List<int> getYears({required ACDateRange range}) {
    final years = <int>[];

    for (var year = range.min.year; year <= range.max.year; year++) {
      years.add(year);
    }

    return years;
  }
}
