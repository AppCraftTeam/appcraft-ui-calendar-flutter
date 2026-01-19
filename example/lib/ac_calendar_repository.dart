import 'package:example/ac_calendar_day.dart';
import 'package:intl/intl.dart';

class ACCalendarRepository {
  const ACCalendarRepository();

  /// Возвращает список дней календаря для месяца [date],
  /// включая дни из соседних месяцев, попадающие в первую
  /// и последнюю недели.
  ///
  /// [weekStart] — первый день недели (DateTime.monday .. DateTime.sunday)
  List<ACCalendarDay> getMonthDays(
    DateTime date, {
    int weekStart = DateTime.monday,
  }) {
    assert(
      weekStart >= DateTime.monday && weekStart <= DateTime.sunday,
      'weekStart must be DateTime.monday … DateTime.sunday',
    );

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

    final days = <ACCalendarDay>[];
    for (DateTime d = start;
        !d.isAfter(end);
        d = d.add(const Duration(days: 1))) {
      days.add(
        ACCalendarDay(
          date: d,
          isCurrentMonth: d.month == date.month,
        ),
      );
    }

    return days;
  }

  DateTime startOfMonth(DateTime date) =>
    DateTime(date.year, date.month);

  DateTime addMonths(DateTime date, int months) =>
      DateTime(date.year, date.month + months);

  bool isSameOrAfter(DateTime a, DateTime b) =>
      !a.isBefore(b);

  bool isSameOrBefore(DateTime a, DateTime b) =>
      !a.isAfter(b);

  List<String> getWeekDaysRu({int weekStart = DateTime.monday}) {
    final now = DateTime.now();

    // Сдвиг до нужного дня начала недели
    final diff = (now.weekday - weekStart) % 7;
    final startOfWeek = now.subtract(Duration(days: diff));

    return List.generate(7, (index) {
      final day = startOfWeek.add(Duration(days: index));
      return DateFormat('EE', 'ru').format(day).toUpperCase();
    });
  }
}
