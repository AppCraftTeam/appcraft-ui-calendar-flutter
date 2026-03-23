import 'package:appcraft_ui_calendar_flutter/src/domain/src/ac_date_range.dart';
import 'package:test/test.dart';

void main() {
  final range = ACDateRange(
    min: DateTime(2024, 1, 1),
    max: DateTime(2024, 12, 31),
  );

  group('ACDateRange.clampDate', () {
    test('returns date unchanged when inside range', () {
      final date = DateTime(2024, 6, 15);
      expect(range.clampDate(date), equals(date));
    });

    test('returns min when date is before min', () {
      final date = DateTime(2023, 6, 15);
      expect(range.clampDate(date), equals(range.min));
    });

    test('returns max when date is after max', () {
      final date = DateTime(2025, 6, 15);
      expect(range.clampDate(date), equals(range.max));
    });

    test('returns date unchanged when equal to min', () {
      final date = DateTime(2024, 1, 1);
      expect(range.clampDate(date), equals(date));
    });

    test('returns date unchanged when equal to max', () {
      final date = DateTime(2024, 12, 31);
      expect(range.clampDate(date), equals(date));
    });
  });
}
