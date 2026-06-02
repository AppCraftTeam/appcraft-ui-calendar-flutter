/// A date range bounded by a minimum and a maximum date.
class ACDateRange {
  /// Creates a date range with the given bounds [min] and [max].
  const ACDateRange({required this.min, required this.max});

  /// The lower bound of the range (the earliest allowed date).
  final DateTime min;

  /// The upper bound of the range (the latest allowed date).
  final DateTime max;

  @override
  String toString() => 'ACDateSelectRange(min: $min, max: $max)';

  /// Clamps [date] to the bounds of the current range.
  ///
  /// Returns:
  /// - [min], if [date] is before the lower bound;
  /// - [max], if [date] is after the upper bound;
  /// - [date] unchanged, if it is within the range.
  DateTime clampDate(DateTime date) {
    DateTime clampedDate;

    if (date.isBefore(min)) {
      clampedDate = min;
    } else if (date.isAfter(max)) {
      clampedDate = max;
    } else {
      clampedDate = date;
    }

    return clampedDate;
  }
}
