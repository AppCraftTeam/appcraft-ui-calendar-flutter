import 'package:flutter/material.dart';

import '../../../../../../data/src/ac_calendar_repository.dart';
import '../../../../../../data/src/ac_default_calendar_repository.dart';
import '../../../../../../domain/src/ac_date_format.dart';
import '../../../../../../domain/src/ac_date_range.dart';
import '../../../../../../utils/src/ac_string_ext.dart';
import '../../../../theme/src/ac_calendar_theme_data.dart';
import '../../ac_wheel_picker.dart';

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
    this.theme,
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

  /// Тема оформления календаря.
  ///
  /// Если не задана, берётся из [ACCalendarThemeExtension].
  final ACCalendarThemeData? theme;

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
    final calendarTheme = widget.theme ?? ACCalendarThemeExtension.of(context);
    final theme = calendarTheme.monthPickerTheme;
    final wheelPickerTheme = calendarTheme.wheelPickerTheme;
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
                theme: wheelPickerTheme,
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
