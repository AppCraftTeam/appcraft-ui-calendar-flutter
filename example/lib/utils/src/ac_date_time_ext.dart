/// Расширение [DateTime] вспомогательными методами для работы с датами.
extension ACDateTimeExt on DateTime {

  /// Сравнивает две даты с точностью до дня, игнорируя время.
  ///
  /// Возвращает `true`, если [year], [month] и [day] совпадают с [another].
  bool equalToDay(DateTime another) =>
    year == another.year &&
    month == another.month &&
    day == another.day;

}
