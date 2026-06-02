import 'package:flutter/material.dart';

/// Theme data for the month picker.
abstract class ACMonthPickerThemeData {
  /// Highlight color of the selected item.
  Color get selectionColor;

  /// Text color of the action button (for example, "Done").
  Color get actionTextColor;

  /// Creates a copy with the modified fields.
  ACMonthPickerThemeData copyWith();

  /// Interpolates between the current value and [other] at parameter [t].
  ACMonthPickerThemeData lerp(ACMonthPickerThemeData? other, double t);
}

/// Light implementation of [ACMonthPickerThemeData].
class ACLightMonthPickerThemeData implements ACMonthPickerThemeData {
  /// Creates a light month picker theme with optional overrides.
  factory ACLightMonthPickerThemeData({
    Color? selectionColor,
    Color? actionTextColor,
  }) =>
      ACLightMonthPickerThemeData.raw(
        selectionColor: selectionColor ?? const Color(0xFFD2DCFF),
        actionTextColor: actionTextColor ?? const Color(0xFF000000),
      );

  /// Creates a light month picker theme with explicitly provided values.
  const ACLightMonthPickerThemeData.raw({
    required this.selectionColor,
    required this.actionTextColor,
  });

  @override
  final Color selectionColor;

  @override
  final Color actionTextColor;

  @override
  ACLightMonthPickerThemeData copyWith({
    Color? selectionColor,
    Color? actionTextColor,
  }) =>
      ACLightMonthPickerThemeData(
        selectionColor: selectionColor ?? this.selectionColor,
        actionTextColor: actionTextColor ?? this.actionTextColor,
      );

  @override
  ACLightMonthPickerThemeData lerp(ACMonthPickerThemeData? other, double t) {
    if (other == null) return this;
    return ACLightMonthPickerThemeData.raw(
      selectionColor:
          Color.lerp(selectionColor, other.selectionColor, t) ?? selectionColor,
      actionTextColor: Color.lerp(actionTextColor, other.actionTextColor, t) ??
          actionTextColor,
    );
  }
}
