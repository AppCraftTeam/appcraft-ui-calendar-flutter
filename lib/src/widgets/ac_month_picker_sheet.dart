import 'package:flutter/material.dart';

import '../domain/ac_date_range.dart';
import '../localization/ac_default_localization_manager.dart';
import '../localization/ac_localization_manager.dart';
import '../theme/ac_calendar_theme_data.dart';
import '../theme/ac_month_picker_theme_data.dart';
import '../theme/ac_wheel_picker_theme_data.dart';
import 'ac_bottom_sheet.dart';
import 'ac_month_picker.dart';

/// Нижний лист (bottom sheet) с [ACMonthPicker].
///
/// Для отображения используйте статический метод [ACMonthPickerSheet.show].
class ACMonthPickerSheet extends StatefulWidget {
  /// Создаёт нижний лист с пикером месяца.
  const ACMonthPickerSheet({
    required this.range,
    this.onDateChanged,
    this.onDone,
    this.initialDate,
    this.locale,
    this.localizationManager,
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

  /// Менеджер локализации. Если null, используется [ACDefaultLocalizationManager].
  final ACLocalizationManager? localizationManager;

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
    ACLocalizationManager? localizationManager,
    ACMonthPickerThemeData? monthPickerTheme,
    ACWheelPickerThemeData? wheelPickerTheme,
    double? pickerHeight,
  }) =>
      ACBottomSheet.show(
        context,
        builder: (context) => ACMonthPickerSheet(
          range: range,
          initialDate: initialDate,
          onDateChanged: onDateChanged,
          onDone: onDone,
          locale: locale,
          localizationManager: localizationManager,
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

    final localization =
        (widget.localizationManager ?? const ACDefaultLocalizationManager())
            .localization(
      widget.locale ?? Localizations.maybeLocaleOf(context)?.toLanguageTag(),
    );

    return SizedBox(
      height: kToolbarHeight + (widget.pickerHeight ?? 200) + bottomPadding,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          backgroundColor: ACCalendarThemeData.of(context).backgroundColor ??
              Theme.of(context).colorScheme.surface,
          title: Text(localization.selectMonth),
          titleTextStyle: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: ACCalendarThemeData.of(context)
                .monthPickerTheme
                .actionTextColor,
          ),
          actions: [
            TextButton(
              onPressed: _onDone,
              child: Text(localization.done),
            ),
          ],
        ),
        body: SafeArea(
          child: ACMonthPicker(
            range: widget.range,
            initialDate: widget.initialDate,
            onDateChanged: _onDateChanged,
            locale: widget.locale,
            monthPickerTheme: widget.monthPickerTheme,
            wheelPickerTheme: widget.wheelPickerTheme,
          ),
        ),
      ),
    );
  }
}
