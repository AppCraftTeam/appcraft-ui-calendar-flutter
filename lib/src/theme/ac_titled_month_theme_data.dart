import 'package:flutter/material.dart';

/// Тема оформления заголовка месяца.
abstract class ACTitledMonthThemeData {
  /// Цвет заголовка.
  Color get titleColor;

  /// Стиль текста заголовка.
  TextStyle get titleTextStyle;

  /// Создаёт копию с изменёнными полями.
  ACTitledMonthThemeData copyWith();

  /// Интерполирует между двумя [ACTitledMonthThemeData].
  static ACTitledMonthThemeData? lerpTheme(
      ACTitledMonthThemeData? a, ACTitledMonthThemeData? b, double t) {
    if (a == null && b == null) return null;
    return ACLightTitledMonthThemeData.raw(
      titleColor: Color.lerp(a?.titleColor, b?.titleColor, t) ??
          b?.titleColor ??
          a!.titleColor,
      titleTextStyle: TextStyle.lerp(a?.titleTextStyle, b?.titleTextStyle, t) ??
          b?.titleTextStyle ??
          a!.titleTextStyle,
    );
  }
}

/// Светлая реализация [ACTitledMonthThemeData].
class ACLightTitledMonthThemeData implements ACTitledMonthThemeData {
  /// Создаёт светлую тему заголовка месяца с опциональными переопределениями.
  factory ACLightTitledMonthThemeData({
    Color? titleColor,
    TextStyle? titleTextStyle,
  }) =>
      ACLightTitledMonthThemeData.raw(
        titleColor: titleColor ?? const Color(0xFF000000),
        titleTextStyle: titleTextStyle ??
            const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 17,
              height: 17 / 22,
              letterSpacing: -.41,
            ),
      );

  /// Создаёт светлую тему заголовка месяца с явно заданными значениями.
  const ACLightTitledMonthThemeData.raw({
    required this.titleColor,
    required this.titleTextStyle,
  });

  @override
  final Color titleColor;

  @override
  final TextStyle titleTextStyle;

  @override
  ACLightTitledMonthThemeData copyWith({
    Color? titleColor,
    TextStyle? titleTextStyle,
  }) =>
      ACLightTitledMonthThemeData(
        titleColor: titleColor ?? this.titleColor,
        titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      );
}
