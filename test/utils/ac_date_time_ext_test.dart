import 'package:appcraft_ui_calendar_flutter/src/utils/src/ac_date_time_ext.dart';
import 'package:test/test.dart';

void main() {
  group('ACDateTimeExt.equalToDay', () {
    test('returns true for same dates with different times', () {
      final date1 = DateTime(2024, 1, 15, 10, 30);
      final date2 = DateTime(2024, 1, 15, 18, 45);

      expect(date1.equalToDay(date2), isTrue);
    });

    test('returns false for different days', () {
      final date1 = DateTime(2024, 1, 15);
      final date2 = DateTime(2024, 1, 16);

      expect(date1.equalToDay(date2), isFalse);
    });

    test('returns true for identical dates', () {
      final date1 = DateTime(2024, 1, 15, 12, 0);
      final date2 = DateTime(2024, 1, 15, 12, 0);

      expect(date1.equalToDay(date2), isTrue);
    });

    test('returns true for midnight 00:00 and 23:59 of the same day', () {
      final midnight = DateTime(2024, 1, 15, 0, 0, 0);
      final endOfDay = DateTime(2024, 1, 15, 23, 59, 59);

      expect(midnight.equalToDay(endOfDay), isTrue);
    });
  });
}
