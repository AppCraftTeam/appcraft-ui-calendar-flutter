import 'package:flutter/material.dart';

abstract class ACWeekThemeData {
  Color get textColor;
  TextStyle get textStyle;

  ACWeekThemeData copyWith();
}

class ACLightWeekThemeData implements ACWeekThemeData {
  factory ACLightWeekThemeData({
    Color? textColor,
    TextStyle? textStyle
  }) => ACLightWeekThemeData.raw(
    textColor: textColor ?? const Color(0xFFD5DDE7),
    textStyle: textStyle ?? const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 13,
      height: 13/18,
      letterSpacing: -.08
    )
  );
  
  const ACLightWeekThemeData.raw({
    required this.textColor,
    required this.textStyle
  });

  @override
  final Color textColor;
  
  @override
  final TextStyle textStyle;
  
  @override
  ACLightWeekThemeData copyWith({
    Color? textColor,
    TextStyle? textStyle
  }) =>
    ACLightWeekThemeData(
      textColor: textColor,
      textStyle: textStyle
    );

}