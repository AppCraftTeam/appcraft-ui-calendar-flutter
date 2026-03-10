import 'package:flutter/material.dart';

abstract class ACDayThemeData {
  Color get selectedBackgroundColor;
  Color get middleSelectedBackgroudColor;
  Color get inactiveTextColor;
  Color get textColor;

  TextStyle get textStyle;
  TextStyle get todayTextStyle;

  ACDayThemeData copyWith();
}

class ACLightDayThemeData implements ACDayThemeData {
  factory ACLightDayThemeData(
      {Color? selectedBackgroundColor,
      Color? middleSelectedBackgroudColor,
      Color? inactiveTextColor,
      Color? textColor,
      TextStyle? textStyle,
      TextStyle? todayTextStyle}) {
    final resolvedTextStyle = textStyle ??
        const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 20,
            height: 20 / 25,
            letterSpacing: .38);

    return ACLightDayThemeData.raw(
        selectedBackgroundColor:
            selectedBackgroundColor ?? const Color(0xFFD2DCFF),
        middleSelectedBackgroudColor:
            middleSelectedBackgroudColor ?? const Color(0xFFEDF3FF),
        inactiveTextColor: inactiveTextColor ?? const Color(0xFFD5DDE7),
        textColor: textColor ?? const Color(0xFF000000),
        textStyle: resolvedTextStyle,
        todayTextStyle: todayTextStyle ??
            resolvedTextStyle.copyWith(fontWeight: FontWeight.w600));
  }

  const ACLightDayThemeData.raw(
      {required this.selectedBackgroundColor,
      required this.middleSelectedBackgroudColor,
      required this.inactiveTextColor,
      required this.textColor,
      required this.textStyle,
      required this.todayTextStyle});

  @override
  final Color selectedBackgroundColor;

  @override
  final Color middleSelectedBackgroudColor;

  @override
  final Color inactiveTextColor;

  @override
  final Color textColor;

  @override
  final TextStyle textStyle;

  @override
  final TextStyle todayTextStyle;

  @override
  ACLightDayThemeData copyWith(
          {Color? selectedBackgroundColor,
          Color? middleSelectedBackgroudColor,
          Color? inactiveTextColor,
          Color? textColor,
          TextStyle? textStyle,
          TextStyle? todayTextStyle}) =>
      ACLightDayThemeData(
          selectedBackgroundColor:
              selectedBackgroundColor ?? this.selectedBackgroundColor,
          middleSelectedBackgroudColor:
              middleSelectedBackgroudColor ?? this.middleSelectedBackgroudColor,
          inactiveTextColor: inactiveTextColor ?? this.inactiveTextColor,
          textColor: textColor ?? this.textColor,
          textStyle: textStyle ?? this.textStyle,
          todayTextStyle: todayTextStyle ?? this.todayTextStyle);
}
