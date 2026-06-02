import 'package:flutter/material.dart';

/// Theme data for the time title.
abstract class ACTitledTimeThemeData {
  /// Title text style.
  TextStyle get titleTextStyle;

  /// Title color.
  Color get titleColor;

  /// Creates a copy with the modified fields.
  ACTitledTimeThemeData copyWith();

  /// Interpolates between the current value and [other] at parameter [t].
  ACTitledTimeThemeData lerp(ACTitledTimeThemeData? other, double t);
}

/// Light implementation of [ACTitledTimeThemeData].
class ACLightTitledTimeThemeData implements ACTitledTimeThemeData {
  /// Creates a light time title theme with optional overrides.
  factory ACLightTitledTimeThemeData({
    TextStyle? titleTextStyle,
    Color? titleColor,
  }) =>
      ACLightTitledTimeThemeData.raw(
        titleTextStyle: titleTextStyle ??
            const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 17,
              height: 17 / 22,
            ),
        titleColor: titleColor ?? const Color(0xFF000000),
      );

  /// Creates a light time title theme with explicitly provided values.
  const ACLightTitledTimeThemeData.raw({
    required this.titleTextStyle,
    required this.titleColor,
  });

  @override
  final TextStyle titleTextStyle;

  @override
  final Color titleColor;

  @override
  ACLightTitledTimeThemeData copyWith({
    TextStyle? titleTextStyle,
    Color? titleColor,
  }) =>
      ACLightTitledTimeThemeData(
        titleTextStyle: titleTextStyle ?? this.titleTextStyle,
        titleColor: titleColor ?? this.titleColor,
      );

  @override
  ACLightTitledTimeThemeData lerp(ACTitledTimeThemeData? other, double t) {
    if (other == null) return this;
    return ACLightTitledTimeThemeData.raw(
      titleTextStyle: TextStyle.lerp(titleTextStyle, other.titleTextStyle, t) ??
          titleTextStyle,
      titleColor: Color.lerp(titleColor, other.titleColor, t) ?? titleColor,
    );
  }
}
