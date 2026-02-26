/// Диапазон дат, ограниченный минимальной и максимальной датой.
class ACDateRange {
  /// Создаёт диапазон дат с заданными границами [min] и [max].
  const ACDateRange({
    required this.min,
    required this.max
  });

  /// Нижняя граница диапазона (самая ранняя допустимая дата).
  final DateTime min;

  /// Верхняя граница диапазона (самая поздняя допустимая дата).
  final DateTime max;

  @override
  String toString() => 'ACDateSelectRange(min: $min, max: $max)';

  /// Ограничивает [date] рамками текущего диапазона.
  ///
  /// Возвращает:
  /// - [min], если [date] раньше нижней границы;
  /// - [max], если [date] позже верхней границы;
  /// - [date] без изменений, если он находится внутри диапазона.
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
