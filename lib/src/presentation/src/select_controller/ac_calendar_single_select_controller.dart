part of 'ac_calendar_select_controller.dart';

class ACCalendarSingleSelectController extends ACCalendarSelectController {
  ACCalendarSingleSelectController({DateTime? selected, this.onChanged}) {
    _selected = selected;
  }

  DateTime? _selected;

  DateTime? get selected => _selected;

  set selected(DateTime? newValue) {
    if (selected == newValue) return;
    _selected = newValue;
    notifyListeners();
  }

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
