import 'package:flutter/material.dart';

import '../../../domain/src/ac_date_select_range.dart';
import '../../../domain/src/ac_day_select_state.dart';
import '../../../utils/src/ac_date_time_ext.dart';

part 'ac_calendar_single_select_controller.dart';
part 'ac_calendar_multi_select_controller.dart';
part 'ac_calendar_range_select_controller.dart';

/// Base controller for selecting dates in the calendar.
///
/// Subclasses implement the logic for single, multiple,
/// and range selection.
abstract class ACCalendarSelectController extends ChangeNotifier {
  /// Creates a date selection controller.
  ACCalendarSelectController();

  /// Handles the user's selection of the given day.
  void selectDay(DateTime day);

  /// Returns the selection state for the given day,
  /// or `null` if the day is not selected.
  ACDaySelectState? selectStateForDay(DateTime day);
}
