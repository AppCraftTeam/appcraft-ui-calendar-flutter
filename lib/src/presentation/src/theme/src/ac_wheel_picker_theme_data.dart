import 'package:flutter/material.dart';

/// Theme data for the wheel picker.
abstract class ACWheelPickerThemeData {
  /// Text color of an unselected item.
  Color get itemTextColor;

  /// Text color of the selected item.
  Color get selectedItemTextColor;

  /// Text style of the items.
  TextStyle get itemTextStyle;

  /// Creates a copy with the modified fields.
  ACWheelPickerThemeData copyWith();

  /// Interpolates between the current value and [other] at parameter [t].
  ACWheelPickerThemeData lerp(ACWheelPickerThemeData? other, double t);
}

/// Light implementation of [ACWheelPickerThemeData].
class ACLightWheelPickerThemeData implements ACWheelPickerThemeData {
  /// Creates a light wheel picker theme with optional overrides.
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

  /// Creates a light wheel picker theme with explicitly provided values.
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
        itemTextColor: itemTextColor ?? this.itemTextColor,
        selectedItemTextColor:
            selectedItemTextColor ?? this.selectedItemTextColor,
        itemTextStyle: itemTextStyle ?? this.itemTextStyle,
      );

  @override
  ACLightWheelPickerThemeData lerp(ACWheelPickerThemeData? other, double t) {
    if (other == null) return this;
    return ACLightWheelPickerThemeData.raw(
      itemTextColor:
          Color.lerp(itemTextColor, other.itemTextColor, t) ?? itemTextColor,
      selectedItemTextColor:
          Color.lerp(selectedItemTextColor, other.selectedItemTextColor, t) ??
              selectedItemTextColor,
      itemTextStyle: TextStyle.lerp(itemTextStyle, other.itemTextStyle, t) ??
          itemTextStyle,
    );
  }
}
