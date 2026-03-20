import 'package:flutter/material.dart';

/// Тема оформления заголовка времени.
abstract class ACTitledTimeThemeData {
  /// Стиль текста заголовка.
  TextStyle get titleTextStyle;

  /// Цвет заголовка.
  Color get titleColor;

  /// Создаёт копию с изменёнными полями.
  ACTitledTimeThemeData copyWith();

  /// Интерполирует между двумя [ACTitledTimeThemeData].
  static ACTitledTimeThemeData? lerpTheme(
      ACTitledTimeThemeData? a, ACTitledTimeThemeData? b, double t) {
    if (a == null && b == null) return null;
    return ACLightTitledTimeThemeData.raw(
      titleTextStyle: TextStyle.lerp(a?.titleTextStyle, b?.titleTextStyle, t) ??
          b?.titleTextStyle ??
          a!.titleTextStyle,
      titleColor: Color.lerp(a?.titleColor, b?.titleColor, t) ??
          b?.titleColor ??
          a!.titleColor,
    );
  }
}

/// Светлая реализация [ACTitledTimeThemeData].
class ACLightTitledTimeThemeData implements ACTitledTimeThemeData {
  /// Создаёт светлую тему заголовка времени с опциональными переопределениями.
  factory ACLightTitledTimeThemeData({
    TextStyle? titleTextStyle,
    Color? titleColor,
  }) =>
      ACLightTitledTimeThemeData.raw(
        titleTextStyle: titleTextStyle ??
            const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 17,
              height: 17 / 22,
            ),
        titleColor: titleColor ?? const Color(0xFF000000),
      );

  /// Создаёт светлую тему заголовка времени с явно заданными значениями.
  const ACLightTitledTimeThemeData.raw({
    required this.titleTextStyle,
    required this.titleColor,
  });

  @override
  final TextStyle titleTextStyle;

  @override
  final Color titleColor;

  @override
  ACLightTitledTimeThemeData copyWith({
    TextStyle? titleTextStyle,
    Color? titleColor,
  }) =>
      ACLightTitledTimeThemeData(
        titleTextStyle: titleTextStyle ?? this.titleTextStyle,
        titleColor: titleColor ?? this.titleColor,
      );
}
