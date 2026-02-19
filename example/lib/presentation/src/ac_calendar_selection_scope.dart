import 'package:flutter/widgets.dart';

import 'select_controller/ac_calendar_select_controller.dart';

/// InheritedWidget, предоставляющий [ACCalendarSelectController] вниз по дереву виджетов.
///
/// Используется для передачи состояния выбора дней без необходимости
/// перестраивать весь календарь — каждый день подписывается
/// на изменения самостоятельно через [ACCalendarSelectionScope.maybeOf].
class ACCalendarSelectionScope extends InheritedWidget {
  const ACCalendarSelectionScope({
    required this.selectController,
    required super.child,
    super.key,
  });

  /// Контроллер выбора дат. Может быть null, если выбор не используется.
  final ACCalendarSelectController? selectController;

  /// Возвращает [ACCalendarSelectController] из ближайшего [ACCalendarSelectionScope].
  /// Возвращает null, если scope не найден или контроллер не задан.
  static ACCalendarSelectController? maybeOf(BuildContext context) =>
    context
      .dependOnInheritedWidgetOfExactType<ACCalendarSelectionScope>()
      ?.selectController;

  @override
  bool updateShouldNotify(ACCalendarSelectionScope oldWidget) =>
    selectController != oldWidget.selectController;
}
