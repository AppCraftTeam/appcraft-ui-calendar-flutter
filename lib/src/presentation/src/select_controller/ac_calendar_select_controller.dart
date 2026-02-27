import 'package:flutter/material.dart';

import '../../../domain/domain.dart';
import '../../../utils/src/ac_date_time_ext.dart';

part 'ac_calendar_single_select_controller.dart';
part 'ac_calendar_multi_select_controller.dart';
part 'ac_calendar_range_select_controller.dart';

abstract class ACCalendarSelectController extends ChangeNotifier {
  ACCalendarSelectController();

  void selectDay(DateTime day);
  ACDaySelectState? selectStateForDay(DateTime day);
}