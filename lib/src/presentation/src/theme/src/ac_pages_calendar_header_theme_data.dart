import 'package:flutter/material.dart';

/// Тема оформления заголовка постраничного календаря.
abstract class ACPagesCalendarHeaderThemeData {
  /// Цвет стрелок навигации.
  Color get arrowColor;

  /// Цвет текста названия месяца.
  Color get monthTextColor;

  /// Стиль текста заголовка.
  TextStyle get titleTextStyle;

  /// Создаёт копию с изменёнными полями.
  ACPagesCalendarHeaderThemeData copyWith();

  /// Интерполирует между текущим и [other] при параметре [t].
  ACPagesCalendarHeaderThemeData lerp(
      ACPagesCalendarHeaderThemeData? other, double t);
}

/// Светлая реализация [ACPagesCalendarHeaderThemeData].
class ACLightPagesCalendarHeaderThemeData
    implements ACPagesCalendarHeaderThemeData {
  /// Создаёт светлую тему заголовка с опциональными переопределениями.
  factory ACLightPagesCalendarHeaderThemeData({
    Color? arrowColor,
    Color? monthTextColor,
    TextStyle? titleTextStyle,
  }) =>
      ACLightPagesCalendarHeaderThemeData.raw(
        arrowColor: arrowColor ?? const Color(0xFF000000),
        monthTextColor: monthTextColor ?? const Color(0xFF000000),
        titleTextStyle: titleTextStyle ??
            const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 17,
              height: 17 / 22,
              letterSpacing: -.41,
            ),
      );

  /// Создаёт светлую тему заголовка с явно заданными значениями.
  const ACLightPagesCalendarHeaderThemeData.raw({
    required this.arrowColor,
    required this.monthTextColor,
    required this.titleTextStyle,
  });

  @override
  final Color arrowColor;

  @override
  final Color monthTextColor;

  @override
  final TextStyle titleTextStyle;

  @override
  ACLightPagesCalendarHeaderThemeData copyWith({
    Color? arrowColor,
    Color? monthTextColor,
    TextStyle? titleTextStyle,
  }) =>
      ACLightPagesCalendarHeaderThemeData(
        arrowColor: arrowColor ?? this.arrowColor,
        monthTextColor: monthTextColor ?? this.monthTextColor,
        titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      );

  @override
  ACLightPagesCalendarHeaderThemeData lerp(
      ACPagesCalendarHeaderThemeData? other, double t) {
    if (other == null) return this;
    return ACLightPagesCalendarHeaderThemeData.raw(
      arrowColor: Color.lerp(arrowColor, other.arrowColor, t) ?? arrowColor,
      monthTextColor:
          Color.lerp(monthTextColor, other.monthTextColor, t) ?? monthTextColor,
      titleTextStyle: TextStyle.lerp(titleTextStyle, other.titleTextStyle, t) ??
          titleTextStyle,
    );
  }
}
