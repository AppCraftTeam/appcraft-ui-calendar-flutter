import 'package:flutter/material.dart';

/// Тема оформления виджета ввода времени.
abstract class ACTimeInputThemeData {
  /// Стиль текста.
  TextStyle get textStyle;

  /// Цвет текста.
  Color get textColor;

  /// Цвет подсказки.
  Color get hintColor;

  /// Цвет курсора.
  Color get cursorColor;

  /// Цвет фона.
  Color get backgroundColor;

  /// Создаёт копию с изменёнными полями.
  ACTimeInputThemeData copyWith();

  /// Интерполирует между двумя [ACTimeInputThemeData].
  static ACTimeInputThemeData? lerpTheme(
      ACTimeInputThemeData? a, ACTimeInputThemeData? b, double t) {
    if (a == null && b == null) return null;
    return ACLightTimeInputThemeData.raw(
      textStyle: TextStyle.lerp(a?.textStyle, b?.textStyle, t) ??
          b?.textStyle ??
          a!.textStyle,
      textColor: Color.lerp(a?.textColor, b?.textColor, t) ??
          b?.textColor ??
          a!.textColor,
      hintColor: Color.lerp(a?.hintColor, b?.hintColor, t) ??
          b?.hintColor ??
          a!.hintColor,
      cursorColor: Color.lerp(a?.cursorColor, b?.cursorColor, t) ??
          b?.cursorColor ??
          a!.cursorColor,
      backgroundColor: Color.lerp(a?.backgroundColor, b?.backgroundColor, t) ??
          b?.backgroundColor ??
          a!.backgroundColor,
    );
  }
}

/// Светлая реализация [ACTimeInputThemeData].
class ACLightTimeInputThemeData implements ACTimeInputThemeData {
  /// Создаёт светлую тему ввода времени с опциональными переопределениями.
  factory ACLightTimeInputThemeData({
    TextStyle? textStyle,
    Color? textColor,
    Color? hintColor,
    Color? cursorColor,
    Color? backgroundColor,
  }) =>
      ACLightTimeInputThemeData.raw(
        textStyle: textStyle ??
            const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 17,
              height: 17 / 22,
            ),
        textColor: textColor ?? const Color(0xFF000000),
        hintColor: hintColor ?? const Color(0xFF9A99A2),
        cursorColor: cursorColor ?? const Color(0xFF232326),
        backgroundColor: backgroundColor ?? const Color(0x1F767680),
      );

  /// Создаёт светлую тему ввода времени с явно заданными значениями.
  const ACLightTimeInputThemeData.raw({
    required this.textStyle,
    required this.textColor,
    required this.hintColor,
    required this.cursorColor,
    required this.backgroundColor,
  });

  @override
  final TextStyle textStyle;

  @override
  final Color textColor;

  @override
  final Color hintColor;

  @override
  final Color cursorColor;

  @override
  final Color backgroundColor;

  @override
  ACLightTimeInputThemeData copyWith({
    TextStyle? textStyle,
    Color? textColor,
    Color? hintColor,
    Color? cursorColor,
    Color? backgroundColor,
  }) =>
      ACLightTimeInputThemeData(
        textStyle: textStyle ?? this.textStyle,
        textColor: textColor ?? this.textColor,
        hintColor: hintColor ?? this.hintColor,
        cursorColor: cursorColor ?? this.cursorColor,
        backgroundColor: backgroundColor ?? this.backgroundColor,
      );
}
