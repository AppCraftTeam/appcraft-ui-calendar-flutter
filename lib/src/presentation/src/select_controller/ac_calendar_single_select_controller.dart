part of 'ac_calendar_select_controller.dart';

/// Контроллер одиночного выбора даты в календаре.
///
/// Позволяет выбрать одну дату. Повторное нажатие снимает выбор.
class ACCalendarSingleSelectController extends ACCalendarSelectController {
  /// Создаёт контроллер одиночного выбора с опциональной начальной датой.
  ACCalendarSingleSelectController({DateTime? selected, this.onChanged}) {
    _selected = selected;
  }

  DateTime? _selected;

  /// Текущая выбранная дата или `null`, если ничего не выбрано.
  DateTime? get selected => _selected;

  /// Устанавливает выбранную дату и уведомляет слушателей.
  set selected(DateTime? newValue) {
    if (selected == newValue) return;
    _selected = newValue;
    notifyListeners();
  }

  /// Колбэк, вызываемый при изменении выбранной даты.
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
