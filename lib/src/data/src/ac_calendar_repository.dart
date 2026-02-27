import '../../domain/domain.dart';

class ACCalendarRepository {
  const ACCalendarRepository();

  /// Возвращает список дней календаря для месяца [date],
  /// включая дни из соседних месяцев, попадающие в первую
  /// и последнюю недели.
  ///
  /// [weekStart] — первый день недели (DateTime.monday .. DateTime.sunday)
  List<DateTime> getMonthDays(
    DateTime date,
    { int? weekStart }
  ) {
    final resolvedWeekStart = weekStart ?? DateTime.monday;

    assert(
      resolvedWeekStart >= DateTime.monday && resolvedWeekStart <= DateTime.sunday,
      'weekStart must be DateTime.monday … DateTime.sunday',
    );

    final firstDayOfMonth = DateTime(date.year, date.month, 1);
    final lastDayOfMonth = DateTime(date.year, date.month + 1, 0);

    final weekEnd = ((resolvedWeekStart + 5) % 7) + 1;

    final start = firstDayOfMonth.subtract(
      Duration(
        days: (firstDayOfMonth.weekday - resolvedWeekStart + 7) % 7,
      ),
    );

    final end = lastDayOfMonth.add(
      Duration(
        days: (weekEnd - lastDayOfMonth.weekday + 7) % 7,
      ),
    );

    final days = <DateTime>[];
    
    for (
      var d = start;
      !d.isAfter(end);
      d = d.add(const Duration(days: 1))
    ) {
      days.add(d);
    }

    return days;
  }

  DateTime startOfMonth(DateTime date) =>
    DateTime(date.year, date.month);

  DateTime addMonths(DateTime date, int months) =>
    DateTime(date.year, date.month + months);

  List<DateTime> getWeekDays({
    int? weekStart
  }) {
    final resolvedWeekStart = weekStart ?? DateTime.monday;

    assert(
      resolvedWeekStart >= DateTime.monday && resolvedWeekStart <= DateTime.sunday,
      'weekStart must be DateTime.monday … DateTime.sunday',
    );

    final now = DateTime.now();

    // Сдвиг до нужного дня начала недели
    final diff = (now.weekday - resolvedWeekStart) % 7;
    final startOfWeek = now.subtract(Duration(days: diff));

    return List.generate(
      7,
      (index) => startOfWeek.add(Duration(
        days: index
      ))
    );
  }

  List<int> getMonths({
    required int year,
    required ACDateRange range
  }) {
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

  List<int> getYears({
    required ACDateRange range
  }) {
    final years = <int>[];

    for (var year = range.min.year; year <= range.max.year; year++) {
      years.add(year);
    }

    return years;
  }
}
