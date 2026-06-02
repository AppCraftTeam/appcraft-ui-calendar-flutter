import 'package:flutter/material.dart';

import '../../../../../../domain/src/ac_date_range.dart';
import '../../../../../../localization/src/ac_default_localization_manager.dart';
import '../../../../../../localization/src/ac_localization_manager.dart';
import '../../../../theme/src/ac_calendar_theme_data.dart';
import '../../app_bar/src/ac_app_bar.dart';
import '../../bottom_sheet/src/ac_bottom_sheet.dart';
import 'ac_month_picker.dart';

/// Bottom sheet with an [ACMonthPicker].
///
/// Use the static [ACMonthPickerSheet.show] method to display it.
class ACMonthPickerSheet extends StatefulWidget {
  /// Creates a bottom sheet with a month picker.
  const ACMonthPickerSheet({
    required this.range,
    this.onDateChanged,
    this.onDone,
    this.initialDate,
    this.locale,
    this.localizationManager,
    this.theme,
    this.pickerHeight,
    super.key,
  });

  /// Allowed date range.
  final ACDateRange range;

  /// Called on every change of the selected date.
  final void Function(DateTime date)? onDateChanged;

  /// Called when the "Done" button is pressed, with the currently selected date.
  final void Function(DateTime date)? onDone;

  /// Initial date.
  final DateTime? initialDate;

  /// Locale for formatting month names.
  final String? locale;

  /// Localization manager. If null, [ACDefaultLocalizationManager] is used.
  final ACLocalizationManager? localizationManager;

  /// Calendar visual theme.
  final ACCalendarThemeData? theme;

  /// Height of the picker area.
  ///
  /// If not specified, `200` is used.
  final double? pickerHeight;

  /// Opens [ACMonthPickerSheet] as a modal bottom sheet.
  static Future<void> show(
    BuildContext context, {
    required ACDateRange range,
    DateTime? initialDate,
    void Function(DateTime date)? onDateChanged,
    void Function(DateTime date)? onDone,
    String? locale,
    ACLocalizationManager? localizationManager,
    ACCalendarThemeData? theme,
    double? pickerHeight,
  }) =>
      ACBottomSheet.show(
        context,
        backgroundColor: theme?.backgroundColor,
        builder: (context) => ACMonthPickerSheet(
          range: range,
          initialDate: initialDate,
          onDateChanged: onDateChanged,
          onDone: onDone,
          locale: locale,
          localizationManager: localizationManager,
          theme: theme,
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
        appBar: ACAppBar(
          title: Text(localization.selectMonth),
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
            theme: widget.theme,
          ),
        ),
      ),
    );
  }
}
