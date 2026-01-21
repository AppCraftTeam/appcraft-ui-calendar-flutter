extension ACDateTimeExt on DateTime {

  bool equalToDay(DateTime another) =>
    year == another.year &&
    month == another.month &&
    day == another.day;

}