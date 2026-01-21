import 'package:flutter/material.dart';

abstract class ACWheelThemeData {
  Color get itemTextColor;
  Color get selectedItemTextColor;
  TextStyle get itemTextStyle;

  ACWheelThemeData copyWith();
}

class ACLightWheelThemeData implements ACWheelThemeData {
  factory ACLightWheelThemeData({
    Color? itemTextColor,
    Color? selectedItemTextColor,
    TextStyle? itemTextStyle
  }) => ACLightWheelThemeData.raw(
    itemTextColor: itemTextColor ??
      const Color(0xFF9A99A2).withValues(alpha: .4),
    selectedItemTextColor: selectedItemTextColor ??
      const Color(0xFF232326).withValues(alpha: .7),
    itemTextStyle: itemTextStyle ?? const TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 23,
      height: 23/28,
      letterSpacing: .7,
    )
  );

  const ACLightWheelThemeData.raw({
    required this.itemTextColor,
    required this.selectedItemTextColor,
    required this.itemTextStyle
  });

  @override
  final Color itemTextColor;

  @override
  final Color selectedItemTextColor;
  
  @override
  final TextStyle itemTextStyle;
  
  @override
  ACLightWheelThemeData copyWith({
    Color? itemTextColor,
    Color? selectedItemTextColor,
    TextStyle? itemTextStyle
  }) =>
    ACLightWheelThemeData(
      itemTextColor: itemTextColor,
      selectedItemTextColor: selectedItemTextColor,
      itemTextStyle: itemTextStyle
    );

}