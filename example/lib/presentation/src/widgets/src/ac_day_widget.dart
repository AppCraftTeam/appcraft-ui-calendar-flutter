import 'package:flutter/material.dart';

import '../../../presentation.dart';
// TODO: refactoring
class ACDayWidget extends StatelessWidget {
  const ACDayWidget({
    required this.dayDate,
    this.monthPosition,
    this.shouldSelect,
    this.backgroundColor,
    this.textColor,
    this.textStyle,
    this.decoration,
    this.padding,
    this.shape,
    this.text,
    this.theme,
    this.onTap,
    super.key,
  });

  /// Дата дня, который отображается в виджете
  final DateTime dayDate;

  /// Позиция дня относительно отображаемого месяца.
  /// Если [ACDayMonthPosition.leading] или [ACDayMonthPosition.trailing] — день неактивен.
  final ACDayMonthPosition? monthPosition;

  /// Определяет, должен ли день участвовать в логике выбора и считаться активным
  final bool? shouldSelect;

  /// Цвет фона контейнера.
  /// Имеет приоритет над вычисляемым значением из состояния выбора.
  final Color? backgroundColor;

  /// Цвет текста.
  /// Имеет приоритет над вычисляемым значением из темы.
  final Color? textColor;

  /// Стиль текста.
  /// Имеет приоритет над вычисляемым значением из темы.
  final TextStyle? textStyle;

  /// Декорация контейнера.
  /// Если не указана, создается [BoxDecoration] с [backgroundColor] и [shape]
  final Decoration? decoration;

  /// Внутренние отступы контейнера.
  /// Если не указаны, отступы не применяются
  final EdgeInsetsGeometry? padding;

  /// Форма контейнера.
  /// Если не указана, используется [BoxShape.circle]
  final BoxShape? shape;

  /// Текст для отображения.
  /// Если не указан, отображается день месяца из [dayDate]
  final String? text;

  /// Тема календаря.
  /// Если не указана, используется тема из контекста через [ACCalendarTheme.of]
  final ACDayThemeData? theme;

  /// Пользовательский обработчик нажатия.
  /// Имеет приоритет над внутренней логикой выбора.
  final VoidCallback? onTap;

  bool get _shouldSelect =>
    monthPosition != ACDayMonthPosition.leading &&
    monthPosition != ACDayMonthPosition.trailing &&
    (shouldSelect ?? false);

  @override
  Widget build(BuildContext context) {
    final theme = this.theme ?? ACCalendarTheme.of(context).dayTheme;
    final selectController = ACCalendarSelectionScope.maybeOf(context);

    var backgroundColor = this.backgroundColor;

    if (backgroundColor == null && _shouldSelect) {
      backgroundColor = switch (selectController?.selectStateForDay(dayDate)) {
        null => null,
        ACDaySelectState.single => theme.selectedBackgroundColor,
        ACDaySelectState.multi => theme.selectedBackgroundColor,
        ACDaySelectState.startOfRange => theme.selectedBackgroundColor,
        ACDaySelectState.endOfRange => theme.selectedBackgroundColor,
        ACDaySelectState.middleInRange => theme.middleSelectedBackgroudColor
      };
    }

    var textStyle = this.textStyle;

    if (textStyle == null) {
      final now = DateTime.now();

      final isToday = dayDate.year == now.year &&
        dayDate.month == now.month &&
        dayDate.day == now.day;

      textStyle = isToday ? theme.todayTextStyle : theme.textStyle;
    }

    final textColor = this.textColor ??
      (_shouldSelect ? theme.textColor : theme.inactiveTextColor);

    Widget child = Container(
      padding: padding,
      alignment: Alignment.center,
      decoration: decoration ?? BoxDecoration(
        color: backgroundColor,
        shape: shape ?? BoxShape.circle,
      ),
      child: Text(
        text ?? dayDate.day.toString(),
        style: textStyle.copyWith(
          color: textColor
        ),
      ),
    );

    final onTap = this.onTap ??
      (_shouldSelect ? () => selectController?.selectDay(dayDate) : null);

    if (onTap != null) {
      child = GestureDetector(
        onTap: onTap,
        child: child
      );
    }

    if (selectController != null) {
      return ListenableBuilder(
        listenable: selectController,
        builder: (context, _) => child
      );
    }

    return child;
  }
}
