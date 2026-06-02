import '../../domain/src/ac_date_range.dart';

/// Abstract repository for calendar calculations.
///
/// Defines the contract for retrieving the days of a month, weekdays,
/// navigating between months and filtering by a date range.
abstract class ACCalendarRepository {
  /// Creates a repository instance.
  const ACCalendarRepository();

  /// The first day of the week (DateTime.monday .. DateTime.sunday).
  int get weekStart;

  /// Returns the list of calendar days for the month [date],
  /// including days from adjacent months that fall into the first
  /// and last weeks.
  List<DateTime> getMonthDays(DateTime date);

  /// Returns the date of the first day of the month for [date].
  DateTime startOfMonth(DateTime date);

  /// Adds [months] months to [date].
  DateTime addMonths(DateTime date, int months);

  /// Returns the list of dates for the current week, starting from
  /// [weekStart].
  List<DateTime> getWeekDays();

  /// Returns the list of available months for [year] within [range].
  List<int> getMonths({required int year, required ACDateRange range});

  /// Returns the list of available years within [range].
  List<int> getYears({required ACDateRange range});
}
