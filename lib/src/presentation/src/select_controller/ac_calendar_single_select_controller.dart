part of 'ac_calendar_select_controller.dart';

/// Controller for single date selection in the calendar.
///
/// Allows selecting a single date. Tapping again clears the selection.
class ACCalendarSingleSelectController extends ACCalendarSelectController {
  /// Creates a single selection controller with an optional initial date.
  ACCalendarSingleSelectController({DateTime? selected, this.onChanged}) {
    _selected = selected;
  }

  DateTime? _selected;

  /// The currently selected date, or `null` if nothing is selected.
  DateTime? get selected => _selected;

  /// Sets the selected date and notifies listeners.
  set selected(DateTime? newValue) {
    if (selected == newValue) return;
    _selected = newValue;
    notifyListeners();
  }

  /// Callback invoked when the selected date changes.
  void Function(DateTime? selected)? onChanged;

  @override
  void selectDay(DateTime day) {
    selected = selected?.equalToDay(day) ?? false ? null : day;

    onChanged?.call(selected);
  }

  @override
  ACDaySelectState? selectStateForDay(DateTime day) =>
      selected?.equalToDay(day) ?? false ? ACDaySelectState.single : null;
}
