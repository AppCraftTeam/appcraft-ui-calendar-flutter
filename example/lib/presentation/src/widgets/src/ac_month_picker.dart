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
    this.theme,
    super.key,
  });

  final ACDateRange range;
  final DateTime? initialDate;
  final void Function(DateTime date)? onDateChanged;
  final String? locale;
  final ACCalendarThemeData? theme;

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
    final theme = widget.theme ?? ACCalendarScope.maybeOf(context)?.theme ?? ACLightCalendarThemeData();
    final locale = widget.locale ?? Localizations.maybeLocaleOf(context)?.toLanguageTag();

    return Stack(
      children: [
        Center(
          child: Container(
            height: 36,
            decoration: BoxDecoration(
              // TODO: Add to props
              color: theme.accentColor,
              borderRadius: BorderRadius.circular(18)
            )
          ),
        ),
    
        Row(
          children: [
            Expanded(
              child: ACWheelPicker<int>(
                theme: theme.wheelTheme,
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
                theme: theme.wheelTheme,
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