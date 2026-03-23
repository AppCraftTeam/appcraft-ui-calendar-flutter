import '../../domain/src/ac_date_range.dart';

/// Абстрактный репозиторий для вычислений календаря.
///
/// Определяет контракт для получения дней месяца, дней недели,
/// навигации по месяцам и фильтрации по диапазону дат.
abstract class ACCalendarRepository {
  /// Создаёт экземпляр репозитория.
  const ACCalendarRepository();

  /// Первый день недели (DateTime.monday .. DateTime.sunday).
  int get weekStart;

  /// Возвращает список дней календаря для месяца [date],
  /// включая дни из соседних месяцев, попадающие в первую
  /// и последнюю недели.
  List<DateTime> getMonthDays(DateTime date);

  /// Возвращает дату первого дня месяца для [date].
  DateTime startOfMonth(DateTime date);

  /// Прибавляет [months] месяцев к [date].
  DateTime addMonths(DateTime date, int months);

  /// Возвращает список дат текущей недели, начиная с [weekStart].
  List<DateTime> getWeekDays();

  /// Возвращает список доступных месяцев для [year] в пределах [range].
  List<int> getMonths({required int year, required ACDateRange range});

  /// Возвращает список доступных лет в пределах [range].
  List<int> getYears({required ACDateRange range});
}
