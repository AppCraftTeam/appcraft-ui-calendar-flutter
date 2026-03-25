import 'package:flutter/material.dart';

import '../../../../../../data/src/ac_calendar_repository.dart';
import '../../../../../../data/src/ac_default_calendar_repository.dart';
import '../../../../../../domain/src/ac_date_range.dart';
import '../../../../ac_calendar_scope.dart';
import '../../../../select_controller/ac_calendar_select_controller.dart';
import '../../../../theme/src/ac_calendar_theme_data.dart';
import '../../month/src/ac_month_layout.dart';
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
    this.dayBuilder,
    this.monthBuilder,
    this.monthLayoutBuilder,
    this.monthHeightBuilder,
    this.weekWidget,
    this.timeWidgetPadding,
    super.key,
  });

  /// Кастомный builder для виджета дня.
  ///
  /// Если задан, используется вместо стандартного `ACCalendarDayWidget`.
  final Widget Function(BuildContext context, DateTime day)? dayBuilder;

  /// Кастомный builder для виджета месяца.
  ///
  /// Если задан, используется вместо стандартного `ACTitledMonthWidget`.
  /// При наличии `monthBuilder` параметр `dayBuilder` игнорируется.
  final Widget Function(BuildContext context, DateTime month)? monthBuilder;

  /// Кастомный builder для раскладки месяца.
  ///
  /// Вызывается для каждого месяца, позволяя задать раскладку индивидуально.
  /// Если не задан, раскладка рассчитывается автоматически.
  final ACMonthLayout Function(BuildContext context, DateTime month)?
      monthLayoutBuilder;

  /// Кастомный builder для высоты месяца.
  ///
  /// Вызывается для каждого месяца, позволяя задать высоту индивидуально.
  /// Если не задан, высота рассчитывается автоматически.
  final double Function(BuildContext context, DateTime month)?
      monthHeightBuilder;

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

  /// Кастомный виджет строки дней недели.
  ///
  /// Если задан, используется вместо стандартного `ACWeekWidget`.
  /// Должен реализовывать [PreferredSizeWidget].
  final PreferredSizeWidget? weekWidget;

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
          theme: theme,
          scrollViewController: scrollViewController,
          initialDate: initialDate,
          onVisibleDateChanged: onVisibleDateChanged,
          timeWidget: timeWidget,
          scrollViewPadding: scrollViewPadding,
          weekPadding: weekPadding,
          dayBuilder: dayBuilder,
          monthBuilder: monthBuilder,
          monthLayoutBuilder: monthLayoutBuilder,
          monthHeightBuilder: monthHeightBuilder,
          weekWidget: weekWidget,
          timeWidgetPadding: timeWidgetPadding,
        ),
      );
}
