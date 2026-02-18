class ACDateRange {
  const ACDateRange({
    required this.min,
    required this.max
  });

  final DateTime min;
  final DateTime max;

  @override
  String toString() => 'ACDateSelectRange(min: $min, max: $max)';

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