import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // ---------------------------------------------------------------------------
  // ACDayThemeData
  // ---------------------------------------------------------------------------
  group('ACDayThemeData', () {
    test('factory creates instance with default values', () {
      final theme = ACLightDayThemeData();

      expect(theme.selectedBackgroundColor, const Color(0xFFD2DCFF));
      expect(theme.middleSelectedBackgroundColor, const Color(0xFFEDF3FF));
      expect(theme.inactiveTextColor, const Color(0xFFD5DDE7));
      expect(theme.textColor, const Color(0xFF000000));
      expect(theme.textStyle.fontWeight, FontWeight.w400);
      expect(theme.textStyle.fontSize, 20);
      expect(theme.todayTextStyle.fontWeight, FontWeight.w600);
    });

    test('copyWith preserves values when called without arguments', () {
      final original = ACLightDayThemeData(
        selectedBackgroundColor: Colors.red,
        textColor: Colors.blue,
      );
      final copy = original.copyWith();

      expect(copy.selectedBackgroundColor, original.selectedBackgroundColor);
      expect(copy.middleSelectedBackgroundColor,
          original.middleSelectedBackgroundColor);
      expect(copy.inactiveTextColor, original.inactiveTextColor);
      expect(copy.textColor, original.textColor);
      expect(copy.textStyle, original.textStyle);
      expect(copy.todayTextStyle, original.todayTextStyle);
    });

    test('copyWith replaces specific fields', () {
      final original = ACLightDayThemeData();
      final copy = original.copyWith(
        selectedBackgroundColor: Colors.red,
        textColor: Colors.green,
      );

      expect(copy.selectedBackgroundColor, Colors.red);
      expect(copy.textColor, Colors.green);
      // Unchanged fields
      expect(copy.inactiveTextColor, original.inactiveTextColor);
    });

    test('lerp returns this when other is null', () {
      final a = ACLightDayThemeData(textColor: const Color(0xFFFF0000));
      final result = a.lerp(null, 0.5);

      expect(result.textColor, const Color(0xFFFF0000));
    });

    test('lerp interpolates Color fields at t=0.5', () {
      final a = ACLightDayThemeData(
        textColor: const Color(0xFF000000),
        selectedBackgroundColor: const Color(0xFF000000),
      );
      final b = ACLightDayThemeData(
        textColor: const Color(0xFFFFFFFF),
        selectedBackgroundColor: const Color(0xFFFFFFFF),
      );

      final result = a.lerp(b, 0.5);

      expect(result.textColor,
          Color.lerp(const Color(0xFF000000), const Color(0xFFFFFFFF), 0.5));
      expect(result.selectedBackgroundColor,
          Color.lerp(const Color(0xFF000000), const Color(0xFFFFFFFF), 0.5));
    });

    test('lerp at t=0 returns this values', () {
      final a = ACLightDayThemeData(textColor: const Color(0xFFFF0000));
      final b = ACLightDayThemeData(textColor: const Color(0xFF00FF00));
      final result = a.lerp(b, 0);

      expect(result.textColor, const Color(0xFFFF0000));
    });

    test('lerp at t=1 returns other values', () {
      final a = ACLightDayThemeData(textColor: const Color(0xFFFF0000));
      final b = ACLightDayThemeData(textColor: const Color(0xFF00FF00));
      final result = a.lerp(b, 1);

      expect(result.textColor, const Color(0xFF00FF00));
    });
  });

  // ---------------------------------------------------------------------------
  // ACWeekThemeData
  // ---------------------------------------------------------------------------
  group('ACWeekThemeData', () {
    test('factory creates instance with default values', () {
      final theme = ACLightWeekThemeData();

      expect(theme.textColor, const Color(0xFFD5DDE7));
      expect(theme.textStyle.fontWeight, FontWeight.w600);
      expect(theme.textStyle.fontSize, 13);
    });

    test(
      'copyWith preserves values when called without arguments',
      () {
        final original = ACLightWeekThemeData(textColor: Colors.red);
        final copy = original.copyWith();

        expect(copy.textColor, original.textColor);
        expect(copy.textStyle.fontWeight, original.textStyle.fontWeight);
      },
    );

    test('copyWith replaces specific fields', () {
      final original = ACLightWeekThemeData();
      final copy = original.copyWith(textColor: Colors.purple);

      expect(copy.textColor, Colors.purple);
    });

    test('lerp returns this when other is null', () {
      final a = ACLightWeekThemeData(textColor: const Color(0xFF000000));
      final result = a.lerp(null, 0.5);

      expect(result.textColor, const Color(0xFF000000));
    });

    test('lerp interpolates Color fields at t=0.5', () {
      final a = ACLightWeekThemeData(textColor: const Color(0xFF000000));
      final b = ACLightWeekThemeData(textColor: const Color(0xFFFFFFFF));

      final result = a.lerp(b, 0.5);

      expect(result.textColor,
          Color.lerp(const Color(0xFF000000), const Color(0xFFFFFFFF), 0.5));
    });
  });

  // ---------------------------------------------------------------------------
  // ACMonthPickerThemeData
  // ---------------------------------------------------------------------------
  group('ACMonthPickerThemeData', () {
    test('factory creates instance with default values', () {
      final theme = ACLightMonthPickerThemeData();

      expect(theme.selectionColor, const Color(0xFFD2DCFF));
      expect(theme.actionTextColor, const Color(0xFF000000));
    });

    test(
      'copyWith preserves values when called without arguments',
      () {
        final original = ACLightMonthPickerThemeData(
          selectionColor: Colors.red,
          actionTextColor: Colors.blue,
        );
        final copy = original.copyWith();

        expect(copy.selectionColor, original.selectionColor);
        expect(copy.actionTextColor, original.actionTextColor);
      },
    );

    test('copyWith replaces specific fields', () {
      final original = ACLightMonthPickerThemeData();
      final copy = original.copyWith(selectionColor: Colors.teal);

      expect(copy.selectionColor, Colors.teal);
      expect(copy.actionTextColor, original.actionTextColor);
    });

    test('lerp returns this when other is null', () {
      final a = ACLightMonthPickerThemeData(
        selectionColor: const Color(0xFF000000),
      );
      final result = a.lerp(null, 0.5);

      expect(result.selectionColor, const Color(0xFF000000));
    });

    test('lerp interpolates Color fields at t=0.5', () {
      final a = ACLightMonthPickerThemeData(
        selectionColor: const Color(0xFF000000),
        actionTextColor: const Color(0xFF000000),
      );
      final b = ACLightMonthPickerThemeData(
        selectionColor: const Color(0xFFFFFFFF),
        actionTextColor: const Color(0xFFFFFFFF),
      );

      final result = a.lerp(b, 0.5);

      expect(result.selectionColor,
          Color.lerp(const Color(0xFF000000), const Color(0xFFFFFFFF), 0.5));
      expect(result.actionTextColor,
          Color.lerp(const Color(0xFF000000), const Color(0xFFFFFFFF), 0.5));
    });
  });

  // ---------------------------------------------------------------------------
  // ACPagesCalendarHeaderThemeData
  // ---------------------------------------------------------------------------
  group('ACPagesCalendarHeaderThemeData', () {
    test('factory creates instance with default values', () {
      final theme = ACLightPagesCalendarHeaderThemeData();

      expect(theme.arrowColor, const Color(0xFF000000));
      expect(theme.monthTextColor, const Color(0xFF000000));
      expect(theme.titleTextStyle.fontWeight, FontWeight.w600);
      expect(theme.titleTextStyle.fontSize, 17);
    });

    test(
      'copyWith preserves values when called without arguments',
      () {
        final original = ACLightPagesCalendarHeaderThemeData(
          arrowColor: Colors.red,
          monthTextColor: Colors.blue,
        );
        final copy = original.copyWith();

        expect(copy.arrowColor, original.arrowColor);
        expect(copy.monthTextColor, original.monthTextColor);
        expect(
            copy.titleTextStyle.fontWeight, original.titleTextStyle.fontWeight);
      },
    );

    test('copyWith replaces specific fields', () {
      final original = ACLightPagesCalendarHeaderThemeData();
      final copy = original.copyWith(arrowColor: Colors.orange);

      expect(copy.arrowColor, Colors.orange);
      expect(copy.monthTextColor, original.monthTextColor);
    });

    test('lerp returns this when other is null', () {
      final a = ACLightPagesCalendarHeaderThemeData(
        arrowColor: const Color(0xFF000000),
      );
      final result = a.lerp(null, 0.5);

      expect(result.arrowColor, const Color(0xFF000000));
    });

    test('lerp interpolates Color fields at t=0.5', () {
      final a = ACLightPagesCalendarHeaderThemeData(
        arrowColor: const Color(0xFF000000),
        monthTextColor: const Color(0xFF000000),
      );
      final b = ACLightPagesCalendarHeaderThemeData(
        arrowColor: const Color(0xFFFFFFFF),
        monthTextColor: const Color(0xFFFFFFFF),
      );

      final result = a.lerp(b, 0.5);

      expect(result.arrowColor,
          Color.lerp(const Color(0xFF000000), const Color(0xFFFFFFFF), 0.5));
      expect(result.monthTextColor,
          Color.lerp(const Color(0xFF000000), const Color(0xFFFFFFFF), 0.5));
    });
  });

  // ---------------------------------------------------------------------------
  // ACTimeInputThemeData
  // ---------------------------------------------------------------------------
  group('ACTimeInputThemeData', () {
    test('factory creates instance with default values', () {
      final theme = ACLightTimeInputThemeData();

      expect(theme.textColor, const Color(0xFF000000));
      expect(theme.hintColor, const Color(0xFF9A99A2));
      expect(theme.cursorColor, const Color(0xFF232326));
      expect(theme.backgroundColor, const Color(0x1F767680));
      expect(theme.textStyle.fontWeight, FontWeight.w400);
      expect(theme.textStyle.fontSize, 17);
    });

    test('copyWith preserves values when called without arguments', () {
      final original = ACLightTimeInputThemeData(
        textColor: Colors.red,
        hintColor: Colors.green,
        cursorColor: Colors.blue,
        backgroundColor: Colors.yellow,
      );
      final copy = original.copyWith();

      expect(copy.textColor, original.textColor);
      expect(copy.hintColor, original.hintColor);
      expect(copy.cursorColor, original.cursorColor);
      expect(copy.backgroundColor, original.backgroundColor);
      expect(copy.textStyle, original.textStyle);
    });

    test('copyWith replaces specific fields', () {
      final original = ACLightTimeInputThemeData();
      final copy = original.copyWith(
        textColor: Colors.red,
        cursorColor: Colors.blue,
      );

      expect(copy.textColor, Colors.red);
      expect(copy.cursorColor, Colors.blue);
      // Unchanged fields
      expect(copy.hintColor, original.hintColor);
      expect(copy.backgroundColor, original.backgroundColor);
    });

    test('lerp returns this when other is null', () {
      final a = ACLightTimeInputThemeData(
        textColor: const Color(0xFF000000),
      );
      final result = a.lerp(null, 0.5);

      expect(result.textColor, const Color(0xFF000000));
    });

    test('lerp interpolates Color fields at t=0.5', () {
      final a = ACLightTimeInputThemeData(
        textColor: const Color(0xFF000000),
        hintColor: const Color(0xFF000000),
        cursorColor: const Color(0xFF000000),
        backgroundColor: const Color(0xFF000000),
      );
      final b = ACLightTimeInputThemeData(
        textColor: const Color(0xFFFFFFFF),
        hintColor: const Color(0xFFFFFFFF),
        cursorColor: const Color(0xFFFFFFFF),
        backgroundColor: const Color(0xFFFFFFFF),
      );

      final result = a.lerp(b, 0.5);

      final expected =
          Color.lerp(const Color(0xFF000000), const Color(0xFFFFFFFF), 0.5);
      expect(result.textColor, expected);
      expect(result.hintColor, expected);
      expect(result.cursorColor, expected);
      expect(result.backgroundColor, expected);
    });
  });

  // ---------------------------------------------------------------------------
  // ACTitledMonthThemeData
  // ---------------------------------------------------------------------------
  group('ACTitledMonthThemeData', () {
    test('factory creates instance with default values', () {
      final theme = ACLightTitledMonthThemeData();

      expect(theme.titleColor, const Color(0xFF000000));
      expect(theme.titleTextStyle.fontWeight, FontWeight.w600);
      expect(theme.titleTextStyle.fontSize, 17);
    });

    test(
      'copyWith preserves values when called without arguments',
      () {
        final original = ACLightTitledMonthThemeData(titleColor: Colors.red);
        final copy = original.copyWith();

        expect(copy.titleColor, original.titleColor);
        expect(
            copy.titleTextStyle.fontWeight, original.titleTextStyle.fontWeight);
      },
    );

    test('copyWith replaces specific fields', () {
      final original = ACLightTitledMonthThemeData();
      final copy = original.copyWith(titleColor: Colors.indigo);

      expect(copy.titleColor, Colors.indigo);
    });

    test('lerp returns this when other is null', () {
      final a =
          ACLightTitledMonthThemeData(titleColor: const Color(0xFF000000));
      final result = a.lerp(null, 0.5);

      expect(result.titleColor, const Color(0xFF000000));
    });

    test('lerp interpolates Color fields at t=0.5', () {
      final a =
          ACLightTitledMonthThemeData(titleColor: const Color(0xFF000000));
      final b =
          ACLightTitledMonthThemeData(titleColor: const Color(0xFFFFFFFF));

      final result = a.lerp(b, 0.5);

      expect(result.titleColor,
          Color.lerp(const Color(0xFF000000), const Color(0xFFFFFFFF), 0.5));
    });
  });

  // ---------------------------------------------------------------------------
  // ACTitledTimeThemeData
  // ---------------------------------------------------------------------------
  group('ACTitledTimeThemeData', () {
    test('factory creates instance with default values', () {
      final theme = ACLightTitledTimeThemeData();

      expect(theme.titleColor, const Color(0xFF000000));
      expect(theme.titleTextStyle.fontWeight, FontWeight.w600);
      expect(theme.titleTextStyle.fontSize, 17);
    });

    test('copyWith preserves values when called without arguments', () {
      final original = ACLightTitledTimeThemeData(titleColor: Colors.red);
      final copy = original.copyWith();

      expect(copy.titleColor, original.titleColor);
      expect(copy.titleTextStyle, original.titleTextStyle);
    });

    test('copyWith replaces specific fields', () {
      final original = ACLightTitledTimeThemeData();
      final copy = original.copyWith(titleColor: Colors.brown);

      expect(copy.titleColor, Colors.brown);
    });

    test('lerp returns this when other is null', () {
      final a = ACLightTitledTimeThemeData(titleColor: const Color(0xFF000000));
      final result = a.lerp(null, 0.5);

      expect(result.titleColor, const Color(0xFF000000));
    });

    test('lerp interpolates Color fields at t=0.5', () {
      final a = ACLightTitledTimeThemeData(titleColor: const Color(0xFF000000));
      final b = ACLightTitledTimeThemeData(titleColor: const Color(0xFFFFFFFF));

      final result = a.lerp(b, 0.5);

      expect(result.titleColor,
          Color.lerp(const Color(0xFF000000), const Color(0xFFFFFFFF), 0.5));
    });
  });

  // ---------------------------------------------------------------------------
  // ACWheelPickerThemeData
  // ---------------------------------------------------------------------------
  group('ACWheelPickerThemeData', () {
    test('factory creates instance with default values', () {
      final theme = ACLightWheelPickerThemeData();

      expect(
          theme.itemTextColor, const Color(0xFF9A99A2).withValues(alpha: .4));
      expect(theme.selectedItemTextColor,
          const Color(0xFF232326).withValues(alpha: .7));
      expect(theme.itemTextStyle.fontWeight, FontWeight.w400);
      expect(theme.itemTextStyle.fontSize, 23);
    });

    test(
      'copyWith preserves values when called without arguments',
      () {
        final original = ACLightWheelPickerThemeData(
          itemTextColor: Colors.red,
          selectedItemTextColor: Colors.blue,
        );
        final copy = original.copyWith();

        expect(copy.itemTextColor, original.itemTextColor);
        expect(copy.selectedItemTextColor, original.selectedItemTextColor);
        expect(
            copy.itemTextStyle.fontWeight, original.itemTextStyle.fontWeight);
      },
    );

    test('copyWith replaces specific fields', () {
      final original = ACLightWheelPickerThemeData();
      final copy = original.copyWith(itemTextColor: Colors.lime);

      expect(copy.itemTextColor, Colors.lime);
    });

    test('lerp returns this when other is null', () {
      final a = ACLightWheelPickerThemeData(
        itemTextColor: const Color(0xFF000000),
      );
      final result = a.lerp(null, 0.5);

      expect(result.itemTextColor, const Color(0xFF000000));
    });

    test('lerp interpolates Color fields at t=0.5', () {
      final a = ACLightWheelPickerThemeData(
        itemTextColor: const Color(0xFF000000),
        selectedItemTextColor: const Color(0xFF000000),
      );
      final b = ACLightWheelPickerThemeData(
        itemTextColor: const Color(0xFFFFFFFF),
        selectedItemTextColor: const Color(0xFFFFFFFF),
      );

      final result = a.lerp(b, 0.5);

      final expected =
          Color.lerp(const Color(0xFF000000), const Color(0xFFFFFFFF), 0.5);
      expect(result.itemTextColor, expected);
      expect(result.selectedItemTextColor, expected);
    });
  });
}
