import 'package:flutter/material.dart';

import '../../../domain/src/ac_date_select_range.dart';
import '../../../domain/src/ac_day_select_state.dart';
import '../../../utils/src/ac_date_time_ext.dart';

part 'ac_calendar_single_select_controller.dart';
part 'ac_calendar_multi_select_controller.dart';
part 'ac_calendar_range_select_controller.dart';

/// Базовый контроллер выбора дат в календаре.
///
/// Наследники реализуют логику одиночного, множественного
/// и диапазонного выбора.
abstract class ACCalendarSelectController extends ChangeNotifier {
  /// Создаёт контроллер выбора дат.
  ACCalendarSelectController();

  /// Обрабатывает выбор указанного дня пользователем.
  void selectDay(DateTime day);

  /// Возвращает состояние выбора для указанного дня
  /// или `null`, если день не выбран.
  ACDaySelectState? selectStateForDay(DateTime day);
}
