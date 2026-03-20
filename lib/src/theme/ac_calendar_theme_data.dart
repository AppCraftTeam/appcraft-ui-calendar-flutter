import 'package:flutter/material.dart';

import 'ac_day_theme_data.dart';
import 'ac_month_picker_theme_data.dart';
import 'ac_pages_calendar_header_theme_data.dart';
import 'ac_time_input_theme_data.dart';
import 'ac_titled_month_theme_data.dart';
import 'ac_titled_time_theme_data.dart';
import 'ac_week_theme_data.dart';
import 'ac_wheel_picker_theme_data.dart';

/// Тема оформления календаря, реализованная как [ThemeExtension].
///
/// Содержит все sub-themes для различных компонентов календаря.
/// Может быть передана через `ThemeData(extensions: [ACCalendarThemeData()])`.
class ACCalendarThemeData extends ThemeExtension<ACCalendarThemeData> {
  /// Создаёт тему календаря с опциональными переопределениями sub-themes.
  ///
  /// Для каждого параметра, не переданного явно,
  /// используется соответствующая Light-реализация по умолчанию.
  factory ACCalendarThemeData({
    ACPagesCalendarHeaderThemeData? pagesCalendarHeaderTheme,
    ACDayThemeData? dayTheme,
    ACWeekThemeData? weekTheme,
    ACMonthPickerThemeData? monthPickerTheme,
    ACWheelPickerThemeData? wheelPickerTheme,
    ACTitledMonthThemeData? titledMonthTheme,
    ACTimeInputThemeData? timeInputTheme,
    ACTitledTimeThemeData? titledTimeTheme,
    Color? backgroundColor,
  }) =>
      ACCalendarThemeData.raw(
        pagesCalendarHeaderTheme:
            pagesCalendarHeaderTheme ?? ACLightPagesCalendarHeaderThemeData(),
        dayTheme: dayTheme ?? ACLightDayThemeData(),
        weekTheme: weekTheme ?? ACLightWeekThemeData(),
        monthPickerTheme: monthPickerTheme ?? ACLightMonthPickerThemeData(),
        wheelPickerTheme: wheelPickerTheme ?? ACLightWheelPickerThemeData(),
        titledMonthTheme: titledMonthTheme ?? ACLightTitledMonthThemeData(),
        timeInputTheme: timeInputTheme ?? ACLightTimeInputThemeData(),
        titledTimeTheme: titledTimeTheme ?? ACLightTitledTimeThemeData(),
        backgroundColor: backgroundColor,
      );

  /// Создаёт тему календаря с явно заданными значениями всех полей.
  const ACCalendarThemeData.raw({
    required this.pagesCalendarHeaderTheme,
    required this.dayTheme,
    required this.weekTheme,
    required this.monthPickerTheme,
    required this.wheelPickerTheme,
    required this.titledMonthTheme,
    required this.timeInputTheme,
    required this.titledTimeTheme,
    this.backgroundColor,
  });

  /// Тема заголовка постраничного календаря.
  final ACPagesCalendarHeaderThemeData pagesCalendarHeaderTheme;

  /// Тема виджета дня.
  final ACDayThemeData dayTheme;

  /// Тема строки дней недели.
  final ACWeekThemeData weekTheme;

  /// Тема пикера месяца.
  final ACMonthPickerThemeData monthPickerTheme;

  /// Тема колёсного пикера.
  final ACWheelPickerThemeData wheelPickerTheme;

  /// Тема заголовка месяца.
  final ACTitledMonthThemeData titledMonthTheme;

  /// Тема ввода времени.
  final ACTimeInputThemeData timeInputTheme;

  /// Тема заголовка времени.
  final ACTitledTimeThemeData titledTimeTheme;

  /// Цвет фона календаря. Если `null`, используется цвет из [ThemeData].
  final Color? backgroundColor;

  /// Возвращает [ACCalendarThemeData] из ближайшего [Theme],
  /// или создаёт экземпляр с дефолтными значениями.
  static ACCalendarThemeData of(BuildContext context) {
    return Theme.of(context).extension<ACCalendarThemeData>() ??
        ACCalendarThemeData();
  }

  @override
  ACCalendarThemeData copyWith({
    ACPagesCalendarHeaderThemeData? pagesCalendarHeaderTheme,
    ACDayThemeData? dayTheme,
    ACWeekThemeData? weekTheme,
    ACMonthPickerThemeData? monthPickerTheme,
    ACWheelPickerThemeData? wheelPickerTheme,
    ACTitledMonthThemeData? titledMonthTheme,
    ACTimeInputThemeData? timeInputTheme,
    ACTitledTimeThemeData? titledTimeTheme,
    Color? backgroundColor,
  }) =>
      ACCalendarThemeData.raw(
        pagesCalendarHeaderTheme:
            pagesCalendarHeaderTheme ?? this.pagesCalendarHeaderTheme,
        dayTheme: dayTheme ?? this.dayTheme,
        weekTheme: weekTheme ?? this.weekTheme,
        monthPickerTheme: monthPickerTheme ?? this.monthPickerTheme,
        wheelPickerTheme: wheelPickerTheme ?? this.wheelPickerTheme,
        titledMonthTheme: titledMonthTheme ?? this.titledMonthTheme,
        timeInputTheme: timeInputTheme ?? this.timeInputTheme,
        titledTimeTheme: titledTimeTheme ?? this.titledTimeTheme,
        backgroundColor: backgroundColor ?? this.backgroundColor,
      );

  @override
  ACCalendarThemeData lerp(ACCalendarThemeData? other, double t) {
    if (other is! ACCalendarThemeData) return this;
    return ACCalendarThemeData.raw(
      pagesCalendarHeaderTheme: ACPagesCalendarHeaderThemeData.lerpTheme(
              pagesCalendarHeaderTheme, other.pagesCalendarHeaderTheme, t) ??
          pagesCalendarHeaderTheme,
      dayTheme:
          ACDayThemeData.lerpTheme(dayTheme, other.dayTheme, t) ?? dayTheme,
      weekTheme:
          ACWeekThemeData.lerpTheme(weekTheme, other.weekTheme, t) ?? weekTheme,
      monthPickerTheme: ACMonthPickerThemeData.lerpTheme(
              monthPickerTheme, other.monthPickerTheme, t) ??
          monthPickerTheme,
      wheelPickerTheme: ACWheelPickerThemeData.lerpTheme(
              wheelPickerTheme, other.wheelPickerTheme, t) ??
          wheelPickerTheme,
      titledMonthTheme: ACTitledMonthThemeData.lerpTheme(
              titledMonthTheme, other.titledMonthTheme, t) ??
          titledMonthTheme,
      timeInputTheme: ACTimeInputThemeData.lerpTheme(
              timeInputTheme, other.timeInputTheme, t) ??
          timeInputTheme,
      titledTimeTheme: ACTitledTimeThemeData.lerpTheme(
              titledTimeTheme, other.titledTimeTheme, t) ??
          titledTimeTheme,
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
    );
  }
}

/// Обратная совместимость: typedef для [ACCalendarThemeData].
typedef ACLightCalendarThemeData = ACCalendarThemeData;
