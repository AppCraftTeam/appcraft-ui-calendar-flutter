import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ACCalendarThemeData factory', () {
    test('creates instance with default Light sub-themes', () {
      final theme = ACLightCalendarThemeData();

      expect(theme.dayTheme, isA<ACLightDayThemeData>());
      expect(theme.weekTheme, isA<ACLightWeekThemeData>());
      expect(theme.monthPickerTheme, isA<ACLightMonthPickerThemeData>());
      expect(theme.pagesCalendarHeaderTheme,
          isA<ACLightPagesCalendarHeaderThemeData>());
      expect(theme.wheelPickerTheme, isA<ACLightWheelPickerThemeData>());
      expect(theme.titledMonthTheme, isA<ACLightTitledMonthThemeData>());
      expect(theme.timeInputTheme, isA<ACLightTimeInputThemeData>());
      expect(theme.titledTimeTheme, isA<ACLightTitledTimeThemeData>());
      expect(theme.backgroundColor, const Color(0xFFFFFFFF));
    });

    test('accepts custom backgroundColor', () {
      final theme = ACLightCalendarThemeData(backgroundColor: Colors.red);

      expect(theme.backgroundColor, Colors.red);
    });

    test('accepts custom sub-theme', () {
      final customDay = ACLightDayThemeData(textColor: Colors.green);
      final theme = ACLightCalendarThemeData(dayTheme: customDay);

      expect(theme.dayTheme, same(customDay));
    });
  });

  group('ACCalendarThemeData.raw', () {
    test('stores all provided values', () {
      final dayTheme = ACLightDayThemeData();
      final weekTheme = ACLightWeekThemeData();
      final monthPickerTheme = ACLightMonthPickerThemeData();
      final headerTheme = ACLightPagesCalendarHeaderThemeData();
      final wheelTheme = ACLightWheelPickerThemeData();
      final titledMonthTheme = ACLightTitledMonthThemeData();
      final timeInputTheme = ACLightTimeInputThemeData();
      final titledTimeTheme = ACLightTitledTimeThemeData();

      final theme = ACLightCalendarThemeData.raw(
        pagesCalendarHeaderTheme: headerTheme,
        dayTheme: dayTheme,
        weekTheme: weekTheme,
        monthPickerTheme: monthPickerTheme,
        wheelPickerTheme: wheelTheme,
        titledMonthTheme: titledMonthTheme,
        timeInputTheme: timeInputTheme,
        titledTimeTheme: titledTimeTheme,
        backgroundColor: Colors.blue,
      );

      expect(theme.pagesCalendarHeaderTheme, same(headerTheme));
      expect(theme.dayTheme, same(dayTheme));
      expect(theme.weekTheme, same(weekTheme));
      expect(theme.monthPickerTheme, same(monthPickerTheme));
      expect(theme.wheelPickerTheme, same(wheelTheme));
      expect(theme.titledMonthTheme, same(titledMonthTheme));
      expect(theme.timeInputTheme, same(timeInputTheme));
      expect(theme.titledTimeTheme, same(titledTimeTheme));
      expect(theme.backgroundColor, Colors.blue);
    });
  });

  group('ACCalendarThemeData.copyWith (T023)', () {
    test('returns identical values when called without arguments', () {
      final original = ACLightCalendarThemeData(backgroundColor: Colors.amber);
      final copy = original.copyWith();

      expect(copy.dayTheme, same(original.dayTheme));
      expect(copy.weekTheme, same(original.weekTheme));
      expect(copy.monthPickerTheme, same(original.monthPickerTheme));
      expect(copy.pagesCalendarHeaderTheme,
          same(original.pagesCalendarHeaderTheme));
      expect(copy.wheelPickerTheme, same(original.wheelPickerTheme));
      expect(copy.titledMonthTheme, same(original.titledMonthTheme));
      expect(copy.timeInputTheme, same(original.timeInputTheme));
      expect(copy.titledTimeTheme, same(original.titledTimeTheme));
      expect(copy.backgroundColor, Colors.amber);
    });

    test('replaces backgroundColor when provided', () {
      final original = ACLightCalendarThemeData(backgroundColor: Colors.red);
      final copy = original.copyWith(backgroundColor: Colors.blue);

      expect(copy.backgroundColor, Colors.blue);
    });

    test('replaces dayTheme when provided', () {
      final original = ACLightCalendarThemeData();
      final customDay = ACLightDayThemeData(textColor: Colors.purple);
      final copy = original.copyWith(dayTheme: customDay);

      expect(copy.dayTheme, same(customDay));
      // Other fields remain unchanged
      expect(copy.weekTheme, same(original.weekTheme));
    });

    test('replaces weekTheme when provided', () {
      final original = ACLightCalendarThemeData();
      final customWeek = ACLightWeekThemeData(textColor: Colors.orange);
      final copy = original.copyWith(weekTheme: customWeek);

      expect(copy.weekTheme, same(customWeek));
      expect(copy.dayTheme, same(original.dayTheme));
    });

    test('replaces monthPickerTheme when provided', () {
      final original = ACLightCalendarThemeData();
      final custom = ACLightMonthPickerThemeData();
      final copy = original.copyWith(monthPickerTheme: custom);

      expect(copy.monthPickerTheme, same(custom));
    });

    test('replaces pagesCalendarHeaderTheme when provided', () {
      final original = ACLightCalendarThemeData();
      final custom = ACLightPagesCalendarHeaderThemeData();
      final copy = original.copyWith(pagesCalendarHeaderTheme: custom);

      expect(copy.pagesCalendarHeaderTheme, same(custom));
    });

    test('replaces wheelPickerTheme when provided', () {
      final original = ACLightCalendarThemeData();
      final custom = ACLightWheelPickerThemeData();
      final copy = original.copyWith(wheelPickerTheme: custom);

      expect(copy.wheelPickerTheme, same(custom));
    });

    test('replaces titledMonthTheme when provided', () {
      final original = ACLightCalendarThemeData();
      final custom = ACLightTitledMonthThemeData();
      final copy = original.copyWith(titledMonthTheme: custom);

      expect(copy.titledMonthTheme, same(custom));
    });

    test('replaces timeInputTheme when provided', () {
      final original = ACLightCalendarThemeData();
      final custom = ACLightTimeInputThemeData();
      final copy = original.copyWith(timeInputTheme: custom);

      expect(copy.timeInputTheme, same(custom));
    });

    test('replaces titledTimeTheme when provided', () {
      final original = ACLightCalendarThemeData();
      final custom = ACLightTitledTimeThemeData();
      final copy = original.copyWith(titledTimeTheme: custom);

      expect(copy.titledTimeTheme, same(custom));
    });

    test('replaces multiple fields at once', () {
      final original = ACLightCalendarThemeData();
      final customDay = ACLightDayThemeData(textColor: Colors.teal);
      final customWeek = ACLightWeekThemeData(textColor: Colors.pink);

      final copy = original.copyWith(
        dayTheme: customDay,
        weekTheme: customWeek,
        backgroundColor: Colors.grey,
      );

      expect(copy.dayTheme, same(customDay));
      expect(copy.weekTheme, same(customWeek));
      expect(copy.backgroundColor, Colors.grey);
      // Unchanged fields
      expect(copy.monthPickerTheme, same(original.monthPickerTheme));
    });
  });

  group('ACCalendarThemeData.lerp (T024)', () {
    test('returns this when other is null', () {
      final theme = ACLightCalendarThemeData(backgroundColor: Colors.red);
      final result = theme.lerp(null, 0.5);

      expect(result.backgroundColor, Colors.red);
    });

    test('interpolates backgroundColor at t=0.5', () {
      final a =
          ACLightCalendarThemeData(backgroundColor: const Color(0xFF000000));
      final b =
          ACLightCalendarThemeData(backgroundColor: const Color(0xFFFFFFFF));
      final result = a.lerp(b, 0.5);

      // Color.lerp between black and white at 0.5 should yield grey
      final expected = Color.lerp(
        const Color(0xFF000000),
        const Color(0xFFFFFFFF),
        0.5,
      );
      expect(result.backgroundColor, expected);
    });

    test('returns values close to this at t=0', () {
      final a =
          ACLightCalendarThemeData(backgroundColor: const Color(0xFF000000));
      final b =
          ACLightCalendarThemeData(backgroundColor: const Color(0xFFFFFFFF));
      final result = a.lerp(b, 0);

      expect(result.backgroundColor, const Color(0xFF000000));
    });

    test('returns values close to other at t=1', () {
      final a =
          ACLightCalendarThemeData(backgroundColor: const Color(0xFF000000));
      final b =
          ACLightCalendarThemeData(backgroundColor: const Color(0xFFFFFFFF));
      final result = a.lerp(b, 1);

      expect(result.backgroundColor, const Color(0xFFFFFFFF));
    });

    test('lerps sub-themes (dayTheme colors interpolated)', () {
      final a = ACLightCalendarThemeData(
        dayTheme: ACLightDayThemeData(textColor: const Color(0xFF000000)),
      );
      final b = ACLightCalendarThemeData(
        dayTheme: ACLightDayThemeData(textColor: const Color(0xFFFFFFFF)),
      );
      final result = a.lerp(b, 0.5);

      final expectedColor = Color.lerp(
        const Color(0xFF000000),
        const Color(0xFFFFFFFF),
        0.5,
      );
      expect(result.dayTheme.textColor, expectedColor);
    });

    test('handles default backgroundColor on both sides', () {
      final a = ACLightCalendarThemeData();
      final b = ACLightCalendarThemeData();
      final result = a.lerp(b, 0.5);

      expect(result.backgroundColor, const Color(0xFFFFFFFF));
    });

    test('lerps backgroundColor between two values', () {
      final a =
          ACLightCalendarThemeData(backgroundColor: const Color(0xFFFF0000));
      final b =
          ACLightCalendarThemeData(backgroundColor: const Color(0xFF0000FF));
      final result = a.lerp(b, 1);

      final expected =
          Color.lerp(const Color(0xFFFF0000), const Color(0xFF0000FF), 1);
      expect(result.backgroundColor, expected);
    });
  });

  group('ACCalendarThemeExtension.of (T025)', () {
    testWidgets('returns default theme when no extension provided',
        (tester) async {
      // Arrange
      late ACCalendarThemeData capturedTheme;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              capturedTheme = ACCalendarThemeExtension.of(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      // Assert -- fallback returns default Light sub-themes
      expect(capturedTheme.dayTheme, isA<ACLightDayThemeData>());
      expect(capturedTheme.weekTheme, isA<ACLightWeekThemeData>());
      expect(
          capturedTheme.monthPickerTheme, isA<ACLightMonthPickerThemeData>());
      expect(capturedTheme.pagesCalendarHeaderTheme,
          isA<ACLightPagesCalendarHeaderThemeData>());
      expect(
          capturedTheme.wheelPickerTheme, isA<ACLightWheelPickerThemeData>());
      expect(
          capturedTheme.titledMonthTheme, isA<ACLightTitledMonthThemeData>());
      expect(capturedTheme.timeInputTheme, isA<ACLightTimeInputThemeData>());
      expect(capturedTheme.titledTimeTheme, isA<ACLightTitledTimeThemeData>());
      expect(capturedTheme.backgroundColor, const Color(0xFFFFFFFF));
    });

    testWidgets('returns theme from ThemeData.extensions when provided',
        (tester) async {
      // Arrange
      final customDay = ACLightDayThemeData(textColor: Colors.cyan);
      final customTheme = ACLightCalendarThemeData(
        dayTheme: customDay,
        backgroundColor: Colors.green,
      );

      late ACCalendarThemeData capturedTheme;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: <ThemeExtension>[
              ACCalendarThemeExtension(data: customTheme),
            ],
          ),
          home: Builder(
            builder: (context) {
              capturedTheme = ACCalendarThemeExtension.of(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      // Assert
      expect(capturedTheme.backgroundColor, Colors.green);
      expect(capturedTheme.dayTheme, same(customDay));
    });

    testWidgets('returns data from extension instance in ThemeData',
        (tester) async {
      // Arrange
      final customTheme = ACLightCalendarThemeData(
        backgroundColor: Colors.deepPurple,
      );

      late ACCalendarThemeData capturedTheme;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: <ThemeExtension>[
              ACCalendarThemeExtension(data: customTheme),
            ],
          ),
          home: Builder(
            builder: (context) {
              capturedTheme = ACCalendarThemeExtension.of(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      // Assert -- should be the same object reference
      expect(capturedTheme, same(customTheme));
    });
  });

  group('ACCalendarThemeExtension', () {
    test('copyWith returns new instance with replaced data', () {
      final data1 = ACLightCalendarThemeData(backgroundColor: Colors.red);
      final data2 = ACLightCalendarThemeData(backgroundColor: Colors.blue);
      final ext = ACCalendarThemeExtension(data: data1);

      final copy = ext.copyWith(data: data2);

      expect(copy.data, same(data2));
    });

    test('copyWith without arguments preserves data', () {
      final data = ACLightCalendarThemeData(backgroundColor: Colors.red);
      final ext = ACCalendarThemeExtension(data: data);

      final copy = ext.copyWith();

      expect(copy.data, same(data));
    });

    test('lerp interpolates data between two extensions', () {
      final extA = ACCalendarThemeExtension(
        data:
            ACLightCalendarThemeData(backgroundColor: const Color(0xFF000000)),
      );
      final extB = ACCalendarThemeExtension(
        data:
            ACLightCalendarThemeData(backgroundColor: const Color(0xFFFFFFFF)),
      );

      final result = extA.lerp(extB, 0.5);

      final expected = Color.lerp(
        const Color(0xFF000000),
        const Color(0xFFFFFFFF),
        0.5,
      );
      expect(result.data.backgroundColor, expected);
    });

    test('lerp returns this when other is not ACCalendarThemeExtension', () {
      final ext = ACCalendarThemeExtension(
        data: ACLightCalendarThemeData(backgroundColor: Colors.red),
      );

      final result = ext.lerp(null, 0.5);

      expect(result.data.backgroundColor, Colors.red);
    });
  });

  group('ACLightCalendarThemeData', () {
    test('ACLightCalendarThemeData implements ACCalendarThemeData', () {
      final theme = ACLightCalendarThemeData();

      expect(theme, isA<ACCalendarThemeData>());
    });
  });
}
