import 'package:flutter/material.dart';

import '../../../../../../domain/domain.dart';
import '../../../../../presentation.dart';

/// Нижний лист (bottom sheet) с [ACMonthPicker].
///
/// Для отображения используйте статический метод [ACMonthPickerSheet.show].
class ACMonthPickerSheet extends StatefulWidget {
  const ACMonthPickerSheet({
    required this.range,
    this.onDateChanged,
    this.onDone,
    this.initialDate,
    this.locale,
    this.monthPickerTheme,
    this.wheelPickerTheme,
    this.pickerHeight,
    super.key,
  });

  /// Допустимый диапазон дат.
  final ACDateRange range;

  /// Вызывается при каждом изменении выбранной даты.
  final void Function(DateTime date)? onDateChanged;

  /// Вызывается при нажатии кнопки «Готово» с текущей выбранной датой.
  final void Function(DateTime date)? onDone;

  /// Начальная дата.
  final DateTime? initialDate;

  /// Локаль для форматирования названий месяцев.
  final String? locale;

  /// Тема пикера.
  final ACMonthPickerThemeData? monthPickerTheme;

  /// Тема колёсного пикера.
  final ACWheelPickerThemeData? wheelPickerTheme;

  /// Высота области пикера.
  ///
  /// Если не указана, используется `200`.
  final double? pickerHeight;

  /// Открывает [ACMonthPickerSheet] как модальный нижний лист.
  static Future<void> show(
    BuildContext context, {
    required ACDateRange range,
    DateTime? initialDate,
    void Function(DateTime date)? onDateChanged,
    void Function(DateTime date)? onDone,
    String? locale,
    ACMonthPickerThemeData? monthPickerTheme,
    ACWheelPickerThemeData? wheelPickerTheme,
    double? pickerHeight,
  }) => showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => ACMonthPickerSheet(
      range: range,
      initialDate: initialDate,
      onDateChanged: onDateChanged,
      onDone: onDone,
      locale: locale,
      monthPickerTheme: monthPickerTheme,
      wheelPickerTheme: wheelPickerTheme,
      pickerHeight: pickerHeight,
    ),
  );

  @override
  State<ACMonthPickerSheet> createState() => _ACMonthPickerSheetState();
}

class _ACMonthPickerSheetState extends State<ACMonthPickerSheet> {
  late DateTime _currentDate;

  @override
  void initState() {
    super.initState();
    _currentDate = widget.initialDate ?? widget.range.min;
  }

  void _onDateChanged(DateTime date) {
    _currentDate = date;
    widget.onDateChanged?.call(date);
  }

  void _onDone() {
    Navigator.of(context, rootNavigator: true).pop();
    widget.onDone?.call(_currentDate);
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return SizedBox(
      height: kToolbarHeight + (widget.pickerHeight ?? 200) + bottomPadding,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          title: Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          actions: [
            TextButton(
              onPressed: _onDone,
              child: const Text('Готово'),
            ),
          ],
        ),
        body: ACMonthPicker(
          range: widget.range,
          initialDate: widget.initialDate,
          onDateChanged: _onDateChanged,
          locale: widget.locale,
          monthPickerTheme: widget.monthPickerTheme,
          wheelPickerTheme: widget.wheelPickerTheme,
        ),
      ),
    );
  }
}
