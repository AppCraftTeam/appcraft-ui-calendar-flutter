import 'package:flutter/widgets.dart';

import 'ac_calendar_header_theme_data.dart';
import 'ac_day_theme_data.dart';
import 'ac_week_theme_data.dart';
import 'ac_wheel_theme_data.dart';

abstract class ACCalendarThemeData {
  ACCalendarHeaderThemeData get calendarHeaderTheme;
  ACDayThemeData get dayTheme;
  ACWeekThemeData get weekTheme;
  ACWheelThemeData get wheelTheme;

  Color get accentColor;

  ACCalendarThemeData copyWith();
}

class ACLightCalendarThemeData implements ACCalendarThemeData {
  factory ACLightCalendarThemeData({
    ACCalendarHeaderThemeData? calendarHeaderTheme,
    ACDayThemeData? dayTheme,
    ACWeekThemeData? weekTheme,
    ACWheelThemeData? wheelTheme,
    Color? accentColor
  }) => ACLightCalendarThemeData.raw(
    calendarHeaderTheme: calendarHeaderTheme ?? ACLightCalendarHeaderThemeData(),
    dayTheme: dayTheme ?? ACLightDayThemeData(),
    weekTheme: weekTheme ?? ACLightWeekThemeData(),
    wheelTheme: wheelTheme ?? ACLightWheelThemeData(),
    accentColor: accentColor ?? const Color(0xFFD2DCFF)
  );

  const ACLightCalendarThemeData.raw({
    required this.calendarHeaderTheme,
    required this.dayTheme,
    required this.weekTheme,
    required this.wheelTheme,
    required this.accentColor
  });

  @override
  final ACCalendarHeaderThemeData calendarHeaderTheme;

  @override
  final ACDayThemeData dayTheme;

  @override
  final ACWeekThemeData weekTheme;

  @override
  final ACWheelThemeData wheelTheme;

  @override
  final Color accentColor;

  @override
  ACLightCalendarThemeData copyWith({
    ACCalendarHeaderThemeData? calendarHeaderTheme,
    ACDayThemeData? dayTheme,
    ACWeekThemeData? weekTheme,
    ACWheelThemeData? wheelTheme,
    Color? accentColor
  }) => ACLightCalendarThemeData(
    calendarHeaderTheme: calendarHeaderTheme,
    dayTheme: dayTheme,
    weekTheme: weekTheme,
    wheelTheme: wheelTheme,
    accentColor: accentColor
  );
}

