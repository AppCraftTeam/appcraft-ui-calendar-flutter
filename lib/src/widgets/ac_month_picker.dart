import 'package:flutter/material.dart';

import '../data/ac_calendar_repository.dart';
import '../data/ac_default_calendar_repository.dart';
import '../domain/ac_date_format.dart';
import '../domain/ac_date_range.dart';
import '../theme/ac_calendar_theme_data.dart';
import '../theme/ac_month_picker_theme_data.dart';
import '../theme/ac_wheel_picker_theme_data.dart';
import '../utils/ac_string_ext.dart';
import 'ac_wheel_picker.dart';

/// Пикер выбора месяца и года на основе двух колёс прокрутки.
///
/// Отображает два [ACWheelPicker]: один для месяца, другой для года.
/// Набор доступных месяцев и лет ограничивается диапазоном [range].
class ACMonthPicker extends StatefulWidget {
  /// Создаёт пикер месяца и года.
  const ACMonthPicker({
    required this.range,
    this.repository,
    this.onDateChanged,
    this.initialDate,
    this.locale,
    this.monthPickerTheme,
    this.wheelPickerTheme,
    super.key,
  });

  /// Репозиторий для вычислений календаря.
  ///
  /// Если не указан, используется [ACDefaultCalendarRepository].
  final ACCalendarRepository? repository;

  /// Допустимый диапазон дат; ограничивает набор доступных месяцев и лет.
  final ACDateRange range;

  /// Начальная дата, определяющая выбранный месяц и год при открытии пикера.
  /// Если не задана, используется [ACDateRange.min].
  final DateTime? initialDate;

  /// Вызывается при изменении выбранной даты (месяц или год).
  final void Function(DateTime date)? onDateChanged;

  /// Локаль для форматирования названий месяцев.
  /// Если не задана, берётся из [Localizations].
  final String? locale;

  /// Тема пикера. Если не задана, берётся из [ACCalendarThemeData].
  final ACMonthPickerThemeData? monthPickerTheme;

  /// Тема колёсного пикера. Если не задана, берётся из [ACCalendarThemeData].
  final ACWheelPickerThemeData? wheelPickerTheme;

  @override
  State<ACMonthPicker> createState() => _ACMonthPickerState();
}

class _ACMonthPickerState extends State<ACMonthPicker> {
  late final ACCalendarRepository _calendarRepository =
      widget.repository ?? const ACDefaultCalendarRepository();

  late List<int> _years;
  late List<int> _months;

  late int _selectedYear;
  late int _selectedMonth;

  @override
  void initState() {
    super.initState();

    final initial = widget.initialDate ?? widget.range.min;
    _selectedYear = initial.year;
    _selectedMonth = initial.month;

    _years = _calendarRepository.getYears(range: widget.range);

    _months =
        _calendarRepository.getMonths(year: _selectedYear, range: widget.range);

    // Проверяем, что выбранный месяц доступен
    if (!_months.contains(_selectedMonth)) {
      _selectedMonth = _months.first;
    }
  }

  void _onYearChanged(int year) {
    setState(() {
      _selectedYear = year;

      _months = _calendarRepository.getMonths(
          year: _selectedYear, range: widget.range);

      // Если выбранный месяц больше не доступен, выбираем первый доступный
      if (!_months.contains(_selectedMonth)) {
        _selectedMonth = _months.first;
      }
    });

    _notifyDateChanged();
  }

  void _onMonthChanged(int month) {
    setState(() {
      _selectedMonth = month;
    });

    _notifyDateChanged();
  }

  void _notifyDateChanged() {
    final date = DateTime(_selectedYear, _selectedMonth);
    widget.onDateChanged?.call(date);
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.monthPickerTheme ??
        ACCalendarThemeData.of(context).monthPickerTheme;
    final locale =
        widget.locale ?? Localizations.maybeLocaleOf(context)?.toLanguageTag();

    return Stack(
      children: [
        Center(
          child: Container(
              height: 36,
              decoration: BoxDecoration(
                  color: theme.selectionColor,
                  borderRadius: BorderRadius.circular(18))),
        ),
        Row(
          children: [
            Expanded(
              child: ACWheelPicker<int>(

                  // Пересоздаем при смене года
                  key: ValueKey(_selectedYear),
                  items: _months,
                  initialItem: _selectedMonth,
                  textForItem: (month) => ACDateFormat.month(locale)
                      .format(DateTime(_selectedYear, month))
                      .toUpperCaseFirstLetter(),
                  onSelectedItemChanged: _onMonthChanged),
            ),
            Expanded(
              child: ACWheelPicker<int>(
                theme: widget.wheelPickerTheme,
                items: _years,
                initialItem: _selectedYear,
                onSelectedItemChanged: _onYearChanged,
              ),
            ),
          ],
        )
      ],
    );
  }
}
