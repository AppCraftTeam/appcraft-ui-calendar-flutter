import 'package:flutter/material.dart';

abstract class ACTitledTimeThemeData {
  TextStyle get titleTextStyle;
  Color get titleColor;

  ACTitledTimeThemeData copyWith();
}

class ACLightTitledTimeThemeData implements ACTitledTimeThemeData {
  factory ACLightTitledTimeThemeData({
    TextStyle? titleTextStyle,
    Color? titleColor,
  }) => ACLightTitledTimeThemeData.raw(
    titleTextStyle: titleTextStyle ?? const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 17,
      height: 17/22,
    ),
    titleColor: titleColor ?? const Color(0xFF000000),
  );

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
  }) => ACLightTitledTimeThemeData(
    titleTextStyle: titleTextStyle ?? this.titleTextStyle,
    titleColor: titleColor ?? this.titleColor,
  );
}
