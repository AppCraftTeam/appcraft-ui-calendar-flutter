import 'package:appcraft_ui_calendar_flutter/src/domain/ac_day_select_state.dart';
import 'package:appcraft_ui_calendar_flutter/src/select_controller/ac_calendar_select_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ACCalendarSingleSelectController.selectDay', () {
    test('selects a day', () {
      final controller = ACCalendarSingleSelectController();
      final day = DateTime(2024, 1, 15);

      controller.selectDay(day);

      expect(controller.selected, equals(day));
    });

    test('deselects on repeated click of the same day', () {
      final controller = ACCalendarSingleSelectController();
      final day = DateTime(2024, 1, 15);

      controller
        ..selectDay(day)
        ..selectDay(day);

      expect(controller.selected, isNull);
    });

    test('replaces selection on click of another day', () {
      final controller = ACCalendarSingleSelectController();
      final day1 = DateTime(2024, 1, 15);
      final day2 = DateTime(2024, 1, 20);

      controller
        ..selectDay(day1)
        ..selectDay(day2);

      expect(controller.selected, equals(day2));
    });
  });

  group('ACCalendarSingleSelectController.selectStateForDay', () {
    test('returns single for selected day', () {
      final controller = ACCalendarSingleSelectController();
      final day = DateTime(2024, 1, 15);
      controller.selectDay(day);

      expect(
        controller.selectStateForDay(day),
        equals(ACDaySelectState.single),
      );
    });

    test('returns null for unselected day', () {
      final controller = ACCalendarSingleSelectController();
      final day = DateTime(2024, 1, 15);

      expect(controller.selectStateForDay(day), isNull);
    });
  });

  group('ACCalendarSingleSelectController callbacks', () {
    test('onChanged is called on selection change', () {
      DateTime? lastChanged;
      final controller = ACCalendarSingleSelectController(
        onChanged: (value) => lastChanged = value,
      );
      final day = DateTime(2024, 1, 15);

      controller.selectDay(day);

      expect(lastChanged, equals(day));
    });

    test('notifyListeners fires on change', () {
      final controller = ACCalendarSingleSelectController();
      var notifyCount = 0;
      controller
        ..addListener(() => notifyCount++)
        ..selectDay(DateTime(2024, 1, 15));

      expect(notifyCount, equals(1));
    });

    test('selected setter notifies listeners', () {
      final controller = ACCalendarSingleSelectController();
      var notifyCount = 0;
      controller
        ..addListener(() => notifyCount++)
        ..selected = DateTime(2024, 1, 15);

      expect(notifyCount, equals(1));
    });
  });
}
