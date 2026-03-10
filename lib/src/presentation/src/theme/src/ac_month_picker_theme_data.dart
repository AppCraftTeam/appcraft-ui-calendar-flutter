import 'package:flutter/material.dart';

abstract class ACMonthPickerThemeData {
  Color get selectionColor;

  ACMonthPickerThemeData copyWith();
}

class ACLightMonthPickerThemeData implements ACMonthPickerThemeData {
  factory ACLightMonthPickerThemeData({
    Color? selectionColor,
  }) =>
      ACLightMonthPickerThemeData.raw(
        selectionColor: selectionColor ?? const Color(0xFFD2DCFF),
      );

  const ACLightMonthPickerThemeData.raw({
    required this.selectionColor,
  });

  @override
  final Color selectionColor;

  @override
  ACLightMonthPickerThemeData copyWith({
    Color? selectionColor,
  }) =>
      ACLightMonthPickerThemeData(
        selectionColor: selectionColor,
      );
}
