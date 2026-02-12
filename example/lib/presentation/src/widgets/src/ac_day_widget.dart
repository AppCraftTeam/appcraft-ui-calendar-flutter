import 'package:flutter/material.dart';

import '../../../presentation.dart';

class ACDayWidget extends StatelessWidget {
  const ACDayWidget({
    required this.dayDate,
    this.backgroundColor,
    this.textColor,
    this.textStyle,
    this.decoration,
    this.padding,
    this.shape,
    this.text,
    this.theme,
    this.onTap,
    super.key
  });

  /// Дата дня, который отображается в виджете
  final DateTime dayDate;

  /// Цвет фона контейнера.
  /// Если не указан, используется прозрачный фон
  final Color? backgroundColor;

  /// Цвет текста.
  /// Если не указан, используется значение из темы [ACDayThemeData.textColor]
  final Color? textColor;

  /// Стиль текста.
  /// Если не указан, используется значение из темы [ACDayThemeData.textStyle]
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

  /// Обработчик нажатия на виджет
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = this.theme ?? ACCalendarTheme.of(context).dayTheme;

    final resolvedTextStyle = textStyle ?? theme.textStyle;
    final resolvedTextColor = textColor ?? theme.textColor;
    final resolvedText = text ?? dayDate.day.toString();

    final resolvedDecoration = decoration ?? BoxDecoration(
      color: backgroundColor,
      shape: shape ?? BoxShape.circle
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        alignment: Alignment.center,
        decoration: resolvedDecoration,
        child: Text(
          resolvedText,
          style: resolvedTextStyle.copyWith(
            color: resolvedTextColor,
          )
        ),
      ),
    );
  }
}