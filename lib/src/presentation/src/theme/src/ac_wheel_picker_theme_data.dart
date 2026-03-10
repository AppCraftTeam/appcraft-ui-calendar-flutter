import 'package:flutter/material.dart';

abstract class ACWheelPickerThemeData {
  Color get itemTextColor;
  Color get selectedItemTextColor;
  TextStyle get itemTextStyle;

  ACWheelPickerThemeData copyWith();
}

class ACLightWheelPickerThemeData implements ACWheelPickerThemeData {
  factory ACLightWheelPickerThemeData({
    Color? itemTextColor,
    Color? selectedItemTextColor,
    TextStyle? itemTextStyle,
  }) =>
      ACLightWheelPickerThemeData.raw(
        itemTextColor:
            itemTextColor ?? const Color(0xFF9A99A2).withValues(alpha: .4),
        selectedItemTextColor: selectedItemTextColor ??
            const Color(0xFF232326).withValues(alpha: .7),
        itemTextStyle: itemTextStyle ??
            const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 23,
              height: 23 / 28,
              letterSpacing: .7,
            ),
      );

  const ACLightWheelPickerThemeData.raw({
    required this.itemTextColor,
    required this.selectedItemTextColor,
    required this.itemTextStyle,
  });

  @override
  final Color itemTextColor;

  @override
  final Color selectedItemTextColor;

  @override
  final TextStyle itemTextStyle;

  @override
  ACLightWheelPickerThemeData copyWith({
    Color? itemTextColor,
    Color? selectedItemTextColor,
    TextStyle? itemTextStyle,
  }) =>
      ACLightWheelPickerThemeData(
        itemTextColor: itemTextColor,
        selectedItemTextColor: selectedItemTextColor,
        itemTextStyle: itemTextStyle,
      );
}
