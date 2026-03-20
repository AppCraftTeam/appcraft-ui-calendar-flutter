import 'package:flutter/widgets.dart';

import '../data/ac_calendar_repository.dart';
import '../data/ac_default_calendar_repository.dart';
import '../domain/ac_date_range.dart';
import '../localization/ac_default_localization_manager.dart';
import '../localization/ac_localization.dart';
import '../localization/ac_localization_manager.dart';
import '../select_controller/ac_calendar_select_controller.dart';

/// InheritedWidget, предоставляющий диапазон дат, репозиторий и контроллер выбора
/// вниз по дереву виджетов.
///
/// Тема передаётся через `ThemeData.extensions` с использованием
/// `ACCalendarThemeData`, а не через этот scope.
class ACCalendarScope extends InheritedWidget {
  /// Создаёт [ACCalendarScope].
  ///
  /// Если [repository] не передан, используется [ACDefaultCalendarRepository].
  ACCalendarScope({
    required this.dateRange,
    required super.child,
    ACCalendarRepository? repository,
    this.selectController,
    this.localizationManager,
    super.key,
  }) : repository = repository ?? const ACDefaultCalendarRepository();

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
