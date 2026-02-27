/// Выбранный пользователем диапазон дат (начало и конец).
///
/// Поддерживает как одиночный выбор (только [start]),
/// так и выбор диапазона ([start] и [end]).
class ACDateSelectRange {
  /// Создаёт диапазон выбора дат.
  ///
  /// Если передан только [end] без [start], он становится значением [start].
  /// Если [start] не задан, [end] сбрасывается в `null`.
  ACDateSelectRange({
    DateTime? start,
    DateTime? end,
  }) :
    start = start ?? end,
    end = start != null ? end : null,
    assert(
      start == null || end == null || !end.isBefore(start),
      'end must be >= start',
    );

  /// Внутренний конструктор для прямого задания полей.
  const ACDateSelectRange._({
    this.start,
    this.end,
  });

  /// Начальная дата выбранного диапазона.
  final DateTime? start;

  /// Конечная дата выбранного диапазона.
  final DateTime? end;

  /// Возвращает единственную выбранную дату (начало или конец),
  /// если выбрана только одна дата.
  DateTime? get single => start ?? end;

  /// `true`, если ни одна дата не выбрана.
  bool get isEmpty => single == null;

  /// Создаёт копию с заменой указанных полей.
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
