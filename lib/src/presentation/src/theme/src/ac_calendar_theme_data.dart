import 'ac_day_theme_data.dart';
import 'ac_month_picker_theme_data.dart';
import 'ac_pages_calendar_header_theme_data.dart';
import 'ac_time_input_theme_data.dart';
import 'ac_titled_month_theme_data.dart';
import 'ac_titled_time_theme_data.dart';
import 'ac_week_theme_data.dart';
import 'ac_wheel_picker_theme_data.dart';

abstract class ACCalendarThemeData {
  ACPagesCalendarHeaderThemeData get pagesCalendarHeaderTheme;
  ACDayThemeData get dayTheme;
  ACWeekThemeData get weekTheme;
  ACMonthPickerThemeData get monthPickerTheme;
  ACWheelPickerThemeData get wheelPickerTheme;
  ACTitledMonthThemeData get titledMonthTheme;
  ACTimeInputThemeData get timeInputTheme;
  ACTitledTimeThemeData get titledTimeTheme;

  ACCalendarThemeData copyWith();
}

class ACLightCalendarThemeData implements ACCalendarThemeData {
  factory ACLightCalendarThemeData({
    ACPagesCalendarHeaderThemeData? pagesCalendarHeaderTheme,
    ACDayThemeData? dayTheme,
    ACWeekThemeData? weekTheme,
    ACMonthPickerThemeData? monthPickerTheme,
    ACWheelPickerThemeData? wheelPickerTheme,
    ACTitledMonthThemeData? titledMonthTheme,
    ACTimeInputThemeData? timeInputTheme,
    ACTitledTimeThemeData? titledTimeTheme,
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
      );

  const ACLightCalendarThemeData.raw({
    required this.pagesCalendarHeaderTheme,
    required this.dayTheme,
    required this.weekTheme,
    required this.monthPickerTheme,
    required this.wheelPickerTheme,
    required this.titledMonthTheme,
    required this.timeInputTheme,
    required this.titledTimeTheme,
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
  ACLightCalendarThemeData copyWith({
    ACPagesCalendarHeaderThemeData? pagesCalendarHeaderTheme,
    ACDayThemeData? dayTheme,
    ACWeekThemeData? weekTheme,
    ACMonthPickerThemeData? monthPickerTheme,
    ACWheelPickerThemeData? wheelPickerTheme,
    ACTitledMonthThemeData? titledMonthTheme,
    ACTimeInputThemeData? timeInputTheme,
    ACTitledTimeThemeData? titledTimeTheme,
  }) =>
      ACLightCalendarThemeData(
        pagesCalendarHeaderTheme: pagesCalendarHeaderTheme,
        dayTheme: dayTheme,
        weekTheme: weekTheme,
        monthPickerTheme: monthPickerTheme,
        wheelPickerTheme: wheelPickerTheme,
        titledMonthTheme: titledMonthTheme,
        timeInputTheme: timeInputTheme,
        titledTimeTheme: titledTimeTheme,
      );
}
