import 'package:flutter/material.dart';

/// Тема оформления строки дней недели.
abstract class ACWeekThemeData {
  /// Цвет текста дней недели.
  Color get textColor;

  /// Стиль текста дней недели.
  TextStyle get textStyle;

  /// Создаёт копию с изменёнными полями.
  ACWeekThemeData copyWith();

  /// Интерполирует между текущим и [other] при параметре [t].
  ACWeekThemeData lerp(ACWeekThemeData? other, double t);
}

/// Светлая реализация [ACWeekThemeData].
class ACLightWeekThemeData implements ACWeekThemeData {
  /// Создаёт светлую тему дней недели с опциональными переопределениями.
  factory ACLightWeekThemeData({Color? textColor, TextStyle? textStyle}) =>
      ACLightWeekThemeData.raw(
          textColor: textColor ?? const Color(0xFF6B7280),
          textStyle: textStyle ??
              const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  height: 13 / 18,
                  letterSpacing: -.08));

  /// Создаёт светлую тему дней недели с явно заданными значениями.
  const ACLightWeekThemeData.raw(
      {required this.textColor, required this.textStyle});

  @override
  final Color textColor;

  @override
  final TextStyle textStyle;

  @override
  ACLightWeekThemeData copyWith({Color? textColor, TextStyle? textStyle}) =>
      ACLightWeekThemeData(
          textColor: textColor ?? this.textColor,
          textStyle: textStyle ?? this.textStyle);

  @override
  ACLightWeekThemeData lerp(ACWeekThemeData? other, double t) {
    if (other == null) return this;
    return ACLightWeekThemeData.raw(
      textColor: Color.lerp(textColor, other.textColor, t) ?? textColor,
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t) ?? textStyle,
    );
  }
}
