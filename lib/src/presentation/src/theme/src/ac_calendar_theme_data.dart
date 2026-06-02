import 'package:flutter/material.dart';

import 'ac_day_theme_data.dart';
import 'ac_month_picker_theme_data.dart';
import 'ac_pages_calendar_header_theme_data.dart';
import 'ac_time_input_theme_data.dart';
import 'ac_titled_month_theme_data.dart';
import 'ac_titled_time_theme_data.dart';
import 'ac_week_theme_data.dart';
import 'ac_wheel_picker_theme_data.dart';

/// Abstract data class for the calendar theme.
///
/// Contains all sub-themes for the various calendar components.
/// Used together with [ACCalendarThemeExtension] to pass the theme
/// via `ThemeData(extensions: [ACCalendarThemeExtension(data: ACLightCalendarThemeData(...))])`.
abstract class ACCalendarThemeData {
  /// Theme of the paged calendar header.
  ACPagesCalendarHeaderThemeData get pagesCalendarHeaderTheme;

  /// Theme of the day widget.
  ACDayThemeData get dayTheme;

  /// Theme of the weekday row.
  ACWeekThemeData get weekTheme;

  /// Theme of the month picker.
  ACMonthPickerThemeData get monthPickerTheme;

  /// Theme of the wheel picker.
  ACWheelPickerThemeData get wheelPickerTheme;

  /// Theme of the month title.
  ACTitledMonthThemeData get titledMonthTheme;

  /// Theme of the time input.
  ACTimeInputThemeData get timeInputTheme;

  /// Theme of the time title.
  ACTitledTimeThemeData get titledTimeTheme;

  /// Calendar background color.
  Color get backgroundColor;

  /// Creates a copy with the modified fields.
  ACCalendarThemeData copyWith();

  /// Interpolates between the current value and [other] at parameter [t].
  ACCalendarThemeData lerp(ACCalendarThemeData? other, double t);
}

/// Light implementation of [ACCalendarThemeData].
class ACLightCalendarThemeData implements ACCalendarThemeData {
  /// Creates a light calendar theme with optional sub-theme overrides.
  factory ACLightCalendarThemeData({
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
      ACLightCalendarThemeData.raw(
        pagesCalendarHeaderTheme:
            pagesCalendarHeaderTheme ?? ACLightPagesCalendarHeaderThemeData(),
        dayTheme: dayTheme ?? ACLightDayThemeData(),
        weekTheme: weekTheme ?? ACLightWeekThemeData(),
        monthPickerTheme: monthPickerTheme ?? ACLightMonthPickerThemeData(),
        wheelPickerTheme: wheelPickerTheme ?? ACLightWheelPickerThemeData(),
        titledMonthTheme: titledMonthTheme ?? ACLightTitledMonthThemeData(),
        timeInputTheme: timeInputTheme ?? ACLightTimeInputThemeData(),
        titledTimeTheme: titledTimeTheme ?? ACLightTitledTimeThemeData(),
        backgroundColor: backgroundColor ?? const Color(0xFFFFFFFF),
      );

  /// Creates a light calendar theme with explicitly provided values for all fields.
  const ACLightCalendarThemeData.raw({
    required this.pagesCalendarHeaderTheme,
    required this.dayTheme,
    required this.weekTheme,
    required this.monthPickerTheme,
    required this.wheelPickerTheme,
    required this.titledMonthTheme,
    required this.timeInputTheme,
    required this.titledTimeTheme,
    required this.backgroundColor,
  });

  @override
  final ACPagesCalendarHeaderThemeData pagesCalendarHeaderTheme;

  @override
  final ACDayThemeData dayTheme;

  @override
  final ACWeekThemeData weekTheme;

  @override
  final ACMonthPickerThemeData monthPickerTheme;

  @override
  final ACWheelPickerThemeData wheelPickerTheme;

  @override
  final ACTitledMonthThemeData titledMonthTheme;

  @override
  final ACTimeInputThemeData timeInputTheme;

  @override
  final ACTitledTimeThemeData titledTimeTheme;

  @override
  final Color backgroundColor;

  @override
  ACLightCalendarThemeData copyWith({
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
      ACLightCalendarThemeData.raw(
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
  ACLightCalendarThemeData lerp(ACCalendarThemeData? other, double t) {
    if (other == null) return this;
    return ACLightCalendarThemeData.raw(
      pagesCalendarHeaderTheme:
          pagesCalendarHeaderTheme.lerp(other.pagesCalendarHeaderTheme, t),
      dayTheme: dayTheme.lerp(other.dayTheme, t),
      weekTheme: weekTheme.lerp(other.weekTheme, t),
      monthPickerTheme: monthPickerTheme.lerp(other.monthPickerTheme, t),
      wheelPickerTheme: wheelPickerTheme.lerp(other.wheelPickerTheme, t),
      titledMonthTheme: titledMonthTheme.lerp(other.titledMonthTheme, t),
      timeInputTheme: timeInputTheme.lerp(other.timeInputTheme, t),
      titledTimeTheme: titledTimeTheme.lerp(other.titledTimeTheme, t),
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t) ??
          backgroundColor,
    );
  }
}

/// [ThemeExtension] wrapper for [ACCalendarThemeData].
///
/// Used to pass the calendar theme through Flutter's standard
/// `ThemeData.extensions` mechanism:
/// ```dart
/// ThemeData(extensions: [ACCalendarThemeExtension(data: ACLightCalendarThemeData(...))])
/// ```
class ACCalendarThemeExtension
    extends ThemeExtension<ACCalendarThemeExtension> {
  /// Creates a theme extension with the given [data].
  const ACCalendarThemeExtension({required this.data});

  /// Calendar theme data.
  final ACCalendarThemeData data;

  /// Returns the [ACCalendarThemeData] from the nearest [Theme],
  /// or creates an instance with default values.
  static ACCalendarThemeData of(BuildContext context) {
    return Theme.of(context).extension<ACCalendarThemeExtension>()?.data ??
        ACLightCalendarThemeData();
  }

  @override
  ACCalendarThemeExtension copyWith({ACCalendarThemeData? data}) =>
      ACCalendarThemeExtension(data: data ?? this.data);

  @override
  ACCalendarThemeExtension lerp(ACCalendarThemeExtension? other, double t) {
    if (other is! ACCalendarThemeExtension) return this;
    return ACCalendarThemeExtension(data: data.lerp(other.data, t));
  }
}
