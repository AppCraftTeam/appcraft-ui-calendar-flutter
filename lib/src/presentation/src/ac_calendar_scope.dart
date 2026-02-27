import 'package:flutter/widgets.dart';

import '../../domain/src/ac_date_range.dart';
import 'select_controller/ac_calendar_select_controller.dart';
import 'theme/theme.dart';

/// InheritedWidget, предоставляющий тему, диапазон дат и контроллер выбора
/// вниз по дереву виджетов.
///
/// Оборачивает дочерний виджет в [ACCalendarTheme], обеспечивая совместимость
/// с обоими механизмами получения темы — через scope и напрямую.
class ACCalendarScope extends InheritedWidget {
  factory ACCalendarScope({
    required ACDateRange dateRange,
    required Widget child,
    ACCalendarThemeData? theme,
    ACCalendarSelectController? selectController,
    Key? key,
  }) => ACCalendarScope.raw(
    dateRange: dateRange,
    selectController: selectController,
    key: key,
    child: ACCalendarTheme(
      data: theme ?? ACLightCalendarThemeData(),
      child: child,
    ),
  );

  const ACCalendarScope.raw({
    required this.dateRange,
    required super.child,
    this.selectController,
    super.key,
  });

  /// Диапазон допустимых дат календаря.
  final ACDateRange dateRange;

  /// Контроллер выбора дат. Может быть null, если выбор не используется.
  final ACCalendarSelectController? selectController;

  /// Возвращает true, если [day] входит в допустимый диапазон [dateRange].
  bool shouldSelectDay(DateTime day) =>
    !day.isBefore(dateRange.min) && !day.isAfter(dateRange.max);

  /// Возвращает ближайший [ACCalendarScope] из контекста.
  /// Возвращает null, если scope не найден.
  static ACCalendarScope? maybeOf(BuildContext context) =>
    context.dependOnInheritedWidgetOfExactType<ACCalendarScope>();

  @override
  bool updateShouldNotify(ACCalendarScope oldWidget) =>
    dateRange != oldWidget.dateRange ||
    selectController != oldWidget.selectController;
}
