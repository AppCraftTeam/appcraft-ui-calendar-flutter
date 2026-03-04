import 'package:flutter/widgets.dart';

import '../../data/src/ac_calendar_repository.dart';
import '../../data/src/ac_default_calendar_repository.dart';
import '../../domain/src/ac_date_range.dart';
import '../../localization/localization.dart';
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
    ACCalendarRepository? repository,
    ACCalendarThemeData? theme,
    ACCalendarSelectController? selectController,
    ACLocalizationManager? localizationManager,
    Key? key,
  }) => ACCalendarScope.raw(
    dateRange: dateRange,
    repository: repository ?? const ACDefaultCalendarRepository(),
    selectController: selectController,
    localizationManager: localizationManager,
    key: key,
    child: ACCalendarTheme(
      data: theme ?? ACLightCalendarThemeData(),
      child: child,
    ),
  );

  const ACCalendarScope.raw({
    required this.dateRange,
    required this.repository,
    required super.child,
    this.selectController,
    this.localizationManager,
    super.key,
  });

  /// Репозиторий для вычислений календаря.
  final ACCalendarRepository repository;

  /// Диапазон допустимых дат календаря.
  final ACDateRange dateRange;

  /// Контроллер выбора дат. Может быть null, если выбор не используется.
  final ACCalendarSelectController? selectController;

  /// Менеджер локализации. Если null, используется [ACDefaultLocalizationManager].
  final ACLocalizationManager? localizationManager;

  /// Возвращает локализацию для указанной локали.
  ACLocalization localization(String? locale) =>
    (localizationManager ?? const ACDefaultLocalizationManager())
      .localization(locale);

  /// Возвращает true, если [day] входит в допустимый диапазон [dateRange].
  bool shouldSelectDay(DateTime day) =>
    !day.isBefore(dateRange.min) && !day.isAfter(dateRange.max);

  /// Возвращает ближайший [ACCalendarScope] из контекста.
  /// Возвращает null, если scope не найден.
  static ACCalendarScope? maybeOf(BuildContext context) =>
    context.dependOnInheritedWidgetOfExactType<ACCalendarScope>();

  @override
  bool updateShouldNotify(ACCalendarScope oldWidget) =>
    repository != oldWidget.repository ||
    dateRange != oldWidget.dateRange ||
    selectController != oldWidget.selectController ||
    localizationManager != oldWidget.localizationManager;
}
