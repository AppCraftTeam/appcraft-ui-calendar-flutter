part of 'ac_calendar_select_controller.dart';

/// Контроллер выбора диапазона дат в календаре.
///
/// Позволяет выбрать начальную и конечную дату диапазона.
/// При выборе даты внутри существующего диапазона корректирует
/// ближайшую границу.
class ACCalendarRangeSelectController extends ACCalendarSelectController {
  /// Создаёт контроллер выбора диапазона с опциональным начальным диапазоном.
  ACCalendarRangeSelectController({
    ACDateSelectRange? selected,
    this.onChanged,
  }) {
    _selected = selected ?? ACDateSelectRange();
  }

  late ACDateSelectRange _selected;

  /// Текущий выбранный диапазон дат.
  ACDateSelectRange get selected => _selected;

  /// Устанавливает выбранный диапазон и уведомляет слушателей.
  set selected(ACDateSelectRange newValue) {
    if (_selected == newValue) return;
    _selected = newValue;
    notifyListeners();
  }

  /// Колбэк, вызываемый при изменении выбранного диапазона.
  void Function(ACDateSelectRange selected)? onChanged;

  @override
  void selectDay(DateTime day) {
    final start = selected.start;
    final end = selected.end;

    // Если диапазон пуст, устанавливаем day в start
    if (selected.isEmpty) {
      selected = ACDateSelectRange(start: day);
    }
    // Если day == start, очищаем диапазон
    else if (start != null && day.equalToDay(start)) {
      selected = ACDateSelectRange();
    }
    // Если day == end, очищаем диапазон
    else if (end != null && day.equalToDay(end)) {
      selected = ACDateSelectRange();
    }
    // Если day меньше start, устанавливаем day в start,
    // а в end - старый end или старый start
    else if (start != null && day.isBefore(start)) {
      selected = ACDateSelectRange(
        start: day,
        end: end ?? start,
      );
    }
    // Если day больше start и меньше end, смотрим к какой дате ближе
    else if (start != null &&
        end != null &&
        day.isAfter(start) &&
        day.isBefore(end)) {
      final diffFromStart = day.difference(start).inDays.abs();
      final diffFromEnd = day.difference(end).inDays.abs();

      if (diffFromStart <= diffFromEnd) {
        // Ближе к start - меняем start
        selected = ACDateSelectRange(start: day, end: end);
      } else {
        // Ближе к end - меняем end
        selected = ACDateSelectRange(start: start, end: day);
      }
    }
    // Если day больше start (или end == null), устанавливаем day в end
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

    // Если day равен start
    if (start != null && day.equalToDay(start)) {
      return ACDaySelectState.startOfRange;
    }

    // Если day равен end
    if (end != null && day.equalToDay(end)) {
      return ACDaySelectState.endOfRange;
    }

    // Если day больше start и меньше end
    if (start != null &&
        end != null &&
        day.isAfter(start) &&
        day.isBefore(end)) {
      return ACDaySelectState.middleInRange;
    }

    return null;
  }
}
