import 'package:flutter/material.dart';

/// Тема оформления строки дней недели.
abstract class ACWeekThemeData {
  /// Цвет текста дней недели.
  Color get textColor;

  /// Стиль текста дней недели.
  TextStyle get textStyle;

  /// Создаёт копию с изменёнными полями.
  ACWeekThemeData copyWith();

  /// Интерполирует между двумя [ACWeekThemeData].
  static ACWeekThemeData? lerpTheme(
      ACWeekThemeData? a, ACWeekThemeData? b, double t) {
    if (a == null && b == null) return null;
    return ACLightWeekThemeData.raw(
      textColor: Color.lerp(a?.textColor, b?.textColor, t) ??
          b?.textColor ??
          a!.textColor,
      textStyle: TextStyle.lerp(a?.textStyle, b?.textStyle, t) ??
          b?.textStyle ??
          a!.textStyle,
    );
  }
}

/// Светлая реализация [ACWeekThemeData].
class ACLightWeekThemeData implements ACWeekThemeData {
  /// Создаёт светлую тему дней недели с опциональными переопределениями.
  factory ACLightWeekThemeData({Color? textColor, TextStyle? textStyle}) =>
      ACLightWeekThemeData.raw(
          textColor: textColor ?? const Color(0xFFD5DDE7),
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
      ACLightWeekThemeData(textColor: textColor, textStyle: textStyle);
}
