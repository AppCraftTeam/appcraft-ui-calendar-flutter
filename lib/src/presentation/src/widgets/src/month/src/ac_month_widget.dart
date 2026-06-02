import 'package:flutter/material.dart';

import '../../../../../../domain/src/ac_day_month_position.dart';
import '../../../../theme/src/ac_calendar_theme_data.dart';
import '../../../../theme/src/ac_day_theme_data.dart';
import '../../day/src/ac_calendar_day_widget.dart';
import 'ac_month_layout.dart';

/// Виджет сетки дней месяца.
///
/// Размещает дни в сетке через [CustomMultiChildLayout] с использованием
/// переданного [layout]. Каждый день отображается через [ACCalendarDayWidget].
class ACMonthWidget extends StatelessWidget {
  /// Создаёт виджет сетки месяца.
  const ACMonthWidget({
    required this.layout,
    required this.days,
    required this.monthDate,
    this.dayTheme,
    this.dayBuilder,
    super.key,
  });

  /// Компоновка (layout) месяца, определяющая расположение элементов в сетке
  final ACMonthLayout layout;

  /// Список дней для отображения в сетке месяца,
  /// включая дни из соседних месяцев для заполнения первой и последней недель
  final List<DateTime> days;

  /// Первый день отображаемого месяца — используется для вычисления позиции каждого дня
  final DateTime monthDate;

  /// Тема дня. Если не задана, берётся из [ACCalendarThemeData].
  final ACDayThemeData? dayTheme;

  /// Кастомный builder для виджета дня.
  ///
  /// Если задан, используется вместо стандартного [ACCalendarDayWidget].
  final Widget Function(BuildContext context, DateTime day)? dayBuilder;

  @override
  Widget build(BuildContext context) => CustomMultiChildLayout(
        delegate: layout,
        children: [
          for (int i = 0; i < days.length; i++)
            LayoutId(
              id: i,
              child: dayBuilder?.call(context, days[i]) ??
                  ACCalendarDayWidget(
                    dayDate: days[i],
                    monthPosition:
                        ACDayMonthPosition.forDay(days[i], monthDate),
                    theme: dayTheme,
                  ),
            ),
        ],
      );
}
