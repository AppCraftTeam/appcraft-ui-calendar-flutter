import 'package:flutter/material.dart';

/// Тема оформления колёсного пикера.
abstract class ACWheelPickerThemeData {
  /// Цвет текста невыбранного элемента.
  Color get itemTextColor;

  /// Цвет текста выбранного элемента.
  Color get selectedItemTextColor;

  /// Стиль текста элементов.
  TextStyle get itemTextStyle;

  /// Создаёт копию с изменёнными полями.
  ACWheelPickerThemeData copyWith();

  /// Интерполирует между двумя [ACWheelPickerThemeData].
  static ACWheelPickerThemeData? lerpTheme(
      ACWheelPickerThemeData? a, ACWheelPickerThemeData? b, double t) {
    if (a == null && b == null) return null;
    return ACLightWheelPickerThemeData.raw(
      itemTextColor: Color.lerp(a?.itemTextColor, b?.itemTextColor, t) ??
          b?.itemTextColor ??
          a!.itemTextColor,
      selectedItemTextColor:
          Color.lerp(a?.selectedItemTextColor, b?.selectedItemTextColor, t) ??
              b?.selectedItemTextColor ??
              a!.selectedItemTextColor,
      itemTextStyle: TextStyle.lerp(a?.itemTextStyle, b?.itemTextStyle, t) ??
          b?.itemTextStyle ??
          a!.itemTextStyle,
    );
  }
}

/// Светлая реализация [ACWheelPickerThemeData].
class ACLightWheelPickerThemeData implements ACWheelPickerThemeData {
  /// Создаёт светлую тему колёсного пикера с опциональными переопределениями.
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

  /// Создаёт светлую тему колёсного пикера с явно заданными значениями.
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
}
