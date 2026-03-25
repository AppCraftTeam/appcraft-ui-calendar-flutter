import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ACLightCalendarThemeData backgroundColor', () {
    test('defaults to Color(0xFFFFFFFF) when not specified', () {
      // Arrange & Act
      final theme = ACLightCalendarThemeData();

      // Assert
      expect(theme.backgroundColor, const Color(0xFFFFFFFF));
    });

    test('uses provided value when backgroundColor is specified', () {
      // Arrange & Act
      final theme = ACLightCalendarThemeData(backgroundColor: Colors.red);

      // Assert
      expect(theme.backgroundColor, Colors.red);
    });

    test('backgroundColor is non-nullable Color type', () {
      // Arrange & Act
      final theme = ACLightCalendarThemeData();

      // Assert
      expect(theme.backgroundColor, isA<Color>());
    });

    test('copyWith preserves backgroundColor when not overridden', () {
      // Arrange
      final theme = ACLightCalendarThemeData(backgroundColor: Colors.blue);

      // Act
      final copied = theme.copyWith();

      // Assert
      expect(copied.backgroundColor, Colors.blue);
    });

    test('copyWith overrides backgroundColor when specified', () {
      // Arrange
      final theme = ACLightCalendarThemeData(backgroundColor: Colors.blue);

      // Act
      final copied = theme.copyWith(backgroundColor: Colors.green);

      // Assert
      expect(copied.backgroundColor, Colors.green);
    });

    test('lerp interpolates backgroundColor', () {
      // Arrange
      final themeA = ACLightCalendarThemeData(backgroundColor: Colors.white);
      final themeB = ACLightCalendarThemeData(backgroundColor: Colors.black);

      // Act
      final result = themeA.lerp(themeB, 0.5);

      // Assert
      expect(
        result.backgroundColor,
        Color.lerp(Colors.white, Colors.black, 0.5),
      );
    });
  });
}
