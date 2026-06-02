import 'package:flutter/material.dart';

/// Theme data for the day widget.
abstract class ACDayThemeData {
  /// Background color of the selected day.
  Color get selectedBackgroundColor;

  /// Background color of a day located within the selected range.
  Color get middleSelectedBackgroundColor;

  /// Text color of an inactive day.
  Color get inactiveTextColor;

  /// Day text color.
  Color get textColor;

  /// Day text style.
  TextStyle get textStyle;

  /// Text style for the current day.
  TextStyle get todayTextStyle;

  /// Creates a copy with the modified fields.
  ACDayThemeData copyWith();

  /// Interpolates between the current value and [other] at parameter [t].
  ACDayThemeData lerp(ACDayThemeData? other, double t);
}

/// Light implementation of [ACDayThemeData].
class ACLightDayThemeData implements ACDayThemeData {
  /// Creates a light day theme with optional overrides.
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

  /// Creates a light day theme with explicitly provided values for all fields.
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
