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
  ACCalendarScope({
    required this.theme,
    required this.dateRange,
    required Widget child,
    this.selectController,
    super.key,
  }) : super(
    child: ACCalendarTheme(
      data: theme,
      child: child
    )
  );

  /// Тема календаря.
  final ACCalendarThemeData theme;

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
    theme != oldWidget.theme ||
    dateRange != oldWidget.dateRange ||
    selectController != oldWidget.selectController;
}
