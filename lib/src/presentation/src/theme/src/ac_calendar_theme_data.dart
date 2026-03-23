import 'package:flutter/material.dart';

import 'ac_day_theme_data.dart';
import 'ac_month_picker_theme_data.dart';
import 'ac_pages_calendar_header_theme_data.dart';
import 'ac_time_input_theme_data.dart';
import 'ac_titled_month_theme_data.dart';
import 'ac_titled_time_theme_data.dart';
import 'ac_week_theme_data.dart';
import 'ac_wheel_picker_theme_data.dart';

/// Класс данных темы оформления календаря.
///
/// Содержит все sub-themes для различных компонентов календаря.
/// Используется совместно с [ACCalendarThemeExtension] для передачи
/// через `ThemeData(extensions: [ACCalendarThemeExtension(data: ACCalendarThemeData(...))])`.
class ACCalendarThemeData {
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

  /// Создаёт копию с изменёнными полями.
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

  /// Интерполирует между текущим и [other] при параметре [t].
  ACCalendarThemeData lerp(ACCalendarThemeData? other, double t) {
    if (other == null) return this;
    return ACCalendarThemeData.raw(
      pagesCalendarHeaderTheme:
          pagesCalendarHeaderTheme.lerp(other.pagesCalendarHeaderTheme, t),
      dayTheme: dayTheme.lerp(other.dayTheme, t),
      weekTheme: weekTheme.lerp(other.weekTheme, t),
      monthPickerTheme: monthPickerTheme.lerp(other.monthPickerTheme, t),
      wheelPickerTheme: wheelPickerTheme.lerp(other.wheelPickerTheme, t),
      titledMonthTheme: titledMonthTheme.lerp(other.titledMonthTheme, t),
      timeInputTheme: timeInputTheme.lerp(other.timeInputTheme, t),
      titledTimeTheme: titledTimeTheme.lerp(other.titledTimeTheme, t),
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
    );
  }
}

/// [ThemeExtension]-обёртка для [ACCalendarThemeData].
///
/// Используется для передачи темы календаря через стандартный механизм
/// Flutter `ThemeData.extensions`:
/// ```dart
/// ThemeData(extensions: [ACCalendarThemeExtension(data: ACCalendarThemeData(...))])
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
        ACCalendarThemeData();
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

/// Обратная совместимость: typedef для [ACCalendarThemeData].
typedef ACLightCalendarThemeData = ACCalendarThemeData;
