import 'package:appcraft_ui_calendar_flutter/src/domain/src/ac_day_select_state.dart';
import 'package:appcraft_ui_calendar_flutter/src/presentation/src/select_controller/ac_calendar_select_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ACCalendarRangeSelectController — empty range', () {
    test('click sets start, end is null', () {
      final controller = ACCalendarRangeSelectController();
      final day = DateTime(2024, 1, 15);

      controller.selectDay(day);

      expect(controller.selected.start, equals(day));
      expect(controller.selected.end, isNull);
    });
  });

  group('ACCalendarRangeSelectController — only start set', () {
    test('click on start clears range', () {
      final controller = ACCalendarRangeSelectController();
      final day = DateTime(2024, 1, 15);

      controller
        ..selectDay(day)
        ..selectDay(day);

      expect(controller.selected.isEmpty, isTrue);
    });

    test('click after start sets end', () {
      final controller = ACCalendarRangeSelectController();
      final start = DateTime(2024, 1, 10);
      final end = DateTime(2024, 1, 20);

      controller
        ..selectDay(start)
        ..selectDay(end);

      expect(controller.selected.start, equals(start));
      expect(controller.selected.end, equals(end));
    });

    test('click before start makes it new start, old start becomes end', () {
      final controller = ACCalendarRangeSelectController();
      final oldStart = DateTime(2024, 1, 15);
      final newStart = DateTime(2024, 1, 5);

      controller
        ..selectDay(oldStart)
        ..selectDay(newStart);

      expect(controller.selected.start, equals(newStart));
      expect(controller.selected.end, equals(oldStart));
    });
  });

  group('ACCalendarRangeSelectController — full range (start + end)', () {
    test('click on start clears range', () {
      final controller = ACCalendarRangeSelectController()
        ..selectDay(DateTime(2024, 1, 10))
        ..selectDay(DateTime(2024, 1, 20))
        ..selectDay(DateTime(2024, 1, 10));

      expect(controller.selected.isEmpty, isTrue);
    });

    test('click on end clears range', () {
      final controller = ACCalendarRangeSelectController()
        ..selectDay(DateTime(2024, 1, 10))
        ..selectDay(DateTime(2024, 1, 20))
        ..selectDay(DateTime(2024, 1, 20));

      expect(controller.selected.isEmpty, isTrue);
    });

    test('click inside range closer to start changes start', () {
      // Day 13 is closer to start (10) than end (20)
      final controller = ACCalendarRangeSelectController()
        ..selectDay(DateTime(2024, 1, 10))
        ..selectDay(DateTime(2024, 1, 20))
        ..selectDay(DateTime(2024, 1, 13));

      expect(controller.selected.start, equals(DateTime(2024, 1, 13)));
      expect(controller.selected.end, equals(DateTime(2024, 1, 20)));
    });

    test('click inside range closer to end changes end', () {
      // Day 17 is closer to end (20) than start (10)
      final controller = ACCalendarRangeSelectController()
        ..selectDay(DateTime(2024, 1, 10))
        ..selectDay(DateTime(2024, 1, 20))
        ..selectDay(DateTime(2024, 1, 17));

      expect(controller.selected.start, equals(DateTime(2024, 1, 10)));
      expect(controller.selected.end, equals(DateTime(2024, 1, 17)));
    });

    test('click after end changes end', () {
      final controller = ACCalendarRangeSelectController()
        ..selectDay(DateTime(2024, 1, 10))
        ..selectDay(DateTime(2024, 1, 20))
        ..selectDay(DateTime(2024, 1, 25));

      expect(controller.selected.start, equals(DateTime(2024, 1, 10)));
      expect(controller.selected.end, equals(DateTime(2024, 1, 25)));
    });

    test('click before start changes start', () {
      final controller = ACCalendarRangeSelectController()
        ..selectDay(DateTime(2024, 1, 10))
        ..selectDay(DateTime(2024, 1, 20))
        ..selectDay(DateTime(2024, 1, 5));

      expect(controller.selected.start, equals(DateTime(2024, 1, 5)));
      expect(controller.selected.end, equals(DateTime(2024, 1, 20)));
    });
  });

  group('ACCalendarRangeSelectController.selectStateForDay', () {
    late ACCalendarRangeSelectController controller;

    setUp(() {
      controller = ACCalendarRangeSelectController()
        ..selectDay(DateTime(2024, 1, 10))
        ..selectDay(DateTime(2024, 1, 20));
    });

    test('returns startOfRange for start day', () {
      expect(
        controller.selectStateForDay(DateTime(2024, 1, 10)),
        equals(ACDaySelectState.startOfRange),
      );
    });

    test('returns endOfRange for end day', () {
      expect(
        controller.selectStateForDay(DateTime(2024, 1, 20)),
        equals(ACDaySelectState.endOfRange),
      );
    });

    test('returns middleInRange for day between start and end', () {
      expect(
        controller.selectStateForDay(DateTime(2024, 1, 15)),
        equals(ACDaySelectState.middleInRange),
      );
    });

    test('returns null for day outside range', () {
      expect(
        controller.selectStateForDay(DateTime(2024, 1, 5)),
        isNull,
      );
    });
  });
}
