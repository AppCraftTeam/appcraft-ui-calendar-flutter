import 'package:flutter/material.dart';

/// Тема оформления пикера месяца.
abstract class ACMonthPickerThemeData {
  /// Цвет выделения выбранного элемента.
  Color get selectionColor;

  /// Цвет текста кнопки действия (например, «Готово»).
  Color get actionTextColor;

  /// Создаёт копию с изменёнными полями.
  ACMonthPickerThemeData copyWith();

  /// Интерполирует между двумя [ACMonthPickerThemeData].
  static ACMonthPickerThemeData? lerpTheme(
      ACMonthPickerThemeData? a, ACMonthPickerThemeData? b, double t) {
    if (a == null && b == null) return null;
    return ACLightMonthPickerThemeData.raw(
      selectionColor: Color.lerp(a?.selectionColor, b?.selectionColor, t) ??
          b?.selectionColor ??
          a!.selectionColor,
      actionTextColor: Color.lerp(a?.actionTextColor, b?.actionTextColor, t) ??
          b?.actionTextColor ??
          a!.actionTextColor,
    );
  }
}

/// Светлая реализация [ACMonthPickerThemeData].
class ACLightMonthPickerThemeData implements ACMonthPickerThemeData {
  /// Создаёт светлую тему пикера месяца с опциональными переопределениями.
  factory ACLightMonthPickerThemeData({
    Color? selectionColor,
    Color? actionTextColor,
  }) =>
      ACLightMonthPickerThemeData.raw(
        selectionColor: selectionColor ?? const Color(0xFFD2DCFF),
        actionTextColor: actionTextColor ?? const Color(0xFF000000),
      );

  /// Создаёт светлую тему пикера месяца с явно заданными значениями.
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
        selectionColor: selectionColor,
        actionTextColor: actionTextColor,
      );
}
