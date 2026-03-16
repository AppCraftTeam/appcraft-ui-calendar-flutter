import 'package:flutter/material.dart';

/// Контроллер для управления значением времени в ACTimeInputWidget.
///
/// Расширяет [ChangeNotifier], уведомляя слушателей при изменении [time].
class ACTimeInputController extends ChangeNotifier {
  /// Создаёт контроллер с начальным значением [time].
  ACTimeInputController({
    TimeOfDay? time,
    this.onChanged,
  }) {
    _time = time;
  }

  TimeOfDay? _time;

  /// Текущее значение времени. `null`, если время не задано или ввод не завершён.
  TimeOfDay? get time => _time;

  /// Устанавливает новое значение времени.
  ///
  /// Если значение не изменилось, слушатели не уведомляются.
  set time(TimeOfDay? newValue) {
    if (_time == newValue) return;
    _time = newValue;
    notifyListeners();
    onChanged?.call(_time);
  }

  /// Коллбек, вызываемый при каждом изменении [time].
  void Function(TimeOfDay? time)? onChanged;
}
