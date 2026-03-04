import 'package:flutter/material.dart';

import '../../../../../../data/src/ac_calendar_repository.dart';
import '../../../../../../domain/src/ac_date_range.dart';
import '../../../../../presentation.dart';

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
  const ACPagesCalendarWidget({
    required this.range,
    this.repository,
    this.locale,
    this.theme,
    this.selectController,
    this.initialMonth,
    this.spacing,
    this.timeWidget,
    super.key,
  });

  /// Репозиторий для вычислений календаря.
  ///
  /// Если не указан, используется [ACDefaultCalendarRepository].
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

  @override
  Widget build(BuildContext context) =>
    ACCalendarScope(
      repository: repository,
      theme: theme,
      dateRange: range,
      selectController: selectController,
      child: ACRawPagesCalendarWidget(
        range: range,
        repository: repository,
        locale: locale,
        initialMonth: initialMonth,
        spacing: spacing,
        timeWidget: timeWidget,
      ),
    );
}
