import 'package:appcraft_ui_calendar_flutter/src/domain/src/ac_day_month_position.dart';
import 'package:test/test.dart';

void main() {
  group('ACDayMonthPosition.forDay', () {
    test('returns leading when day month is earlier in same year', () {
      // Arrange
      final day = DateTime(2024, 2, 28);
      final monthDate = DateTime(2024, 3, 1);

      // Act
      final position = ACDayMonthPosition.forDay(day, monthDate);

      // Assert
      expect(position, equals(ACDayMonthPosition.leading));
    });

    test('returns trailing when day month is later in same year', () {
      // Arrange
      final day = DateTime(2024, 4, 1);
      final monthDate = DateTime(2024, 3, 1);

      // Act
      final position = ACDayMonthPosition.forDay(day, monthDate);

      // Assert
      expect(position, equals(ACDayMonthPosition.trailing));
    });

    test('returns current when month and year match', () {
      // Arrange
      final day = DateTime(2024, 3, 15);
      final monthDate = DateTime(2024, 3, 1);

      // Act
      final position = ACDayMonthPosition.forDay(day, monthDate);

      // Assert
      expect(position, equals(ACDayMonthPosition.current));
    });

    test('returns leading when same month number but previous year', () {
      // Arrange
      final day = DateTime(2023, 3, 10);
      final monthDate = DateTime(2024, 3, 1);

      // Act
      final position = ACDayMonthPosition.forDay(day, monthDate);

      // Assert
      expect(position, equals(ACDayMonthPosition.leading));
    });

    test('returns trailing when same month number but next year', () {
      // Arrange
      final day = DateTime(2025, 3, 10);
      final monthDate = DateTime(2024, 3, 1);

      // Act
      final position = ACDayMonthPosition.forDay(day, monthDate);

      // Assert
      expect(position, equals(ACDayMonthPosition.trailing));
    });

    test('returns current when day has non-zero time', () {
      // Arrange
      final day = DateTime(2024, 3, 15, 14, 30);
      final monthDate = DateTime(2024, 3, 1);

      // Act
      final position = ACDayMonthPosition.forDay(day, monthDate);

      // Assert
      expect(position, equals(ACDayMonthPosition.current));
    });

    test('returns current when day is first day of month', () {
      // Arrange
      final day = DateTime(2024, 3, 1);
      final monthDate = DateTime(2024, 3, 31);

      // Act
      final position = ACDayMonthPosition.forDay(day, monthDate);

      // Assert
      expect(position, equals(ACDayMonthPosition.current));
    });

    test('returns current when day is last day of month', () {
      // Arrange
      final day = DateTime(2024, 3, 31);
      final monthDate = DateTime(2024, 3, 1);

      // Act
      final position = ACDayMonthPosition.forDay(day, monthDate);

      // Assert
      expect(position, equals(ACDayMonthPosition.current));
    });
  });
}
