import 'package:flutter/material.dart';

import '../../../../../../data/src/ac_calendar_repository.dart';
import '../../../../../../data/src/ac_default_calendar_repository.dart';
import '../../../../../../domain/src/ac_date_range.dart';
import '../../../../ac_calendar_scope.dart';
import '../../../../select_controller/ac_calendar_select_controller.dart';
import '../../../../theme/src/ac_calendar_theme_data.dart';
import '../../scroll_view/src/ac_scroll_view_controller.dart';
import 'ac_raw_calendar_widget.dart';

/// Календарь с вертикальной прокруткой по месяцам.
///
/// Отображает непрерывную ленту месяцев с возможностью вертикальной прокрутки
/// в пределах заданного диапазона [range].
///
/// Оборачивает [ACRawCalendarWidget] в [ACCalendarScope],
/// предоставляя тему и контроллер выбора дочерним виджетам.
class ACCalendarWidget extends StatelessWidget {
  /// Создаёт календарь с вертикальной прокруткой.
  const ACCalendarWidget({
    required this.range,
    this.repository,
    this.theme,
    this.selectController,
    this.scrollViewController,
    this.initialDate,
    this.onVisibleDateChanged,
    this.timeWidget,
    this.scrollViewPadding,
    this.weekPadding,
    this.timeWidgetPadding,
    super.key,
  });

  /// Репозиторий для вычислений календаря.
  ///
  /// Если не указан, используется `ACDefaultCalendarRepository`.
  final ACCalendarRepository? repository;

  /// Допустимый диапазон дат для навигации.
  final ACDateRange range;

  /// Тема оформления календаря.
  ///
  /// Если не указана, используется `ACLightCalendarThemeData`.
  final ACCalendarThemeData? theme;

  /// Контроллер выбора дат.
  ///
  /// Если не указан, выбор дат не поддерживается.
  final ACCalendarSelectController? selectController;

  /// Контроллер прокрутки.
  ///
  /// Если не указан, создаётся автоматически внутри виджета.
  final ACScrollViewController<DateTime>? scrollViewController;

  /// Дата, к которой будет выполнена прокрутка при первом открытии.
  ///
  /// Если не указана или выходит за пределы [range], используется текущая дата
  /// (или ближайший допустимый месяц).
  final DateTime? initialDate;

  /// Вызывается при смене видимого месяца во время прокрутки.
  final void Function(DateTime visibleDate)? onVisibleDateChanged;

  /// Виджет, отображаемый под лентой месяцев (например, ввод времени).
  ///
  /// Должен реализовывать [PreferredSizeWidget] для корректного расчёта высоты.
  final PreferredSizeWidget? timeWidget;

  /// Отступы вокруг ленты месяцев.
  final EdgeInsetsGeometry? scrollViewPadding;

  /// Отступы вокруг `ACWeekWidget`.
  final EdgeInsetsGeometry? weekPadding;

  /// Отступы вокруг [timeWidget].
  final EdgeInsetsGeometry? timeWidgetPadding;

  @override
  Widget build(BuildContext context) => ACCalendarScope(
        repository: repository ?? const ACDefaultCalendarRepository(),
        dateRange: range,
        selectController: selectController,
        child: ACRawCalendarWidget(
          range: range,
          repository: repository,
          scrollViewController: scrollViewController,
          initialDate: initialDate,
          onVisibleDateChanged: onVisibleDateChanged,
          timeWidget: timeWidget,
          scrollViewPadding: scrollViewPadding,
          weekPadding: weekPadding,
          timeWidgetPadding: timeWidgetPadding,
        ),
      );
}
