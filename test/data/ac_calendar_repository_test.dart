import 'package:appcraft_ui_calendar_flutter/src/data/src/ac_default_calendar_repository.dart';
import 'package:appcraft_ui_calendar_flutter/src/domain/src/ac_date_range.dart';
import 'package:test/test.dart';

void main() {
  group('ACDefaultCalendarRepository.getMonthDays', () {
    test('returns a multiple of 7 days filling full weeks', () {
      final repo = ACDefaultCalendarRepository();
      // January 2024 starts on Monday → 5 rows × 7 = 35
      final days = repo.getMonthDays(DateTime(2024, 1, 15));

      expect(days.length % 7, equals(0));
      expect(days.length, greaterThanOrEqualTo(28));
    });

    test('first day of grid is weekStart', () {
      final repo = ACDefaultCalendarRepository();
      final days = repo.getMonthDays(DateTime(2024, 1, 15));

      expect(days.first.weekday, equals(DateTime.monday));
    });

    test('contains days from previous and next months', () {
      final repo = ACDefaultCalendarRepository();
      // March 2024 starts on Friday
      final days = repo.getMonthDays(DateTime(2024, 3, 15));

      // First days should be from February (filling the grid)
      expect(days.first.month, isNot(equals(3)));
    });

    test('works correctly for February of a leap year', () {
      final repo = ACDefaultCalendarRepository();
      final days = repo.getMonthDays(DateTime(2024, 2, 1));

      // Should contain Feb 29 (2024 is a leap year)
      final feb29 = days.where(
        (d) => d.year == 2024 && d.month == 2 && d.day == 29,
      );
      expect(feb29, isNotEmpty);
    });

    test('works with weekStart = sunday', () {
      final repo = ACDefaultCalendarRepository(weekStart: DateTime.sunday);
      final days = repo.getMonthDays(DateTime(2024, 1, 15));

      expect(days.first.weekday, equals(DateTime.sunday));
    });
  });

  group('ACDefaultCalendarRepository.startOfMonth', () {
    test('returns first day of the month', () {
      final repo = ACDefaultCalendarRepository();
      final result = repo.startOfMonth(DateTime(2024, 3, 15, 10, 30));

      expect(result.year, equals(2024));
      expect(result.month, equals(3));
      expect(result.day, equals(1));
    });

    test('resets time to 00:00', () {
      final repo = ACDefaultCalendarRepository();
      final result = repo.startOfMonth(DateTime(2024, 3, 15, 10, 30));

      expect(result.hour, equals(0));
      expect(result.minute, equals(0));
    });
  });

  group('ACDefaultCalendarRepository.addMonths', () {
    test('adds positive months', () {
      final repo = ACDefaultCalendarRepository();
      final result = repo.addMonths(DateTime(2024, 3, 1), 2);

      expect(result.year, equals(2024));
      expect(result.month, equals(5));
    });

    test('subtracts months with negative value', () {
      final repo = ACDefaultCalendarRepository();
      final result = repo.addMonths(DateTime(2024, 3, 1), -2);

      expect(result.year, equals(2024));
      expect(result.month, equals(1));
    });

    test('crosses year boundary (December + 1 = January next year)', () {
      final repo = ACDefaultCalendarRepository();
      final result = repo.addMonths(DateTime(2024, 12, 1), 1);

      expect(result.year, equals(2025));
      expect(result.month, equals(1));
    });
  });

  group('ACDefaultCalendarRepository.getWeekDays', () {
    test('returns 7 days', () {
      final repo = ACDefaultCalendarRepository();
      final days = repo.getWeekDays();

      expect(days.length, equals(7));
    });

    test('first day matches weekStart (monday by default)', () {
      final repo = ACDefaultCalendarRepository();
      final days = repo.getWeekDays();

      expect(days.first.weekday, equals(DateTime.monday));
    });

    test('first day matches custom weekStart', () {
      final repo = ACDefaultCalendarRepository(weekStart: DateTime.sunday);
      final days = repo.getWeekDays();

      expect(days.first.weekday, equals(DateTime.sunday));
    });
  });

  group('ACDefaultCalendarRepository.getMonths', () {
    test('returns 1-12 for a year fully inside range', () {
      final repo = ACDefaultCalendarRepository();
      final range = ACDateRange(
        min: DateTime(2020, 1, 1),
        max: DateTime(2030, 12, 31),
      );
      final months = repo.getMonths(year: 2024, range: range);

      expect(months, equals([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]));
    });

    test('clips start month for min year', () {
      final repo = ACDefaultCalendarRepository();
      final range = ACDateRange(
        min: DateTime(2024, 3, 1),
        max: DateTime(2025, 12, 31),
      );
      final months = repo.getMonths(year: 2024, range: range);

      expect(months.first, equals(3));
    });

    test('clips end month for max year', () {
      final repo = ACDefaultCalendarRepository();
      final range = ACDateRange(
        min: DateTime(2020, 1, 1),
        max: DateTime(2024, 9, 30),
      );
      final months = repo.getMonths(year: 2024, range: range);

      expect(months.last, equals(9));
    });
  });

  group('ACDefaultCalendarRepository.getYears', () {
    test('returns list of years from min to max', () {
      final repo = ACDefaultCalendarRepository();
      final range = ACDateRange(
        min: DateTime(2020, 1, 1),
        max: DateTime(2024, 12, 31),
      );
      final years = repo.getYears(range: range);

      expect(years, equals([2020, 2021, 2022, 2023, 2024]));
    });
  });
}
