/// A date range selected by the user (start and end).
///
/// Supports both a single selection (only [start])
/// and a range selection ([start] and [end]).
class ACDateSelectRange {
  /// Creates a date selection range.
  ///
  /// If only [end] is passed without [start], it becomes the [start] value.
  /// If [start] is not set, [end] is reset to `null`.
  ACDateSelectRange({
    DateTime? start,
    DateTime? end,
  })  : start = start ?? end,
        end = start != null ? end : null,
        assert(
          start == null || end == null || !end.isBefore(start),
          'end must be >= start',
        );

  /// Internal constructor for directly assigning the fields.
  const ACDateSelectRange._({
    this.start,
    this.end,
  });

  /// The start date of the selected range.
  final DateTime? start;

  /// The end date of the selected range.
  final DateTime? end;

  /// Returns the single selected date (start or end),
  /// if only one date is selected.
  DateTime? get single => start ?? end;

  /// `true` if no date is selected.
  bool get isEmpty => single == null;

  /// Creates a copy with the specified fields replaced.
  ACDateSelectRange copyWith({DateTime? start, DateTime? end}) =>
      ACDateSelectRange._(start: start ?? this.start, end: end ?? this.end);

  @override
  String toString() => 'ACDateSelectRange(start: $start, end: $end)';
}
