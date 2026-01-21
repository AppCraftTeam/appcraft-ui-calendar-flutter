import 'package:flutter/material.dart';

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

class ACCalendarMultiSelectController extends ACCalendarSelectController {
  ACCalendarMultiSelectController({
    Set<DateTime>? selected,
    this.onChanged
  }) {
    _selected = selected ?? {};
  }

  late Set<DateTime> _selected;
  Set<DateTime> get selected => _selected;

  void Function(Set<DateTime> selected)? onChanged;

  @override
  void selectDay(DateTime day) {
    if (_selected.contains(day)) {
      _selected.remove(day);
    } else {
      _selected.add(day);
    }

    notifyListeners();
    onChanged?.call(selected);
  }

  @override
  ACDaySelectStyle? selectStyleForDay(DateTime day) =>
    selected.contains(day) ?
      const ACDayDefaultSelectStyle() :
      null;

}

// TODO: Add ACCalendarRangeSelectController