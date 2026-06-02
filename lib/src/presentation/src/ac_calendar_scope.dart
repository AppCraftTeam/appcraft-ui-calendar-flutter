import 'package:flutter/widgets.dart';

import '../../data/src/ac_calendar_repository.dart';
import '../../data/src/ac_default_calendar_repository.dart';
import '../../domain/src/ac_date_range.dart';
import '../../localization/src/ac_default_localization_manager.dart';
import '../../localization/src/ac_localization.dart';
import '../../localization/src/ac_localization_manager.dart';
import 'select_controller/ac_calendar_select_controller.dart';

/// InheritedWidget that provides the date range, repository, and selection
/// controller down the widget tree.
///
/// The theme is passed via `ThemeData.extensions` using
/// `ACCalendarThemeData`, not through this scope.
class ACCalendarScope extends InheritedWidget {
  /// Creates an [ACCalendarScope].
  ///
  /// If [repository] is not provided, [ACDefaultCalendarRepository] is used.
  const ACCalendarScope({
    required this.dateRange,
    required super.child,
    this.repository = const ACDefaultCalendarRepository(),
    this.selectController,
    this.localizationManager,
    super.key,
  });

  /// Repository for calendar computations.
  final ACCalendarRepository repository;

  /// Range of valid calendar dates.
  final ACDateRange dateRange;

  /// Date selection controller. May be null if selection is not used.
  final ACCalendarSelectController? selectController;

  /// Localization manager. If null, [ACDefaultLocalizationManager] is used.
  final ACLocalizationManager? localizationManager;

  /// Returns the localization for the given locale.
  ACLocalization localization(String? locale) =>
      (localizationManager ?? const ACDefaultLocalizationManager())
          .localization(locale);

  /// Returns true if [day] falls within the valid [dateRange].
  bool shouldSelectDay(DateTime day) =>
      !day.isBefore(dateRange.min) && !day.isAfter(dateRange.max);

  /// Returns the nearest [ACCalendarScope] from the context.
  /// Returns null if no scope is found.
  static ACCalendarScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ACCalendarScope>();

  @override
  bool updateShouldNotify(ACCalendarScope oldWidget) =>
      repository != oldWidget.repository ||
      dateRange != oldWidget.dateRange ||
      selectController != oldWidget.selectController ||
      localizationManager != oldWidget.localizationManager;
}
