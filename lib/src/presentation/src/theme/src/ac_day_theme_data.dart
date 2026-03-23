import 'package:flutter/material.dart';

/// Тема оформления виджета дня.
abstract class ACDayThemeData {
  /// Цвет фона выбранного дня.
  Color get selectedBackgroundColor;

  /// Цвет фона дня, находящегося внутри выбранного диапазона.
  Color get middleSelectedBackgroundColor;

  /// Цвет текста неактивного дня.
  Color get inactiveTextColor;

  /// Цвет текста дня.
  Color get textColor;

  /// Стиль текста дня.
  TextStyle get textStyle;

  /// Стиль текста для сегодняшнего дня.
  TextStyle get todayTextStyle;

  /// Создаёт копию с изменёнными полями.
  ACDayThemeData copyWith();

  /// Интерполирует между текущим и [other] при параметре [t].
  ACDayThemeData lerp(ACDayThemeData? other, double t);
}

/// Светлая реализация [ACDayThemeData].
class ACLightDayThemeData implements ACDayThemeData {
  /// Создаёт светлую тему дня с опциональными переопределениями.
  factory ACLightDayThemeData(
      {Color? selectedBackgroundColor,
      Color? middleSelectedBackgroundColor,
      Color? inactiveTextColor,
      Color? textColor,
      TextStyle? textStyle,
      TextStyle? todayTextStyle}) {
    final resolvedTextStyle = textStyle ??
        const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 20,
            height: 20 / 25,
            letterSpacing: .38);

    return ACLightDayThemeData.raw(
        selectedBackgroundColor:
            selectedBackgroundColor ?? const Color(0xFFD2DCFF),
        middleSelectedBackgroundColor:
            middleSelectedBackgroundColor ?? const Color(0xFFEDF3FF),
        inactiveTextColor: inactiveTextColor ?? const Color(0xFFD5DDE7),
        textColor: textColor ?? const Color(0xFF000000),
        textStyle: resolvedTextStyle,
        todayTextStyle: todayTextStyle ??
            resolvedTextStyle.copyWith(fontWeight: FontWeight.w600));
  }

  /// Создаёт светлую тему дня с явно заданными значениями всех полей.
  const ACLightDayThemeData.raw(
      {required this.selectedBackgroundColor,
      required this.middleSelectedBackgroundColor,
      required this.inactiveTextColor,
      required this.textColor,
      required this.textStyle,
      required this.todayTextStyle});

  @override
  final Color selectedBackgroundColor;

  @override
  final Color middleSelectedBackgroundColor;

  @override
  final Color inactiveTextColor;

  @override
  final Color textColor;

  @override
  final TextStyle textStyle;

  @override
  final TextStyle todayTextStyle;

  @override
  ACLightDayThemeData copyWith(
          {Color? selectedBackgroundColor,
          Color? middleSelectedBackgroundColor,
          Color? inactiveTextColor,
          Color? textColor,
          TextStyle? textStyle,
          TextStyle? todayTextStyle}) =>
      ACLightDayThemeData(
          selectedBackgroundColor:
              selectedBackgroundColor ?? this.selectedBackgroundColor,
          middleSelectedBackgroundColor: middleSelectedBackgroundColor ??
              this.middleSelectedBackgroundColor,
          inactiveTextColor: inactiveTextColor ?? this.inactiveTextColor,
          textColor: textColor ?? this.textColor,
          textStyle: textStyle ?? this.textStyle,
          todayTextStyle: todayTextStyle ?? this.todayTextStyle);

  @override
  ACLightDayThemeData lerp(ACDayThemeData? other, double t) {
    if (other == null) return this;
    return ACLightDayThemeData.raw(
      selectedBackgroundColor: Color.lerp(
              selectedBackgroundColor, other.selectedBackgroundColor, t) ??
          selectedBackgroundColor,
      middleSelectedBackgroundColor: Color.lerp(middleSelectedBackgroundColor,
              other.middleSelectedBackgroundColor, t) ??
          middleSelectedBackgroundColor,
      inactiveTextColor:
          Color.lerp(inactiveTextColor, other.inactiveTextColor, t) ??
              inactiveTextColor,
      textColor: Color.lerp(textColor, other.textColor, t) ?? textColor,
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t) ?? textStyle,
      todayTextStyle: TextStyle.lerp(todayTextStyle, other.todayTextStyle, t) ??
          todayTextStyle,
    );
  }
}
