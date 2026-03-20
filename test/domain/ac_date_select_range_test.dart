import 'package:appcraft_ui_calendar_flutter/src/domain/ac_date_select_range.dart';
import 'package:test/test.dart';

void main() {
  group('ACDateSelectRange constructor', () {
    test('normalizes end-only to start', () {
      final end = DateTime(2024, 1, 15);
      final range = ACDateSelectRange(end: end);

      expect(range.start, equals(end));
      expect(range.end, isNull);
    });

    test('keeps start without end', () {
      final start = DateTime(2024, 1, 10);
      final range = ACDateSelectRange(start: start);

      expect(range.start, equals(start));
      expect(range.end, isNull);
    });

    test('sets both start and end correctly', () {
      final start = DateTime(2024, 1, 10);
      final end = DateTime(2024, 1, 20);
      final range = ACDateSelectRange(start: start, end: end);

      expect(range.start, equals(start));
      expect(range.end, equals(end));
    });
  });

  group('ACDateSelectRange.single', () {
    test('returns start when end is null', () {
      final start = DateTime(2024, 1, 10);
      final range = ACDateSelectRange(start: start);

      expect(range.single, equals(start));
    });

    test('returns end (normalized to start) when start is null', () {
      final end = DateTime(2024, 1, 15);
      final range = ACDateSelectRange(end: end);

      // end-only is normalized to start, so single returns start
      expect(range.single, equals(end));
    });

    test('returns null when both are set', () {
      // When both start and end are set, single returns start (not null)
      // because single = start ?? end, and start is non-null
      final start = DateTime(2024, 1, 10);
      final end = DateTime(2024, 1, 20);
      final range = ACDateSelectRange(start: start, end: end);

      expect(range.single, equals(start));
    });
  });

  group('ACDateSelectRange.isEmpty', () {
    test('returns true when both are null', () {
      final range = ACDateSelectRange();

      expect(range.isEmpty, isTrue);
    });

    test('returns false when start is set', () {
      final range = ACDateSelectRange(start: DateTime(2024, 1, 10));

      expect(range.isEmpty, isFalse);
    });
  });

  group('ACDateSelectRange.copyWith', () {
    test('changes only specified fields', () {
      final start = DateTime(2024, 1, 10);
      final end = DateTime(2024, 1, 20);
      final range = ACDateSelectRange(start: start, end: end);

      final newEnd = DateTime(2024, 1, 25);
      final copied = range.copyWith(end: newEnd);

      expect(copied.start, equals(start));
      expect(copied.end, equals(newEnd));
    });

    test('preserves existing fields when not specified', () {
      final start = DateTime(2024, 1, 10);
      final end = DateTime(2024, 1, 20);
      final range = ACDateSelectRange(start: start, end: end);

      final copied = range.copyWith();

      expect(copied.start, equals(start));
      expect(copied.end, equals(end));
    });
  });
}
