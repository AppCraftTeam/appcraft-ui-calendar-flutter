import 'package:flutter/material.dart';

abstract class ACTimeInputThemeData {
  TextStyle get textStyle;
  Color get textColor;
  Color get hintColor;
  Color get cursorColor;
  Color get backgroundColor;

  ACTimeInputThemeData copyWith();
}

class ACLightTimeInputThemeData implements ACTimeInputThemeData {
  factory ACLightTimeInputThemeData({
    TextStyle? textStyle,
    Color? textColor,
    Color? hintColor,
    Color? cursorColor,
    Color? backgroundColor,
  }) => ACLightTimeInputThemeData.raw(
    textStyle: textStyle ?? const TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 17,
      height: 17/22,
    ),
    textColor: textColor ?? const Color(0xFF000000),
    hintColor: hintColor ?? const Color(0xFF9A99A2),
    cursorColor: cursorColor ?? const Color(0xFF232326),
    backgroundColor: backgroundColor ?? const Color(0x1F767680),
  );

  const ACLightTimeInputThemeData.raw({
    required this.textStyle,
    required this.textColor,
    required this.hintColor,
    required this.cursorColor,
    required this.backgroundColor,
  });

  @override
  final TextStyle textStyle;

  @override
  final Color textColor;

  @override
  final Color hintColor;

  @override
  final Color cursorColor;

  @override
  final Color backgroundColor;

  @override
  ACLightTimeInputThemeData copyWith({
    TextStyle? textStyle,
    Color? textColor,
    Color? hintColor,
    Color? cursorColor,
    Color? backgroundColor,
  }) => ACLightTimeInputThemeData(
    textStyle: textStyle ?? this.textStyle,
    textColor: textColor ?? this.textColor,
    hintColor: hintColor ?? this.hintColor,
    cursorColor: cursorColor ?? this.cursorColor,
    backgroundColor: backgroundColor ?? this.backgroundColor,
  );
}
