class ACCalendarDay {
  const ACCalendarDay({
    required this.date,
    required this.isCurrentMonth,
  });

  final DateTime date;
  final bool isCurrentMonth;

  @override
  String toString() => '$date | current: $isCurrentMonth';
}