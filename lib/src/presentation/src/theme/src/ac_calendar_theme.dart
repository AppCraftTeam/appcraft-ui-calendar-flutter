import 'package:flutter/widgets.dart';

import 'ac_calendar_theme_data.dart';

/// Виджет-обёртка для передачи [ACCalendarThemeData] вниз по дереву виджетов.
class ACCalendarTheme extends InheritedWidget {
  /// Создаёт виджет темы календаря.
  const ACCalendarTheme({
    required this.data,
    required super.child,
    super.key,
  });

  /// Данные темы календаря.
  final ACCalendarThemeData data;

  /// Возвращает [ACCalendarThemeData] из ближайшего [ACCalendarTheme],
  /// или создаёт экземпляр с дефолтными значениями.
  static ACCalendarThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ACCalendarTheme>()?.data ??
      ACLightCalendarThemeData();

  @override
  bool updateShouldNotify(ACCalendarTheme oldWidget) => data != oldWidget.data;
}
