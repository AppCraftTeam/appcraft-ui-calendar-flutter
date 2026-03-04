import 'package:appcraft_ui_calendar_flutter/src/domain/src/ac_day_select_state.dart';
import 'package:appcraft_ui_calendar_flutter/src/presentation/src/select_controller/ac_calendar_select_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ACCalendarMultiSelectController.selectDay', () {
    test('adds a new day to the list', () {
      final controller = ACCalendarMultiSelectController();
      final day = DateTime(2024, 1, 15);

      controller.selectDay(day);

      expect(controller.selected, contains(day));
    });

    test('removes day on repeated click', () {
      final controller = ACCalendarMultiSelectController();
      final day = DateTime(2024, 1, 15);

      controller.selectDay(day);
      controller.selectDay(day);

      expect(controller.selected, isEmpty);
    });
  });

  group('ACCalendarMultiSelectController sorting', () {
    test('selected list is sorted by date', () {
      final controller = ACCalendarMultiSelectController();
      final day1 = DateTime(2024, 1, 20);
      final day2 = DateTime(2024, 1, 10);
      final day3 = DateTime(2024, 1, 15);

      controller.selectDay(day1);
      controller.selectDay(day2);
      controller.selectDay(day3);

      expect(controller.selected[0], equals(day2));
      expect(controller.selected[1], equals(day3));
      expect(controller.selected[2], equals(day1));
    });
  });

  group('ACCalendarMultiSelectController.selectStateForDay', () {
    test('returns multi for selected day', () {
      final controller = ACCalendarMultiSelectController();
      final day = DateTime(2024, 1, 15);
      controller.selectDay(day);

      expect(
        controller.selectStateForDay(day),
        equals(ACDaySelectState.multi),
      );
    });

    test('returns null for unselected day', () {
      final controller = ACCalendarMultiSelectController();

      expect(
        controller.selectStateForDay(DateTime(2024, 1, 15)),
        isNull,
      );
    });
  });

  group('ACCalendarMultiSelectController callbacks', () {
    test('onChanged is called with sorted list', () {
      List<DateTime>? lastChanged;
      final controller = ACCalendarMultiSelectController(
        onChanged: (value) => lastChanged = value,
      );

      controller.selectDay(DateTime(2024, 1, 20));
      controller.selectDay(DateTime(2024, 1, 10));

      expect(lastChanged, isNotNull);
      expect(lastChanged!.first, equals(DateTime(2024, 1, 10)));
    });

    test('selected setter accepts external list and sorts', () {
      final controller = ACCalendarMultiSelectController();
      var notifyCount = 0;
      controller.addListener(() => notifyCount++);

      controller.selected = [
        DateTime(2024, 1, 20),
        DateTime(2024, 1, 10),
      ];

      expect(controller.selected.first, equals(DateTime(2024, 1, 10)));
      expect(notifyCount, equals(1));
    });
  });
}
