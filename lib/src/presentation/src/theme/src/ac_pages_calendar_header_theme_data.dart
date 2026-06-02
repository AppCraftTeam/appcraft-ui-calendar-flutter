import 'package:flutter/material.dart';

/// Theme data for the paged calendar header.
abstract class ACPagesCalendarHeaderThemeData {
  /// Color of the navigation arrows.
  Color get arrowColor;

  /// Text color of the month name.
  Color get monthTextColor;

  /// Title text style.
  TextStyle get titleTextStyle;

  /// Creates a copy with the modified fields.
  ACPagesCalendarHeaderThemeData copyWith();

  /// Interpolates between the current value and [other] at parameter [t].
  ACPagesCalendarHeaderThemeData lerp(
      ACPagesCalendarHeaderThemeData? other, double t);
}

/// Light implementation of [ACPagesCalendarHeaderThemeData].
class ACLightPagesCalendarHeaderThemeData
    implements ACPagesCalendarHeaderThemeData {
  /// Creates a light header theme with optional overrides.
  factory ACLightPagesCalendarHeaderThemeData({
    Color? arrowColor,
    Color? monthTextColor,
    TextStyle? titleTextStyle,
  }) =>
      ACLightPagesCalendarHeaderThemeData.raw(
        arrowColor: arrowColor ?? const Color(0xFF000000),
        monthTextColor: monthTextColor ?? const Color(0xFF000000),
        titleTextStyle: titleTextStyle ??
            const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 17,
              height: 17 / 22,
              letterSpacing: -.41,
            ),
      );

  /// Creates a light header theme with explicitly provided values.
  const ACLightPagesCalendarHeaderThemeData.raw({
    required this.arrowColor,
    required this.monthTextColor,
    required this.titleTextStyle,
  });

  @override
  final Color arrowColor;

  @override
  final Color monthTextColor;

  @override
  final TextStyle titleTextStyle;

  @override
  ACLightPagesCalendarHeaderThemeData copyWith({
    Color? arrowColor,
    Color? monthTextColor,
    TextStyle? titleTextStyle,
  }) =>
      ACLightPagesCalendarHeaderThemeData(
        arrowColor: arrowColor ?? this.arrowColor,
        monthTextColor: monthTextColor ?? this.monthTextColor,
        titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      );

  @override
  ACLightPagesCalendarHeaderThemeData lerp(
      ACPagesCalendarHeaderThemeData? other, double t) {
    if (other == null) return this;
    return ACLightPagesCalendarHeaderThemeData.raw(
      arrowColor: Color.lerp(arrowColor, other.arrowColor, t) ?? arrowColor,
      monthTextColor:
          Color.lerp(monthTextColor, other.monthTextColor, t) ?? monthTextColor,
      titleTextStyle: TextStyle.lerp(titleTextStyle, other.titleTextStyle, t) ??
          titleTextStyle,
    );
  }
}
