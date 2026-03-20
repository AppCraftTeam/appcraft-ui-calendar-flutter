import 'package:flutter/material.dart';

import '../domain/ac_day_month_position.dart';
import 'ac_calendar_day_widget.dart';
import 'ac_month_layout.dart';

class ACMonthWidget extends StatelessWidget {
  const ACMonthWidget({
    required this.layout,
    required this.days,
    required this.monthDate,
    super.key,
  });

  /// Компоновка (layout) месяца, определяющая расположение элементов в сетке
  final ACMonthLayout layout;

  /// Список дней для отображения в сетке месяца,
  /// включая дни из соседних месяцев для заполнения первой и последней недель
  final List<DateTime> days;

  /// Первый день отображаемого месяца — используется для вычисления позиции каждого дня
  final DateTime monthDate;

  ACDayMonthPosition _positionFor(DateTime day) {
    final dayMonth = DateTime(day.year, day.month);
    final currentMonth = DateTime(monthDate.year, monthDate.month);
    if (dayMonth.isBefore(currentMonth)) return ACDayMonthPosition.leading;
    if (dayMonth.isAfter(currentMonth)) return ACDayMonthPosition.trailing;
    return ACDayMonthPosition.current;
  }

  @override
  Widget build(BuildContext context) => CustomMultiChildLayout(
        delegate: layout,
        children: [
          for (int i = 0; i < days.length; i++)
            LayoutId(
              id: i,
              child: ACCalendarDayWidget(
                dayDate: days[i],
                monthPosition: _positionFor(days[i]),
              ),
            ),
        ],
      );
}
