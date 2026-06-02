part of 'ac_calendar_select_controller.dart';

/// Controller for selecting a date range in the calendar.
///
/// Allows selecting the start and end dates of a range.
/// When a date inside an existing range is selected, it adjusts
/// the nearest boundary.
class ACCalendarRangeSelectController extends ACCalendarSelectController {
  /// Creates a range selection controller with an optional initial range.
  ACCalendarRangeSelectController({
    ACDateSelectRange? selected,
    this.onChanged,
  }) {
    _selected = selected ?? ACDateSelectRange();
  }

  late ACDateSelectRange _selected;

  /// The currently selected date range.
  ACDateSelectRange get selected => _selected;

  /// Sets the selected range and notifies listeners.
  set selected(ACDateSelectRange newValue) {
    if (_selected == newValue) return;
    _selected = newValue;
    notifyListeners();
  }

  /// Callback invoked when the selected range changes.
  void Function(ACDateSelectRange selected)? onChanged;

  @override
  void selectDay(DateTime day) {
    final start = selected.start;
    final end = selected.end;

    // If the range is empty, set day as start
    if (selected.isEmpty) {
      selected = ACDateSelectRange(start: day);
    }
    // If day == start, clear the range
    else if (start != null && day.equalToDay(start)) {
      selected = ACDateSelectRange();
    }
    // If day == end, clear the range
    else if (end != null && day.equalToDay(end)) {
      selected = ACDateSelectRange();
    }
    // If day is before start, set day as start,
    // and end as the old end or the old start
    else if (start != null && day.isBefore(start)) {
      selected = ACDateSelectRange(
        start: day,
        end: end ?? start,
      );
    }
    // If day is after start and before end, check which date is closer
    else if (start != null &&
        end != null &&
        day.isAfter(start) &&
        day.isBefore(end)) {
      final diffFromStart = day.difference(start).inDays.abs();
      final diffFromEnd = day.difference(end).inDays.abs();

      if (diffFromStart <= diffFromEnd) {
        // Closer to start - change start
        selected = ACDateSelectRange(start: day, end: end);
      } else {
        // Closer to end - change end
        selected = ACDateSelectRange(start: start, end: day);
      }
    }
    // If day is after start (or end == null), set day as end
    else if (start != null) {
      selected = ACDateSelectRange(start: start, end: day);
    }

    onChanged?.call(selected);
  }

  @override
  ACDaySelectState? selectStateForDay(DateTime day) {
    final start = _selected.start;
    final end = _selected.end;

    if (start == null && end == null) {
      return null;
    }

    // If day equals start
    if (start != null && day.equalToDay(start)) {
      return ACDaySelectState.startOfRange;
    }

    // If day equals end
    if (end != null && day.equalToDay(end)) {
      return ACDaySelectState.endOfRange;
    }

    // If day is after start and before end
    if (start != null &&
        end != null &&
        day.isAfter(start) &&
        day.isBefore(end)) {
      return ACDaySelectState.middleInRange;
    }

    return null;
  }
}
