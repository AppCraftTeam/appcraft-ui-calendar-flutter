import 'package:flutter/material.dart';

import '../../../../../../data/src/ac_calendar_repository.dart';
import '../../../../../../data/src/ac_default_calendar_repository.dart';
import '../../../../../../domain/src/ac_date_format.dart';
import '../../../../../../domain/src/ac_date_range.dart';
import '../../../../../../utils/src/ac_string_ext.dart';
import '../../../../theme/src/ac_calendar_theme_data.dart';
import '../../ac_wheel_picker.dart';

/// Month and year picker based on two scroll wheels.
///
/// Displays two [ACWheelPicker]s: one for the month, another for the year.
/// The set of available months and years is limited by the [range].
class ACMonthPicker extends StatefulWidget {
  /// Creates a month and year picker.
  const ACMonthPicker({
    required this.range,
    this.repository,
    this.onDateChanged,
    this.initialDate,
    this.locale,
    this.theme,
    super.key,
  });

  /// Repository for calendar computations.
  ///
  /// If not specified, [ACDefaultCalendarRepository] is used.
  final ACCalendarRepository? repository;

  /// Allowed date range; limits the set of available months and years.
  final ACDateRange range;

  /// Initial date that determines the selected month and year when the picker opens.
  /// If not set, [ACDateRange.min] is used.
  final DateTime? initialDate;

  /// Called when the selected date changes (month or year).
  final void Function(DateTime date)? onDateChanged;

  /// Locale for formatting month names.
  /// If not set, taken from [Localizations].
  final String? locale;

  /// Calendar visual theme.
  ///
  /// If not set, taken from [ACCalendarThemeExtension].
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

    // Check that the selected month is available
    if (!_months.contains(_selectedMonth)) {
      _selectedMonth = _months.first;
    }
  }

  void _onYearChanged(int year) {
    setState(() {
      _selectedYear = year;

      _months = _calendarRepository.getMonths(
          year: _selectedYear, range: widget.range);

      // If the selected month is no longer available, select the first available one
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

                  // Recreate when the year changes
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
