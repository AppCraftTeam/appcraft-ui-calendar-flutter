import 'package:appcraft_ui_calendar_flutter/src/domain/src/ac_time_select_range.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ACTimeSelectRange constructor', () {
    test('normalizes end-only to start', () {
      const end = TimeOfDay(hour: 14, minute: 30);
      final range = ACTimeSelectRange(end: end);

      expect(range.start, equals(end));
      expect(range.end, isNull);
    });

    test('keeps start without end', () {
      const start = TimeOfDay(hour: 10, minute: 0);
      final range = ACTimeSelectRange(start: start);

      expect(range.start, equals(start));
      expect(range.end, isNull);
    });

    test('sets both start and end correctly', () {
      const start = TimeOfDay(hour: 10, minute: 0);
      const end = TimeOfDay(hour: 18, minute: 30);
      final range = ACTimeSelectRange(start: start, end: end);

      expect(range.start, equals(start));
      expect(range.end, equals(end));
    });
  });

  group('ACTimeSelectRange.single', () {
    test('returns start when end is null', () {
      const start = TimeOfDay(hour: 10, minute: 0);
      final range = ACTimeSelectRange(start: start);

      expect(range.single, equals(start));
    });

    test('returns start (normalized from end) when only end provided', () {
      const end = TimeOfDay(hour: 14, minute: 30);
      final range = ACTimeSelectRange(end: end);

      expect(range.single, equals(end));
    });
  });

  group('ACTimeSelectRange.isEmpty', () {
    test('returns true when both are null', () {
      final range = ACTimeSelectRange();

      expect(range.isEmpty, isTrue);
    });

    test('returns false when start is set', () {
      final range = ACTimeSelectRange(
        start: const TimeOfDay(hour: 10, minute: 0),
      );

      expect(range.isEmpty, isFalse);
    });
  });

  group('ACTimeSelectRange.copyWith', () {
    test('changes only specified fields', () {
      const start = TimeOfDay(hour: 10, minute: 0);
      const end = TimeOfDay(hour: 18, minute: 30);
      final range = ACTimeSelectRange(start: start, end: end);

      const newEnd = TimeOfDay(hour: 20, minute: 0);
      final copied = range.copyWith(end: newEnd);

      expect(copied.start, equals(start));
      expect(copied.end, equals(newEnd));
    });

    test('preserves existing fields when not specified', () {
      const start = TimeOfDay(hour: 10, minute: 0);
      const end = TimeOfDay(hour: 18, minute: 30);
      final range = ACTimeSelectRange(start: start, end: end);

      final copied = range.copyWith();

      expect(copied.start, equals(start));
      expect(copied.end, equals(end));
    });
  });
}
