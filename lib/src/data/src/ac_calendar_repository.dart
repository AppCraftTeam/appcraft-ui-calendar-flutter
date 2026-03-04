import '../../domain/domain.dart';

abstract class ACCalendarRepository {
  const ACCalendarRepository();

  /// Первый день недели (DateTime.monday .. DateTime.sunday).
  int get weekStart;

  /// Возвращает список дней календаря для месяца [date],
  /// включая дни из соседних месяцев, попадающие в первую
  /// и последнюю недели.
  List<DateTime> getMonthDays(DateTime date);

  DateTime startOfMonth(DateTime date);

  DateTime addMonths(DateTime date, int months);

  List<DateTime> getWeekDays();

  List<int> getMonths({
    required int year,
    required ACDateRange range
  });

  List<int> getYears({
    required ACDateRange range
  });
}
