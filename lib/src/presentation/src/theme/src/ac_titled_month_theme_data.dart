import 'package:flutter/material.dart';

/// Theme data for the month title.
abstract class ACTitledMonthThemeData {
  /// Title color.
  Color get titleColor;

  /// Title text style.
  TextStyle get titleTextStyle;

  /// Creates a copy with the modified fields.
  ACTitledMonthThemeData copyWith();

  /// Interpolates between the current value and [other] at parameter [t].
  ACTitledMonthThemeData lerp(ACTitledMonthThemeData? other, double t);
}

/// Light implementation of [ACTitledMonthThemeData].
class ACLightTitledMonthThemeData implements ACTitledMonthThemeData {
  /// Creates a light month title theme with optional overrides.
  factory ACLightTitledMonthThemeData({
    Color? titleColor,
    TextStyle? titleTextStyle,
  }) =>
      ACLightTitledMonthThemeData.raw(
        titleColor: titleColor ?? const Color(0xFF000000),
        titleTextStyle: titleTextStyle ??
            const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 17,
              height: 17 / 22,
              letterSpacing: -.41,
            ),
      );

  /// Creates a light month title theme with explicitly provided values.
  const ACLightTitledMonthThemeData.raw({
    required this.titleColor,
    required this.titleTextStyle,
  });

  @override
  final Color titleColor;

  @override
  final TextStyle titleTextStyle;

  @override
  ACLightTitledMonthThemeData copyWith({
    Color? titleColor,
    TextStyle? titleTextStyle,
  }) =>
      ACLightTitledMonthThemeData(
        titleColor: titleColor ?? this.titleColor,
        titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      );

  @override
  ACLightTitledMonthThemeData lerp(ACTitledMonthThemeData? other, double t) {
    if (other == null) return this;
    return ACLightTitledMonthThemeData.raw(
      titleColor: Color.lerp(titleColor, other.titleColor, t) ?? titleColor,
      titleTextStyle: TextStyle.lerp(titleTextStyle, other.titleTextStyle, t) ??
          titleTextStyle,
    );
  }
}
