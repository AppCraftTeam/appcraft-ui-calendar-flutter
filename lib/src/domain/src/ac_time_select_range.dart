import 'package:flutter/material.dart';

/// A time range selected by the user (start and end).
///
/// Supports both a single selection (only [start])
/// and a range selection ([start] and [end]).
class ACTimeSelectRange {
  /// Creates a time selection range.
  ///
  /// If only [end] is passed without [start], it becomes the [start] value.
  /// If [start] is not set, [end] is reset to `null`.
  ACTimeSelectRange({
    TimeOfDay? start,
    TimeOfDay? end,
  })  : start = start ?? end,
        end = start != null ? end : null,
        assert(
          start == null || end == null || !end.isBefore(start),
          'end must be >= start',
        );

  /// Internal constructor for directly assigning the fields.
  const ACTimeSelectRange._({
    this.start,
    this.end,
  });

  /// The start time of the selected range.
  final TimeOfDay? start;

  /// The end time of the selected range.
  final TimeOfDay? end;

  /// Returns the single selected time (start or end),
  /// if only one value is selected.
  TimeOfDay? get single => start ?? end;

  /// `true` if no time is selected.
  bool get isEmpty => single == null;

  /// Creates a copy with the specified fields replaced.
  ACTimeSelectRange copyWith({
    TimeOfDay? start,
    TimeOfDay? end,
  }) =>
      ACTimeSelectRange._(
        start: start ?? this.start,
        end: end ?? this.end,
      );

  @override
  String toString() => 'ACTimeSelectRange(start: $start, end: $end)';
}
