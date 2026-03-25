import 'package:flutter/material.dart';

import 'ac_day_theme_data.dart';
import 'ac_month_picker_theme_data.dart';
import 'ac_pages_calendar_header_theme_data.dart';
import 'ac_time_input_theme_data.dart';
import 'ac_titled_month_theme_data.dart';
import 'ac_titled_time_theme_data.dart';
import 'ac_week_theme_data.dart';
import 'ac_wheel_picker_theme_data.dart';

/// Абстрактный класс данных темы оформления календаря.
///
/// Содержит все sub-themes для различных компонентов календаря.
/// Используется совместно с [ACCalendarThemeExtension] для передачи
/// через `ThemeData(extensions: [ACCalendarThemeExtension(data: ACLightCalendarThemeData(...))])`.
abstract class ACCalendarThemeData {
  /// Тема заголовка постраничного календаря.
  ACPagesCalendarHeaderThemeData get pagesCalendarHeaderTheme;

  /// Тема виджета дня.
  ACDayThemeData get dayTheme;

  /// Тема строки дней недели.
  ACWeekThemeData get weekTheme;

  /// Тема пикера месяца.
  ACMonthPickerThemeData get monthPickerTheme;

  /// Тема колёсного пикера.
  ACWheelPickerThemeData get wheelPickerTheme;

  /// Тема заголовка месяца.
  ACTitledMonthThemeData get titledMonthTheme;

  /// Тема ввода времени.
  ACTimeInputThemeData get timeInputTheme;

  /// Тема заголовка времени.
  ACTitledTimeThemeData get titledTimeTheme;

  /// Цвет фона календаря.
  Color get backgroundColor;

  /// Создаёт копию с изменёнными полями.
  ACCalendarThemeData copyWith();

  /// Интерполирует между текущим и [other] при параметре [t].
  ACCalendarThemeData lerp(ACCalendarThemeData? other, double t);
}

/// Светлая реализация [ACCalendarThemeData].
class ACLightCalendarThemeData implements ACCalendarThemeData {
  /// Создаёт светлую тему календаря с опциональными переопределениями sub-themes.
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

  /// Создаёт светлую тему календаря с явно заданными значениями всех полей.
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

/// [ThemeExtension]-обёртка для [ACCalendarThemeData].
///
/// Используется для передачи темы календаря через стандартный механизм
/// Flutter `ThemeData.extensions`:
/// ```dart
/// ThemeData(extensions: [ACCalendarThemeExtension(data: ACLightCalendarThemeData(...))])
/// ```
class ACCalendarThemeExtension
    extends ThemeExtension<ACCalendarThemeExtension> {
  /// Создаёт расширение темы с заданными данными [data].
  const ACCalendarThemeExtension({required this.data});

  /// Данные темы календаря.
  final ACCalendarThemeData data;

  /// Возвращает [ACCalendarThemeData] из ближайшего [Theme],
  /// или создаёт экземпляр с дефолтными значениями.
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
