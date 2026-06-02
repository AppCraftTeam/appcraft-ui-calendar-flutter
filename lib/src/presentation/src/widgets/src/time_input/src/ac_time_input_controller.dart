import 'package:flutter/material.dart';

/// Controller for managing the time value in ACTimeInputWidget.
///
/// Extends [ChangeNotifier], notifying listeners when [time] changes.
class ACTimeInputController extends ChangeNotifier {
  /// Creates a controller with the initial value [time].
  ACTimeInputController({
    TimeOfDay? time,
    this.onChanged,
  }) {
    _time = time;
  }

  TimeOfDay? _time;

  /// Current time value. `null` if time is not set or input is incomplete.
  TimeOfDay? get time => _time;

  /// Sets a new time value.
  ///
  /// If the value did not change, listeners are not notified.
  set time(TimeOfDay? newValue) {
    if (_time == newValue) return;
    _time = newValue;
    notifyListeners();
    onChanged?.call(_time);
  }

  /// Callback invoked on every change of [time].
  void Function(TimeOfDay? time)? onChanged;
}
