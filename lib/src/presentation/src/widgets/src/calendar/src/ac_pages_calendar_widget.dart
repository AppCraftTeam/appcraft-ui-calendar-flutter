import 'package:flutter/material.dart';

import '../../../../../../data/src/ac_calendar_repository.dart';
import '../../../../../../data/src/ac_default_calendar_repository.dart';
import '../../../../../../domain/src/ac_date_range.dart';
import '../../../../ac_calendar_scope.dart';
import '../../../../select_controller/ac_calendar_select_controller.dart';
import '../../../../theme/src/ac_calendar_theme_data.dart';
import '../../month/src/ac_month_layout.dart';
import '../../scroll_view/src/ac_scroll_view_controller.dart';
import '../../scroll_view/src/ac_scroll_view_data_source.dart';
import 'ac_raw_pages_calendar_widget.dart';

/// Календарь с постраничной навигацией по месяцам.
///
/// Отображает один месяц за раз с возможностью горизонтальной прокрутки
/// между месяцами в пределах заданного диапазона [range].
///
/// Включает заголовок с навигацией, строку дней недели и сетку дат месяца.
/// При нажатии на заголовок открывается `ACMonthPicker` для быстрого
/// перехода к нужному месяцу.
///
/// Оборачивает [ACRawPagesCalendarWidget] в [ACCalendarScope],
/// предоставляя тему и контроллер выбора дочерним виджетам.
class ACPagesCalendarWidget extends StatelessWidget {
  /// Создаёт постраничный календарь.
  const ACPagesCalendarWidget({
    required this.range,
    this.repository,
    this.locale,
    this.theme,
    this.selectController,
    this.initialMonth,
    this.spacing,
    this.timeWidget,
    this.scrollViewController,
    this.dayBuilder,
    this.monthBuilder,
    this.monthLayout,
    this.monthHeight,
    this.weekWidget,
    this.headerWidget,
    this.scrollViewDataSource,
    super.key,
  });

  /// Кастомный builder для виджета дня.
  ///
  /// Если задан, используется вместо стандартного `ACCalendarDayWidget`.
  final Widget Function(BuildContext context, DateTime day)? dayBuilder;

  /// Кастомный builder для виджета месяца.
  ///
  /// Если задан, используется вместо стандартного `ACMonthWidget`.
  /// При наличии `monthBuilder` параметр `dayBuilder` игнорируется.
  final Widget Function(BuildContext context, DateTime month)? monthBuilder;

  /// Фиксированная раскладка сетки месяца.
  ///
  /// Если задана, используется для всех месяцев вместо
  /// [ACDefaultMonthLayout.mainAxisCount6].
  final ACMonthLayout? monthLayout;

  /// Фиксированная высота сетки месяца.
  ///
  /// Если задана, используется вместо вычисленной высоты
  /// из `layout.calculateHeight`.
  final double? monthHeight;

  /// Репозиторий для вычислений календаря.
  ///
  /// Если не указан, используется `ACDefaultCalendarRepository`.
  final ACCalendarRepository? repository;

  /// Допустимый диапазон дат для навигации.
  final ACDateRange range;

  /// Локаль для форматирования дат (например, `'ru'`, `'en'`).
  ///
  /// Если не указана, используется системная локаль.
  final String? locale;

  /// Тема оформления календаря.
  ///
  /// Если не указана, используется [ACLightCalendarThemeData].
  final ACCalendarThemeData? theme;

  /// Контроллер выбора дат.
  ///
  /// Если не указан, выбор дат не поддерживается.
  final ACCalendarSelectController? selectController;

  /// Месяц, отображаемый при первом открытии календаря.
  ///
  /// Если не указан или выходит за пределы [range], используется
  /// текущий месяц (или ближайший допустимый).
  final DateTime? initialMonth;

  /// Отступ между элементами календаря (заголовок, строка недели, сетка дат).
  ///
  /// Если не указан, используется значение по умолчанию `12.0`.
  final double? spacing;

  /// Виджет, отображаемый под сеткой дат (например, ввод времени).
  ///
  /// Должен реализовывать [PreferredSizeWidget] для корректного расчёта высоты.
  final PreferredSizeWidget? timeWidget;

  /// Внешний контроллер прокрутки между месяцами.
  ///
  /// Если передан, используется вместо создаваемого по умолчанию.
  /// Вызывающий код несёт ответственность за [ACScrollViewController.dispose].
  final ACScrollViewController<DateTime>? scrollViewController;

  /// Кастомный виджет строки дней недели.
  ///
  /// Если задан, используется вместо стандартного `ACWeekWidget`.
  /// Должен реализовывать [PreferredSizeWidget].
  final PreferredSizeWidget? weekWidget;

  /// Кастомный виджет заголовка календаря.
  ///
  /// Если задан, используется вместо стандартного `ACPagesCalendarHeader`.
  /// Должен реализовывать [PreferredSizeWidget].
  final PreferredSizeWidget? headerWidget;

  /// Внешний источник данных для прокрутки между месяцами.
  ///
  /// Если передан, используется вместо создаваемого по умолчанию.
  /// Вызывающий код несёт ответственность за [ACScrollViewDataSource.dispose].
  final ACScrollViewDataSource<DateTime>? scrollViewDataSource;

  @override
  Widget build(BuildContext context) => ACCalendarScope(
        repository: repository ?? const ACDefaultCalendarRepository(),
        dateRange: range,
        selectController: selectController,
        child: ACRawPagesCalendarWidget(
          range: range,
          repository: repository,
          locale: locale,
          theme: theme,
          initialMonth: initialMonth,
          spacing: spacing,
          timeWidget: timeWidget,
          scrollViewController: scrollViewController,
          dayBuilder: dayBuilder,
          monthBuilder: monthBuilder,
          monthLayout: monthLayout,
          monthHeight: monthHeight,
          weekWidget: weekWidget,
          headerWidget: headerWidget,
          scrollViewDataSource: scrollViewDataSource,
        ),
      );
}
