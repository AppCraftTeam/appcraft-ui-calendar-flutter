import 'package:flutter/material.dart';

/// Theme data for the weekday row.
abstract class ACWeekThemeData {
  /// Text color of the weekdays.
  Color get textColor;

  /// Text style of the weekdays.
  TextStyle get textStyle;

  /// Creates a copy with the modified fields.
  ACWeekThemeData copyWith();

  /// Interpolates between the current value and [other] at parameter [t].
  ACWeekThemeData lerp(ACWeekThemeData? other, double t);
}

/// Light implementation of [ACWeekThemeData].
class ACLightWeekThemeData implements ACWeekThemeData {
  /// Creates a light weekday theme with optional overrides.
  factory ACLightWeekThemeData({Color? textColor, TextStyle? textStyle}) =>
      ACLightWeekThemeData.raw(
          textColor: textColor ?? const Color(0xFFD5DDE7),
          textStyle: textStyle ??
              const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  height: 13 / 18,
                  letterSpacing: -.08));

  /// Creates a light weekday theme with explicitly provided values.
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
