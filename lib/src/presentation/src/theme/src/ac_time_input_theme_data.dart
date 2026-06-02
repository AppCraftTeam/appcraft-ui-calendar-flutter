import 'package:flutter/material.dart';

/// Theme data for the time input widget.
abstract class ACTimeInputThemeData {
  /// Text style.
  TextStyle get textStyle;

  /// Text color.
  Color get textColor;

  /// Hint color.
  Color get hintColor;

  /// Cursor color.
  Color get cursorColor;

  /// Background color.
  Color get backgroundColor;

  /// Creates a copy with the modified fields.
  ACTimeInputThemeData copyWith();

  /// Interpolates between the current value and [other] at parameter [t].
  ACTimeInputThemeData lerp(ACTimeInputThemeData? other, double t);
}

/// Light implementation of [ACTimeInputThemeData].
class ACLightTimeInputThemeData implements ACTimeInputThemeData {
  /// Creates a light time input theme with optional overrides.
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

  /// Creates a light time input theme with explicitly provided values.
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

  @override
  ACLightTimeInputThemeData lerp(ACTimeInputThemeData? other, double t) {
    if (other == null) return this;
    return ACLightTimeInputThemeData.raw(
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t) ?? textStyle,
      textColor: Color.lerp(textColor, other.textColor, t) ?? textColor,
      hintColor: Color.lerp(hintColor, other.hintColor, t) ?? hintColor,
      cursorColor: Color.lerp(cursorColor, other.cursorColor, t) ?? cursorColor,
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t) ??
          backgroundColor,
    );
  }
}
