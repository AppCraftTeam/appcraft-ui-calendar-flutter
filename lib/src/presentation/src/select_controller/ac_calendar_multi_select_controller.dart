part of 'ac_calendar_select_controller.dart';

/// Controller for multiple date selection in the calendar.
///
/// Allows selecting several dates. Tapping a selected date again
/// clears its selection. The list is always sorted in ascending order.
class ACCalendarMultiSelectController extends ACCalendarSelectController {
  /// Creates a multiple selection controller with an optional list of dates.
  ACCalendarMultiSelectController({List<DateTime>? selected, this.onChanged}) {
    _selected = selected ?? [];
    _sortSelected();
  }

  late List<DateTime> _selected;

  /// The current list of selected dates, sorted in ascending order.
  List<DateTime> get selected => _selected;

  /// Sets the list of selected dates and notifies listeners.
  set selected(List<DateTime> newValue) {
    if (selected == newValue) return;
    _selected = newValue;
    _sortSelected();
    notifyListeners();
  }

  /// Callback invoked when the list of selected dates changes.
  void Function(List<DateTime> selected)? onChanged;

  void _sortSelected() {
    _selected.sort((a, b) => a.compareTo(b));
  }

  @override
  void selectDay(DateTime day) {
    final newSelected = List<DateTime>.of(_selected);

    final existingIndex =
        newSelected.indexWhere((date) => date.equalToDay(day));

    if (existingIndex != -1) {
      newSelected.removeAt(existingIndex);
    } else {
      newSelected.add(day);
    }

    selected = newSelected;
    onChanged?.call(selected);
  }

  @override
  ACDaySelectState? selectStateForDay(DateTime day) =>
      selected.any((date) => date.equalToDay(day))
          ? ACDaySelectState.multi
          : null;
}
