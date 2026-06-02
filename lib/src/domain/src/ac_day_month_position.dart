/// Позиция дня в сетке календаря относительно отображаемого месяца.
enum ACDayMonthPosition {
  /// День принадлежит текущему отображаемому месяцу.
  current,

  /// День принадлежит предыдущему месяцу (ведущие дни сетки).
  leading,

  /// День принадлежит следующему месяцу (завершающие дни сетки).
  trailing;

  /// Определяет позицию дня [day] относительно отображаемого месяца
  /// [monthDate], учитывая только год и месяц (время и день месяца
  /// игнорируются).
  factory ACDayMonthPosition.forDay(DateTime day, DateTime monthDate) {
    final dayMonth = DateTime(day.year, day.month);
    final currentMonth = DateTime(monthDate.year, monthDate.month);
    if (dayMonth.isBefore(currentMonth)) return ACDayMonthPosition.leading;
    if (dayMonth.isAfter(currentMonth)) return ACDayMonthPosition.trailing;
    return ACDayMonthPosition.current;
  }
}
