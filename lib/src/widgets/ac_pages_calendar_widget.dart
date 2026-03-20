import 'package:flutter/material.dart';

import '../data/ac_calendar_repository.dart';
import '../domain/ac_date_range.dart';
import '../select_controller/ac_calendar_select_controller.dart';
import '../theme/ac_calendar_theme_data.dart';
import 'ac_calendar_scope.dart';
import 'ac_raw_pages_calendar_widget.dart';
import 'ac_scroll_view_controller.dart';
import 'ac_scroll_view_data_source.dart';

/// Календарь с постраничной навигацией по месяцам.
///
/// Отображает один месяц за раз с возможностью горизонтальной прокрутки
/// между месяцами в пределах заданного диапазона [range].
///
/// Включает заголовок с навигацией, строку дней недели и сетку дат месяца.
/// При нажатии на заголовок открывается [ACMonthPicker] для быстрого
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
    this.scrollViewDataSource,
    super.key,
  });

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

  /// Внешний источник данных для прокрутки между месяцами.
  ///
  /// Если передан, используется вместо создаваемого по умолчанию.
  /// Вызывающий код несёт ответственность за [ACScrollViewDataSource.dispose].
  final ACScrollViewDataSource<DateTime>? scrollViewDataSource;

  @override
  Widget build(BuildContext context) => ACCalendarScope(
        repository: repository,
        dateRange: range,
        selectController: selectController,
        child: ACRawPagesCalendarWidget(
          range: range,
          repository: repository,
          locale: locale,
          initialMonth: initialMonth,
          spacing: spacing,
          timeWidget: timeWidget,
          scrollViewController: scrollViewController,
          scrollViewDataSource: scrollViewDataSource,
        ),
      );
}
