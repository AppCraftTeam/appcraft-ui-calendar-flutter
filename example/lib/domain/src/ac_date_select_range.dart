class ACDateSelectRange {
  const ACDateSelectRange({
    DateTime? start,
    DateTime? end,
  }) :
    start = start ?? end,
    end = start != null ? end : null;

  const ACDateSelectRange._({
    this.start,
    this.end,
  });

  final DateTime? start;
  final DateTime? end;

  DateTime? get single => start ?? end;

  bool get isEmpty => single == null;

  ACDateSelectRange copyWith({
    DateTime? start,
    DateTime? end
  }) => ACDateSelectRange._(
    start: start ?? this.start,
    end: end ?? this.end
  );

  @override
  String toString() => 'ACDateSelectRange(start: $start, end: $end)';
}