import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ACCalendarThemeExtension пользовательская тема', () {
    testWidgets(
      'кастомные цвета sub-themes не перезаписываются дефолтами',
      (tester) async {
        const customWeekTextColor = Color(0xFF112233);
        const customDayInactiveColor = Color(0xFF445566);
        const customHintColor = Color(0xFF778899);
        const customItemTextColor = Color(0xFFAABBCC);

        final customTheme = ACLightCalendarThemeData(
          weekTheme: ACLightWeekThemeData(textColor: customWeekTextColor),
          dayTheme:
              ACLightDayThemeData(inactiveTextColor: customDayInactiveColor),
          timeInputTheme: ACLightTimeInputThemeData(hintColor: customHintColor),
          wheelPickerTheme:
              ACLightWheelPickerThemeData(itemTextColor: customItemTextColor),
        );

        late ACCalendarThemeData resolvedTheme;

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              extensions: [ACCalendarThemeExtension(data: customTheme)],
            ),
            home: Builder(
              builder: (context) {
                resolvedTheme = ACCalendarThemeExtension.of(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(resolvedTheme.weekTheme.textColor, equals(customWeekTextColor));
        expect(
          resolvedTheme.dayTheme.inactiveTextColor,
          equals(customDayInactiveColor),
        );
        expect(
          resolvedTheme.timeInputTheme.hintColor,
          equals(customHintColor),
        );
        expect(
          resolvedTheme.wheelPickerTheme.itemTextColor,
          equals(customItemTextColor),
        );
      },
    );

    testWidgets(
      'of() возвращает дефолтную тему если расширение не задано',
      (tester) async {
        late ACCalendarThemeData resolvedTheme;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                resolvedTheme = ACCalendarThemeExtension.of(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        final defaultTheme = ACLightCalendarThemeData();

        expect(
          resolvedTheme.weekTheme.textColor,
          equals(defaultTheme.weekTheme.textColor),
        );
        expect(
          resolvedTheme.dayTheme.inactiveTextColor,
          equals(defaultTheme.dayTheme.inactiveTextColor),
        );
      },
    );
  });
}
