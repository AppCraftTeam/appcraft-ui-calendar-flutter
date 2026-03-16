import 'package:flutter/widgets.dart';

import 'ac_calendar_theme_data.dart';

class ACCalendarTheme extends InheritedWidget {
  const ACCalendarTheme({
    required this.data,
    required super.child,
    super.key,
  });

  final ACCalendarThemeData data;

  static ACCalendarThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ACCalendarTheme>()?.data ??
      ACLightCalendarThemeData();

  @override
  bool updateShouldNotify(ACCalendarTheme oldWidget) => data != oldWidget.data;
}
