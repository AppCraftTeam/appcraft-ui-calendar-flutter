import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ACTimeInputController', () {
    test('initial time is null when not provided', () {
      // Arrange & Act
      final controller = ACTimeInputController();

      // Assert
      expect(controller.time, isNull);

      controller.dispose();
    });

    test('initial time is set from constructor', () {
      // Arrange
      const time = TimeOfDay(hour: 10, minute: 30);

      // Act
      final controller = ACTimeInputController(time: time);

      // Assert
      expect(controller.time, equals(time));

      controller.dispose();
    });

    test('setting time notifies listeners', () {
      // Arrange
      var notified = false;
      final controller = ACTimeInputController()
        ..addListener(() => notified = true)

        // Act
        ..time = const TimeOfDay(hour: 14, minute: 0);

      // Assert
      expect(notified, isTrue);
      expect(controller.time, equals(const TimeOfDay(hour: 14, minute: 0)));

      controller.dispose();
    });

    test('setting same time does not notify listeners', () {
      // Arrange
      const time = TimeOfDay(hour: 8, minute: 15);
      var notifyCount = 0;
      final controller = ACTimeInputController(time: time)
        ..addListener(() => notifyCount++)

        // Act
        ..time = time;

      // Assert
      expect(notifyCount, equals(0));

      controller.dispose();
    });

    test('setting null after non-null notifies listeners', () {
      // Arrange
      var notified = false;
      final controller = ACTimeInputController(
        time: const TimeOfDay(hour: 12, minute: 0),
      )
        ..addListener(() => notified = true)

        // Act
        ..time = null;

      // Assert
      expect(notified, isTrue);
      expect(controller.time, isNull);

      controller.dispose();
    });

    test('onChanged callback is called when time changes', () {
      // Arrange
      TimeOfDay? receivedTime;
      final controller = ACTimeInputController(
        onChanged: (time) => receivedTime = time,
      )

        // Act
        ..time = const TimeOfDay(hour: 16, minute: 45);

      // Assert
      expect(receivedTime, equals(const TimeOfDay(hour: 16, minute: 45)));

      controller.dispose();
    });

    test('onChanged callback receives null when time is cleared', () {
      // Arrange
      TimeOfDay? receivedTime = const TimeOfDay(hour: 0, minute: 0);
      final controller = ACTimeInputController(
        time: const TimeOfDay(hour: 10, minute: 0),
        onChanged: (time) => receivedTime = time,
      )

        // Act
        ..time = null;

      // Assert
      expect(receivedTime, isNull);

      controller.dispose();
    });

    test('onChanged is not called when same value is set', () {
      // Arrange
      var callCount = 0;
      const time = TimeOfDay(hour: 9, minute: 30);
      final controller = ACTimeInputController(
        time: time,
        onChanged: (_) => callCount++,
      )

        // Act
        ..time = time;

      // Assert
      expect(callCount, equals(0));

      controller.dispose();
    });

    test('multiple listeners are notified', () {
      // Arrange
      var count1 = 0;
      var count2 = 0;
      final controller = ACTimeInputController()
        ..addListener(() => count1++)
        ..addListener(() => count2++)

        // Act
        ..time = const TimeOfDay(hour: 11, minute: 0);

      // Assert
      expect(count1, equals(1));
      expect(count2, equals(1));

      controller.dispose();
    });

    test('onChanged can be reassigned', () {
      // Arrange
      var firstCalled = false;
      var secondCalled = false;
      final controller = ACTimeInputController(
        onChanged: (_) => firstCalled = true,
      )

        // Act
        ..onChanged = (_) {
          secondCalled = true;
        }
        ..time = const TimeOfDay(hour: 5, minute: 0);

      // Assert
      expect(firstCalled, isFalse);
      expect(secondCalled, isTrue);

      controller.dispose();
    });
  });
}
