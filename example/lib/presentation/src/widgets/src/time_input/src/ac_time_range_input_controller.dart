import 'package:flutter/material.dart';

import '../../../../../../domain/domain.dart';
import 'ac_time_input_controller.dart';

/// Контроллер для управления диапазоном времени.
///
/// Владеет двумя [ACTimeInputController]: [minController] (начало)
/// и [maxController] (конец). При изменении любого из них уведомляет
/// слушателей и выполняет валидацию: если конец раньше начала,
/// конец автоматически корректируется.
class ACTimeRangeInputController extends ChangeNotifier {
  /// Создаёт контроллер с начальным диапазоном [range].
  ACTimeRangeInputController({
    ACTimeSelectRange? range,
    this.onChanged,
  }) {
    minController = ACTimeInputController(time: range?.start);
    maxController = ACTimeInputController(time: range?.end);

    minController.addListener(_onMinChanged);
    maxController.addListener(_onMaxChanged);
  }

  /// Контроллер начала диапазона.
  late final ACTimeInputController minController;

  /// Контроллер конца диапазона.
  late final ACTimeInputController maxController;

  /// Коллбек, вызываемый при каждом изменении диапазона.
  void Function(ACTimeSelectRange range)? onChanged;

  /// Текущий диапазон времени.
  ACTimeSelectRange get range => ACTimeSelectRange(
    start: minController.time,
    end: maxController.time,
  );

  void _onMinChanged() {
    _validateAndCorrect();
    notifyListeners();
    onChanged?.call(range);
  }

  void _onMaxChanged() {
    _validateAndCorrect();
    notifyListeners();
    onChanged?.call(range);
  }
  // TODO: Fix max
  /// Корректирует конец диапазона, если он раньше начала.
  void _validateAndCorrect() {
    final start = minController.time;
    final end = maxController.time;
    if (start == null || end == null) return;

    if (end.isBefore(start)) {
      maxController.time = start;
    }
  }

  @override
  void dispose() {
    minController.removeListener(_onMinChanged);
    maxController.removeListener(_onMaxChanged);
    minController.dispose();
    maxController.dispose();
    super.dispose();
  }
}
