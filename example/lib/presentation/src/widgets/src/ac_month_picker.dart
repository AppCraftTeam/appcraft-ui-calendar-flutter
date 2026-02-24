import 'package:flutter/material.dart';

import '../../../../data/data.dart';
import '../../../../domain/domain.dart';
import '../../../../utils/utils.dart';
import '../../../presentation.dart';

class ACMonthPicker extends StatefulWidget {
  const ACMonthPicker({
    required this.range,
    this.onDateChanged,
    this.initialDate,
    this.locale,
    this.monthPickerTheme,
    this.wheelPickerTheme,
    super.key,
  });

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

  /// Тема пикера. Если не задана, берётся из [ACCalendarTheme].
  final ACMonthPickerThemeData? monthPickerTheme;

  /// Тема колёсного пикера. Если не задана, берётся из [ACCalendarTheme].
  final ACWheelPickerThemeData? wheelPickerTheme;

  @override
  State<ACMonthPicker> createState() => _ACMonthPickerState();
}

class _ACMonthPickerState extends State<ACMonthPicker> {
  final _calendarRepository = const ACCalendarRepository();

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
    
    _years = _calendarRepository.getYears(
      range: widget.range
    );

    _months = _calendarRepository.getMonths(
      year: _selectedYear,
      range: widget.range
    );
    
    // Проверяем, что выбранный месяц доступен
    if (!_months.contains(_selectedMonth)) {
      _selectedMonth = _months.first;
    }
  }

  void _onYearChanged(int year) {
    setState(() {
      _selectedYear = year;

      _months = _calendarRepository.getMonths(
        year: _selectedYear,
        range: widget.range
      );
      
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
    final theme = widget.monthPickerTheme ?? ACCalendarTheme.of(context).monthPickerTheme;
    final locale = widget.locale ?? Localizations.maybeLocaleOf(context)?.toLanguageTag();

    return Stack(
      children: [
        Center(
          child: Container(
            height: 36,
            decoration: BoxDecoration(
              color: theme.selectionColor,
              borderRadius: BorderRadius.circular(18)
            )
          ),
        ),
    
        Row(
          children: [
            Expanded(
              child: ACWheelPicker<int>(

                // Пересоздаем при смене года
                key: ValueKey(_selectedYear),
                items: _months,
                initialItem: _selectedMonth,
                textForItem: (month) =>
                  ACDateFormat
                    .month(locale)
                    .format(
                      DateTime(_selectedYear, month)
                    )
                    .toUpperCaseFirstLetter(),
                onSelectedItemChanged: _onMonthChanged
              ),
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