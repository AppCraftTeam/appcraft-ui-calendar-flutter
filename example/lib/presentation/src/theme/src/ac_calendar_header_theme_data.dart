import 'package:flutter/material.dart';

abstract class ACCalendarHeaderThemeData {
  Color get primaryColor;
  TextStyle get titleTextStyle;

  ACCalendarHeaderThemeData copyWith();
}

class ACLightCalendarHeaderThemeData implements ACCalendarHeaderThemeData {
  factory ACLightCalendarHeaderThemeData({
    Color? primaryColor,
    TextStyle? titleTextStyle
  }) => ACLightCalendarHeaderThemeData.raw(
    primaryColor: primaryColor ?? const Color(0XFF000000),
    titleTextStyle: titleTextStyle ?? const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 17,
      height: 17/22,
      letterSpacing: -.41
    )
  );
  
  const ACLightCalendarHeaderThemeData.raw({
    required this.primaryColor,
    required this.titleTextStyle
  });

  @override
  final Color primaryColor;
  
  @override
  final TextStyle titleTextStyle;
  
  @override
  ACLightCalendarHeaderThemeData copyWith({
    Color? primaryColor,
    TextStyle? titleTextStyle
  }) =>
    ACLightCalendarHeaderThemeData(
      primaryColor: primaryColor,
      titleTextStyle: titleTextStyle
    );

}