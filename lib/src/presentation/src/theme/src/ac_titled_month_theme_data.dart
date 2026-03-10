import 'package:flutter/material.dart';

abstract class ACTitledMonthThemeData {
  Color get titleColor;
  TextStyle get titleTextStyle;

  ACTitledMonthThemeData copyWith();
}

class ACLightTitledMonthThemeData implements ACTitledMonthThemeData {
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
        titleColor: titleColor,
        titleTextStyle: titleTextStyle,
      );
}
