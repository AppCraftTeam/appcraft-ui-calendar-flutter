import 'package:flutter/material.dart';

import '../../../../domain/domain.dart';
import '../../../presentation.dart';

class ACDayWidget extends StatelessWidget {
  const ACDayWidget({
    required this.dayDate,
    this.monthPosition,
    this.theme,
    this.onTap,
    super.key,
  });

  /// Дата дня, который отображается в виджете.
  final DateTime dayDate;

  /// Позиция дня относительно отображаемого месяца.
  /// Если [ACDayMonthPosition.leading] или [ACDayMonthPosition.trailing] — день неактивен.
  final ACDayMonthPosition? monthPosition;

  /// Тема дня. Если не указана, берётся из [ACCalendarTheme].
  final ACDayThemeData? theme;

  /// Пользовательский обработчик нажатия.
  /// Имеет приоритет над внутренней логикой выбора.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scope = ACCalendarScope.maybeOf(context);
    final selectController = scope?.selectController;
    final theme = this.theme ?? ACCalendarTheme.of(context).dayTheme;

    final shouldSelect =
      monthPosition != ACDayMonthPosition.leading &&
      monthPosition != ACDayMonthPosition.trailing &&
      (scope?.shouldSelectDay(dayDate) ?? true);

    final onTap = this.onTap ??
      (shouldSelect ? () => selectController?.selectDay(dayDate) : null);

    if (selectController != null) {
      return ListenableBuilder(
        listenable: selectController,
        builder: (context, _) => _buildDay(
          theme: theme,
          shouldSelect: shouldSelect,
          selectState: shouldSelect
            ? selectController.selectStateForDay(dayDate)
            : null,
          onTap: onTap,
        ),
      );
    }

    return _buildDay(
      theme: theme,
      shouldSelect: shouldSelect,
      selectState: null,
      onTap: onTap,
    );
  }

  Widget _buildDay({
    required ACDayThemeData theme,
    required bool shouldSelect,
    required ACDaySelectState? selectState,
    required VoidCallback? onTap,
  }) {
    final backgroundColor = switch (selectState) {
      null => null,
      ACDaySelectState.single => theme.selectedBackgroundColor,
      ACDaySelectState.multi => theme.selectedBackgroundColor,
      ACDaySelectState.startOfRange => theme.selectedBackgroundColor,
      ACDaySelectState.endOfRange => theme.selectedBackgroundColor,
      ACDaySelectState.middleInRange => theme.middleSelectedBackgroudColor,
    };

    final now = DateTime.now();
    final isToday = dayDate.year == now.year &&
      dayDate.month == now.month &&
      dayDate.day == now.day;

    final textStyle = (isToday ? theme.todayTextStyle : theme.textStyle).copyWith(
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
