import 'package:flutter/material.dart';

abstract class ACDayThemeData {
  Color get middleSelectedBackgroudColor;
  Color get inactiveTextColor;
  Color get activeTextColor;

  TextStyle get textStyle;
  TextStyle get todayTextStyle;

  ACDayThemeData copyWith();
}

class ACLightDayThemeData implements ACDayThemeData {
  factory ACLightDayThemeData({
    Color? middleSelectedBackgroudColor,
    Color? inactiveTextColor,
    Color? activeTextColor,
    TextStyle? textStyle,
    TextStyle? todayTextStyle
  }) {
    final resolvedTextStyle = textStyle ?? const TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 20,
      height: 20/25,
      letterSpacing: .38
    );

    return ACLightDayThemeData.raw(
      middleSelectedBackgroudColor: middleSelectedBackgroudColor ?? const Color(0xFFEDF3FF),
      inactiveTextColor: inactiveTextColor ?? const Color(0xFFD5DDE7),
      activeTextColor: activeTextColor ?? const Color(0xFF000000),
      textStyle: resolvedTextStyle,
      todayTextStyle: todayTextStyle ?? resolvedTextStyle.copyWith(
        fontWeight: FontWeight.w600
      )
    );
  }
  
  const ACLightDayThemeData.raw({
    required this.middleSelectedBackgroudColor,
    required this.inactiveTextColor,
    required this.activeTextColor,
    required this.textStyle,
    required this.todayTextStyle
  });

  @override
  final Color middleSelectedBackgroudColor;

  @override
  final Color inactiveTextColor;

  @override
  final Color activeTextColor;
  
  @override
  final TextStyle textStyle;

  @override
  final TextStyle todayTextStyle;
  
  @override
  ACLightDayThemeData copyWith({
    Color? middleSelectedBackgroudColor,
    Color? inactiveTextColor,
    Color? activeTextColor,
    TextStyle? textStyle,
    TextStyle? todayTextStyle
  }) =>
    ACLightDayThemeData(
      middleSelectedBackgroudColor: middleSelectedBackgroudColor,
      inactiveTextColor: inactiveTextColor,
      activeTextColor: activeTextColor,
      textStyle: textStyle,
      todayTextStyle: todayTextStyle
    );

}