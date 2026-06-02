/// Position of a day in the calendar grid relative to the displayed month.
enum ACDayMonthPosition {
  /// The day belongs to the currently displayed month.
  current,

  /// The day belongs to the previous month (leading grid days).
  leading,

  /// The day belongs to the next month (trailing grid days).
  trailing;

  /// Determines the position of the day [day] relative to the displayed
  /// month [monthDate], considering only the year and month (time and
  /// day of month are ignored).
  factory ACDayMonthPosition.forDay(DateTime day, DateTime monthDate) {
    final dayMonth = DateTime(day.year, day.month);
    final currentMonth = DateTime(monthDate.year, monthDate.month);
    if (dayMonth.isBefore(currentMonth)) return ACDayMonthPosition.leading;
    if (dayMonth.isAfter(currentMonth)) return ACDayMonthPosition.trailing;
    return ACDayMonthPosition.current;
  }
}
