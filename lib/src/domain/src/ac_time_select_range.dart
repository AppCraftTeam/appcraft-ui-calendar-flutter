import 'package:flutter/material.dart';

/// Выбранный пользователем диапазон времени (начало и конец).
///
/// Поддерживает как одиночный выбор (только [start]),
/// так и выбор диапазона ([start] и [end]).
class ACTimeSelectRange {
  /// Создаёт диапазон выбора времени.
  ///
  /// Если передан только [end] без [start], он становится значением [start].
  /// Если [start] не задан, [end] сбрасывается в `null`.
  ACTimeSelectRange({
    TimeOfDay? start,
    TimeOfDay? end,
  }) :
    start = start ?? end,
    end = start != null ? end : null,
    assert(
      start == null || end == null || !end.isBefore(start),
      'end must be >= start',
    );

  /// Внутренний конструктор для прямого задания полей.
  const ACTimeSelectRange._({
    this.start,
    this.end,
  });

  /// Начальное время выбранного диапазона.
  final TimeOfDay? start;

  /// Конечное время выбранного диапазона.
  final TimeOfDay? end;

  /// Возвращает единственное выбранное время (начало или конец),
  /// если выбрано только одно значение.
  TimeOfDay? get single => start ?? end;

  /// `true`, если ни одно время не выбрано.
  bool get isEmpty => single == null;

  /// Создаёт копию с заменой указанных полей.
  ACTimeSelectRange copyWith({
    TimeOfDay? start,
    TimeOfDay? end,
  }) => ACTimeSelectRange._(
    start: start ?? this.start,
    end: end ?? this.end,
  );

  @override
  String toString() => 'ACTimeSelectRange(start: $start, end: $end)';
}
