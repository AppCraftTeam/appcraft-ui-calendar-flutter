/// Extension on [DateTime] with helper methods for working with dates.
extension ACDateTimeExt on DateTime {
  /// Compares two dates with day precision, ignoring the time.
  ///
  /// Returns `true` if [year], [month] and [day] match those of [another].
  bool equalToDay(DateTime another) =>
      year == another.year && month == another.month && day == another.day;
}
