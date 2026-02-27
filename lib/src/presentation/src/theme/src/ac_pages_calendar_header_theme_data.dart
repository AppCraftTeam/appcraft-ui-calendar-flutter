import 'package:flutter/material.dart';

abstract class ACPagesCalendarHeaderThemeData {
  Color get arrowColor;
  Color get monthTextColor;
  TextStyle get titleTextStyle;

  ACPagesCalendarHeaderThemeData copyWith();
}

class ACLightPagesCalendarHeaderThemeData implements ACPagesCalendarHeaderThemeData {
  factory ACLightPagesCalendarHeaderThemeData({
    Color? arrowColor,
    Color? monthTextColor,
    TextStyle? titleTextStyle,
  }) => ACLightPagesCalendarHeaderThemeData.raw(
    arrowColor: arrowColor ?? const Color(0xFF000000),
    monthTextColor: monthTextColor ?? const Color(0xFF000000),
    titleTextStyle: titleTextStyle ?? const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 17,
      height: 17/22,
      letterSpacing: -.41,
    ),
  );

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
  }) => ACLightPagesCalendarHeaderThemeData(
    arrowColor: arrowColor,
    monthTextColor: monthTextColor,
    titleTextStyle: titleTextStyle,
  );
}
