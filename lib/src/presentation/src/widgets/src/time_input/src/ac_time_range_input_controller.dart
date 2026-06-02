import 'package:flutter/material.dart';

import '../../../../../../domain/src/ac_time_select_range.dart';
import 'ac_time_input_controller.dart';

/// Controller for managing a time range.
///
/// Owns two [ACTimeInputController]s: [minController] (start)
/// and [maxController] (end). When either changes, it notifies
/// listeners and performs validation: if the end is before the start,
/// the end is automatically corrected.
class ACTimeRangeInputController extends ChangeNotifier {
  /// Creates a controller with the initial range [range].
  ACTimeRangeInputController({
    ACTimeSelectRange? range,
    this.onChanged,
  }) {
    minController = ACTimeInputController(time: range?.start);
    maxController = ACTimeInputController(time: range?.end);

    minController.addListener(_onMinChanged);
    maxController.addListener(_onMaxChanged);
  }

  /// Range start controller.
  late final ACTimeInputController minController;

  /// Range end controller.
  late final ACTimeInputController maxController;

  /// Callback invoked on every range change.
  void Function(ACTimeSelectRange range)? onChanged;

  bool _isCorrectingRange = false;

  /// Current time range.
  ACTimeSelectRange get range => ACTimeSelectRange(
        start: minController.time,
        end: maxController.time,
      );

  void _onMinChanged() {
    if (_isCorrectingRange) return;
    _isCorrectingRange = true;
    _correctMax();
    _isCorrectingRange = false;
    notifyListeners();
    onChanged?.call(range);
  }

  void _onMaxChanged() {
    if (_isCorrectingRange) return;
    _isCorrectingRange = true;
    _correctMin();
    _isCorrectingRange = false;
    notifyListeners();
    onChanged?.call(range);
  }

  /// Corrects the range end if it is before the start.
  void _correctMax() {
    final start = minController.time;
    final end = maxController.time;
    if (start == null || end == null) return;

    if (end.isBefore(start)) {
      maxController.time = start;
    }
  }

  /// Corrects the range start if it is after the end.
  void _correctMin() {
    final start = minController.time;
    final end = maxController.time;
    if (start == null || end == null) return;

    if (start.isAfter(end)) {
      minController.time = end;
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
