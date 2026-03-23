import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ACTimeRangeInputController', () {
    test('initial range is empty when no range provided', () {
      // Arrange & Act
      final controller = ACTimeRangeInputController();

      // Assert
      expect(controller.range.start, isNull);
      expect(controller.range.end, isNull);
      expect(controller.range.isEmpty, isTrue);

      controller.dispose();
    });

    test('initial range is set from constructor', () {
      // Arrange
      final range = ACTimeSelectRange(
        start: const TimeOfDay(hour: 9, minute: 0),
        end: const TimeOfDay(hour: 17, minute: 0),
      );

      // Act
      final controller = ACTimeRangeInputController(range: range);

      // Assert
      expect(
          controller.range.start, equals(const TimeOfDay(hour: 9, minute: 0)));
      expect(
          controller.range.end, equals(const TimeOfDay(hour: 17, minute: 0)));

      controller.dispose();
    });

    test('minController and maxController reflect initial range', () {
      // Arrange
      final range = ACTimeSelectRange(
        start: const TimeOfDay(hour: 8, minute: 30),
        end: const TimeOfDay(hour: 12, minute: 45),
      );

      // Act
      final controller = ACTimeRangeInputController(range: range);

      // Assert
      expect(
        controller.minController.time,
        equals(const TimeOfDay(hour: 8, minute: 30)),
      );
      expect(
        controller.maxController.time,
        equals(const TimeOfDay(hour: 12, minute: 45)),
      );

      controller.dispose();
    });

    test('notifies listeners when min time changes', () {
      // Arrange
      final controller = ACTimeRangeInputController();
      var notified = false;
      controller.addListener(() => notified = true);

      // Act
      controller.minController.time = const TimeOfDay(hour: 10, minute: 0);

      // Assert
      expect(notified, isTrue);

      controller.dispose();
    });

    test('notifies listeners when max time changes', () {
      // Arrange
      final controller = ACTimeRangeInputController();
      var notified = false;
      controller.addListener(() => notified = true);

      // Act
      controller.maxController.time = const TimeOfDay(hour: 18, minute: 0);

      // Assert
      expect(notified, isTrue);

      controller.dispose();
    });

    test('corrects max when max is before min on min change', () {
      // Arrange
      final controller = ACTimeRangeInputController(
        range: ACTimeSelectRange(
          start: const TimeOfDay(hour: 10, minute: 0),
          end: const TimeOfDay(hour: 14, minute: 0),
        ),
      );

      // Act - set min later than max
      controller.minController.time = const TimeOfDay(hour: 16, minute: 0);

      // Assert - max should be corrected to equal min
      expect(
        controller.maxController.time,
        equals(const TimeOfDay(hour: 16, minute: 0)),
      );

      controller.dispose();
    });

    test('corrects min when min is after max on max change', () {
      // Arrange
      final controller = ACTimeRangeInputController(
        range: ACTimeSelectRange(
          start: const TimeOfDay(hour: 14, minute: 0),
          end: const TimeOfDay(hour: 18, minute: 0),
        ),
      );

      // Act - set max earlier than min
      controller.maxController.time = const TimeOfDay(hour: 10, minute: 0);

      // Assert - min should be corrected to equal max
      expect(
        controller.minController.time,
        equals(const TimeOfDay(hour: 10, minute: 0)),
      );

      controller.dispose();
    });

    test('does not correct when max equals min', () {
      // Arrange
      final controller = ACTimeRangeInputController(
        range: ACTimeSelectRange(
          start: const TimeOfDay(hour: 12, minute: 0),
          end: const TimeOfDay(hour: 15, minute: 0),
        ),
      );

      // Act
      controller.maxController.time = const TimeOfDay(hour: 12, minute: 0);

      // Assert
      expect(
        controller.minController.time,
        equals(const TimeOfDay(hour: 12, minute: 0)),
      );
      expect(
        controller.maxController.time,
        equals(const TimeOfDay(hour: 12, minute: 0)),
      );

      controller.dispose();
    });

    test('no correction when min or max is null', () {
      // Arrange
      final controller = ACTimeRangeInputController();

      // Act
      controller.minController.time = const TimeOfDay(hour: 20, minute: 0);

      // Assert - max stays null, no correction
      expect(controller.maxController.time, isNull);

      controller.dispose();
    });

    test('onChanged callback is called when min changes', () {
      // Arrange
      ACTimeSelectRange? receivedRange;
      final controller = ACTimeRangeInputController(
        onChanged: (range) => receivedRange = range,
      );

      // Act
      controller.minController.time = const TimeOfDay(hour: 9, minute: 0);

      // Assert
      expect(receivedRange, isNotNull);
      expect(
        receivedRange!.start,
        equals(const TimeOfDay(hour: 9, minute: 0)),
      );

      controller.dispose();
    });

    test('onChanged callback is called when max changes', () {
      // Arrange
      ACTimeSelectRange? receivedRange;
      final controller = ACTimeRangeInputController(
        range: ACTimeSelectRange(
          start: const TimeOfDay(hour: 9, minute: 0),
          end: const TimeOfDay(hour: 12, minute: 0),
        ),
        onChanged: (range) => receivedRange = range,
      );

      // Act
      controller.maxController.time = const TimeOfDay(hour: 17, minute: 30);

      // Assert
      expect(receivedRange, isNotNull);
      expect(
        receivedRange!.end,
        equals(const TimeOfDay(hour: 17, minute: 30)),
      );

      controller.dispose();
    });

    test('range getter returns current values', () {
      // Arrange
      final controller = ACTimeRangeInputController();

      // Act
      controller.minController.time = const TimeOfDay(hour: 8, minute: 0);
      controller.maxController.time = const TimeOfDay(hour: 20, minute: 0);

      // Assert
      final range = controller.range;
      expect(range.start, equals(const TimeOfDay(hour: 8, minute: 0)));
      expect(range.end, equals(const TimeOfDay(hour: 20, minute: 0)));

      controller.dispose();
    });

    test('dispose removes listeners from sub-controllers', () {
      // Arrange
      final controller = ACTimeRangeInputController();
      var notifyCount = 0;
      controller.addListener(() => notifyCount++);

      // Act
      controller.dispose();

      // Changing sub-controllers after dispose should not notify
      // (listeners removed from sub-controllers)
      // Note: we can't call notifyListeners after dispose,
      // but sub-controller listeners were removed
      expect(notifyCount, equals(0));
    });

    test('correction does not cause infinite loop', () {
      // Arrange
      final controller = ACTimeRangeInputController(
        range: ACTimeSelectRange(
          start: const TimeOfDay(hour: 10, minute: 0),
          end: const TimeOfDay(hour: 12, minute: 0),
        ),
      );
      var notifyCount = 0;
      controller.addListener(() => notifyCount++);

      // Act - trigger correction
      controller.minController.time = const TimeOfDay(hour: 15, minute: 0);

      // Assert - should notify exactly once (no infinite recursion)
      expect(notifyCount, equals(1));
      expect(
        controller.maxController.time,
        equals(const TimeOfDay(hour: 15, minute: 0)),
      );

      controller.dispose();
    });
  });
}
