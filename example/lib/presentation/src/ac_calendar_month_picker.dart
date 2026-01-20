import 'package:example/ac_date_range.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'ac_wheel_picker.dart';

class ACCalendarMonthPicker extends StatefulWidget {
  const ACCalendarMonthPicker({
    required this.range,
    this.onDateChanged,
    this.initialDate,
    this.locale = 'ru_RU',
    super.key,
  });

  final ACDateRange range;
  final DateTime? initialDate;
  final void Function(DateTime date)? onDateChanged;
  final String locale;

  @override
  State<ACCalendarMonthPicker> createState() => _ACCalendarMonthPickerState();
}

class _ACCalendarMonthPickerState extends State<ACCalendarMonthPicker> {
  late int _selectedYear;
  late int _selectedMonth;
  late List<int> _years;
  late List<int> _months;
  late List<String> _monthNames;

  @override
  void initState() {
    super.initState();
    
    _monthNames = _generateMonthNames();
    
    final initial = widget.initialDate ?? widget.range.min;
    _selectedYear = initial.year;
    _selectedMonth = initial.month;
    
    _years = _generateYears();
    _months = _generateMonths(_selectedYear);
    
    // Проверяем, что выбранный месяц доступен
    if (!_months.contains(_selectedMonth)) {
      _selectedMonth = _months.first;
    }
  }

  List<String> _generateMonthNames() {
    final format = DateFormat.MMMM(widget.locale);
    return List.generate(12, (index) {
      final date = DateTime(2000, index + 1);
      final monthName = format.format(date);
      // Делаем первую букву заглавной
      return monthName[0].toUpperCase() + monthName.substring(1);
    });
  }

  List<int> _generateYears() {
    final years = <int>[];
    for (int year = widget.range.min.year; year <= widget.range.max.year; year++) {
      years.add(year);
    }
    return years;
  }

  List<int> _generateMonths(int year) {
    final months = <int>[];
    
    int startMonth = 1;
    int endMonth = 12;
    
    // Если это минимальный год, начинаем с минимального месяца
    if (year == widget.range.min.year) {
      startMonth = widget.range.min.month;
    }
    
    // Если это максимальный год, заканчиваем максимальным месяцем
    if (year == widget.range.max.year) {
      endMonth = widget.range.max.month;
    }
    
    for (int month = startMonth; month <= endMonth; month++) {
      months.add(month);
    }
    
    return months;
  }

  void _onYearChanged(int year) {
    setState(() {
      _selectedYear = year;
      _months = _generateMonths(year);
      
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
    return Row(
      children: [
        // Picker для месяцев
        Expanded(
          flex: 2,
          child: ACWheelPicker<String>(
            // Пересоздаем при смене года
            key: ValueKey(_selectedYear),
            items: _months.map((m) => _monthNames[m - 1]).toList(),
            initialItem: _monthNames[_selectedMonth - 1],
            onSelectedItemChanged: (monthName) {
              final monthIndex = _monthNames.indexOf(monthName) + 1;
              _onMonthChanged(monthIndex);
            },
          ),
        ),
        
        // const SizedBox(width: 16),
        
        // Picker для годов
        Expanded(
          child: ACWheelPicker<int>(
            items: _years,
            initialItem: _selectedYear,
            onSelectedItemChanged: _onYearChanged,
          ),
        ),
      ],
    );
  }
}