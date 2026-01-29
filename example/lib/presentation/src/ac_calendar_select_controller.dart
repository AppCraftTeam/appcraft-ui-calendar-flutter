import 'package:flutter/material.dart';

import '../../domain/domain.dart';
import '../../utils/src/ac_date_time_ext.dart';
import 'ac_day_select_style.dart';

abstract class ACCalendarSelectController extends ChangeNotifier {
  ACCalendarSelectController();

  ACDaySelectStyle? selectStyleForDay(DateTime day);
  void selectDay(DateTime day);
}

class ACCalendarSingleSelectController extends ACCalendarSelectController {
  ACCalendarSingleSelectController({
    DateTime? selected,
    this.onChanged
  }) {
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
    selected = selected?.equalToDay(day) ?? false ?
      null :
      day;
    
    onChanged?.call(selected);
  }

  @override
  ACDaySelectStyle? selectStyleForDay(DateTime day) =>
    selected?.equalToDay(day) ?? false ?
      const ACDayDefaultSelectStyle() :
      null;

}
// TODO: Добавить сортировку при изменении
class ACCalendarMultiSelectController extends ACCalendarSelectController {
  ACCalendarMultiSelectController({
    Set<DateTime>? selected,
    this.onChanged
  }) {
    _selected = selected ?? {};
  }

  late Set<DateTime> _selected;

  Set<DateTime> get selected => _selected;

  set selected(Set<DateTime> newValue) {
    if (selected == newValue) return;
    _selected = newValue;
    notifyListeners();
  }

  void Function(Set<DateTime> selected)? onChanged;

  @override
  void selectDay(DateTime day) {
    final newSelected = Set.of(_selected);

    if (newSelected.contains(day)) {
      newSelected.remove(day);
    } else {
      newSelected.add(day);
    }

    selected = newSelected;
    onChanged?.call(selected);
  }

  @override
  ACDaySelectStyle? selectStyleForDay(DateTime day) =>
    selected.contains(day) ?
      const ACDayDefaultSelectStyle() :
      null;

}

class ACCalendarRangeSelectController extends ACCalendarSelectController {
  ACCalendarRangeSelectController({
    ACDateSelectRange? selected,
    this.onChanged,
  }) {
    _selected = selected ?? const ACDateSelectRange();
  }

  late ACDateSelectRange _selected;
  
  ACDateSelectRange get selected => _selected;

  set selected(ACDateSelectRange newValue) {
    if (_selected == newValue) return;
    _selected = newValue;
    notifyListeners();
  }

  void Function(ACDateSelectRange selected)? onChanged;

  @override
  void selectDay(DateTime day) {
    final start = selected.start;
    final end = selected.end;

    // Если диапазон пуст, устанавливаем day в start
    if (selected.isEmpty) {
      selected = ACDateSelectRange(
        start: day
      );
    }
    // Если day == start, очищаем диапазон
    else if (start != null && day.equalToDay(start)) {
      selected = const ACDateSelectRange();
    }
    // Если day == end, очищаем диапазон
    else if (end != null && day.equalToDay(end)) {
      selected = const ACDateSelectRange();
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
    else if (
      start != null &&
      end != null && 
      day.isAfter(start) &&
      day.isBefore(end)
    ) {
      final diffFromStart = day.difference(start).inDays.abs();
      final diffFromEnd = day.difference(end).inDays.abs();
      
      if (diffFromStart <= diffFromEnd) {
        // Ближе к start - меняем start
        selected = ACDateSelectRange(
          start: day,
          end: end
        );
      } else {
        // Ближе к end - меняем end
        selected = ACDateSelectRange(
          start: start,
          end: day
        );
      }
    }
    // Если day больше start (или end == null), устанавливаем day в end
    else if (start != null) {
      selected = ACDateSelectRange(
        start: start,
        end: day
      );
    }
    
    onChanged?.call(selected);
  }

  @override
  ACDaySelectStyle? selectStyleForDay(DateTime day) {
    final start = _selected.start;
    final end = _selected.end;

    if (start == null && end == null) {
      return null;
    }

    // Если day равен start или end
    if (
      (start != null && day.equalToDay(start)) || 
      (end != null && day.equalToDay(end))
    ) {
      return const ACDayDefaultSelectStyle();
    }

    // Если day больше start и меньше end
    if (
      start != null &&
      end != null && 
      day.isAfter(start) &&
      day.isBefore(end)
    ) {
      return const ACDayMiddleSelectStyle();
    }

    return null;
  }
}