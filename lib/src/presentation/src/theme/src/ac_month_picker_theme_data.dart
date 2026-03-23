import 'package:flutter/material.dart';

/// Тема оформления пикера месяца.
abstract class ACMonthPickerThemeData {
  /// Цвет выделения выбранного элемента.
  Color get selectionColor;

  /// Цвет текста кнопки действия (например, «Готово»).
  Color get actionTextColor;

  /// Создаёт копию с изменёнными полями.
  ACMonthPickerThemeData copyWith();

  /// Интерполирует между текущим и [other] при параметре [t].
  ACMonthPickerThemeData lerp(ACMonthPickerThemeData? other, double t);
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
