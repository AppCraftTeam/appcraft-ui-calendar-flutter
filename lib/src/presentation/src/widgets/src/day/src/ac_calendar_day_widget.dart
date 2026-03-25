import 'package:flutter/material.dart';

import '../../../../../../domain/src/ac_day_month_position.dart';
import '../../../../ac_calendar_scope.dart';
import '../../../../theme/src/ac_calendar_theme_data.dart';
import '../../../../theme/src/ac_day_theme_data.dart';
import 'ac_day_widget.dart';

/// "Умный" виджет дня — читает данные из [ACCalendarScope].
///
/// Принимает только [dayDate] и [monthPosition], остальное
/// берёт из scope и подписывается на изменения выделения
/// через [ListenableBuilder].
class ACCalendarDayWidget extends StatelessWidget {
  /// Создаёт «умный» виджет дня.
  const ACCalendarDayWidget({
    required this.dayDate,
    this.monthPosition,
    this.theme,
    super.key,
  });

  /// Дата дня, который отображается в виджете.
  final DateTime dayDate;

  /// Позиция дня относительно отображаемого месяца.
  final ACDayMonthPosition? monthPosition;

  /// Тема дня. Если не задана, берётся из [ACCalendarThemeData].
  final ACDayThemeData? theme;

  @override
  Widget build(BuildContext context) {
    final scope = ACCalendarScope.maybeOf(context);
    final selectController = scope?.selectController;

    final shouldSelect = monthPosition != ACDayMonthPosition.leading &&
        monthPosition != ACDayMonthPosition.trailing &&
        (scope?.shouldSelectDay(dayDate) ?? true);

    final onTap =
        shouldSelect ? () => selectController?.selectDay(dayDate) : null;

    if (selectController != null) {
      return ListenableBuilder(
        listenable: selectController,
        builder: (context, _) => ACDayWidget(
          dayDate: dayDate,
          monthPosition: monthPosition,
          shouldSelect: shouldSelect,
          theme: theme,
          selectState:
              shouldSelect ? selectController.selectStateForDay(dayDate) : null,
          onTap: onTap,
        ),
      );
    }

    return ACDayWidget(
      dayDate: dayDate,
      monthPosition: monthPosition,
      shouldSelect: shouldSelect,
      theme: theme,
      onTap: onTap,
    );
  }
}
