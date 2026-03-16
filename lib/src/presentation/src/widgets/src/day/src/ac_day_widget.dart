import 'package:flutter/material.dart';

import '../../../../../../domain/domain.dart';
import '../../../../theme/theme.dart';

/// Виджет дня
class ACDayWidget extends StatelessWidget {
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

  /// Тема дня. Если не указана, берётся из [ACCalendarTheme].
  final ACDayThemeData? theme;

  /// Можно ли выбрать этот день.
  final bool? shouldSelect;

  /// Текущее состояние выделения дня.
  final ACDaySelectState? selectState;

  /// Обработчик нажатия.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = this.theme ?? ACCalendarTheme.of(context).dayTheme;

    final backgroundColor = switch (selectState) {
      null => null,
      ACDaySelectState.single => theme.selectedBackgroundColor,
      ACDaySelectState.multi => theme.selectedBackgroundColor,
      ACDaySelectState.startOfRange => theme.selectedBackgroundColor,
      ACDaySelectState.endOfRange => theme.selectedBackgroundColor,
      ACDaySelectState.middleInRange => theme.middleSelectedBackgroudColor,
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
