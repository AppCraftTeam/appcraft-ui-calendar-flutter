import 'package:flutter/material.dart';

import '../../../../../../domain/src/ac_day_month_position.dart';
import '../../../../../../domain/src/ac_day_select_state.dart';
import '../../../../theme/src/ac_calendar_theme_data.dart';
import '../../../../theme/src/ac_day_theme_data.dart';

/// Виджет отображения одного дня в сетке календаря.
///
/// Отображает номер дня с учётом состояния выделения [selectState],
/// позиции в месяце [monthPosition] и доступности для выбора [shouldSelect].
class ACDayWidget extends StatelessWidget {
  /// Создаёт виджет дня.
  const ACDayWidget({
    required this.dayDate,
    this.shouldSelect,
    this.monthPosition,
    this.theme,
    this.selectState,
    this.onTap,
    super.key,
  });

  /// Дата дня, который отображается в виджете.
  final DateTime dayDate;

  /// Позиция дня относительно отображаемого месяца.
  final ACDayMonthPosition? monthPosition;

  /// Тема дня. Если не указана, берётся из [ACCalendarThemeData].
  final ACDayThemeData? theme;

  /// Можно ли выбрать этот день.
  final bool? shouldSelect;

  /// Текущее состояние выделения дня.
  final ACDaySelectState? selectState;

  /// Обработчик нажатия.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = this.theme ?? ACCalendarThemeExtension.of(context).dayTheme;

    final backgroundColor = switch (selectState) {
      null => null,
      ACDaySelectState.single => theme.selectedBackgroundColor,
      ACDaySelectState.multi => theme.selectedBackgroundColor,
      ACDaySelectState.startOfRange => theme.selectedBackgroundColor,
      ACDaySelectState.endOfRange => theme.selectedBackgroundColor,
      ACDaySelectState.middleInRange => theme.middleSelectedBackgroundColor,
    };

    final shouldSelect = this.shouldSelect ?? true;
    final now = DateTime.now();

    final isToday = dayDate.year == now.year &&
        dayDate.month == now.month &&
        dayDate.day == now.day;

    final textStyle =
        (isToday ? theme.todayTextStyle : theme.textStyle).copyWith(
      color: shouldSelect ? theme.textColor : theme.inactiveTextColor,
    );

    Widget child = Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Text(
        dayDate.day.toString(),
        style: textStyle,
      ),
    );

    if (onTap != null) {
      child = GestureDetector(
        onTap: onTap,
        child: child,
      );
    }

    return child;
  }
}
