part of 'ac_calendar_select_controller.dart';

/// Контроллер множественного выбора дат в календаре.
///
/// Позволяет выбрать несколько дат. Повторное нажатие на выбранную
/// дату снимает выбор. Список всегда отсортирован по возрастанию.
class ACCalendarMultiSelectController extends ACCalendarSelectController {
  /// Создаёт контроллер множественного выбора с опциональным списком дат.
  ACCalendarMultiSelectController({List<DateTime>? selected, this.onChanged}) {
    _selected = selected ?? [];
    _sortSelected();
  }

  late List<DateTime> _selected;

  /// Текущий список выбранных дат, отсортированный по возрастанию.
  List<DateTime> get selected => _selected;

  /// Устанавливает список выбранных дат и уведомляет слушателей.
  set selected(List<DateTime> newValue) {
    if (selected == newValue) return;
    _selected = newValue;
    _sortSelected();
    notifyListeners();
  }

  /// Колбэк, вызываемый при изменении списка выбранных дат.
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
