import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final range = ACDateRange(
    min: DateTime(2020),
    max: DateTime(2030),
  );

  group('ACCalendarWidget -- hot theme swap', () {
    testWidgets(
      'ACWeekWidget updates theme when theme parameter changes',
      (tester) async {
        // Arrange
        final theme1 = ACLightCalendarThemeData(
          weekTheme: ACLightWeekThemeData(textColor: Colors.red),
        );
        final theme2 = ACLightCalendarThemeData(
          weekTheme: ACLightWeekThemeData(textColor: Colors.blue),
        );

        ACCalendarThemeData? currentTheme = theme1;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 400,
                height: 600,
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return Column(
                      children: [
                        Expanded(
                          child: ACCalendarWidget(
                            range: range,
                            theme: currentTheme,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              currentTheme = theme2;
                            });
                          },
                          child: const Text('switch'),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Assert -- initial theme
        final weekWidgetBefore =
            tester.widget<ACWeekWidget>(find.byType(ACWeekWidget));
        expect(weekWidgetBefore.theme, equals(theme1.weekTheme));

        // Act -- switch the theme
        await tester.tap(find.text('switch'));
        await tester.pumpAndSettle();

        // Assert -- theme updated
        final weekWidgetAfter =
            tester.widget<ACWeekWidget>(find.byType(ACWeekWidget));
        expect(weekWidgetAfter.theme, equals(theme2.weekTheme));
      },
    );

    testWidgets(
      'ACWeekWidget updates theme when switching from theme to null',
      (tester) async {
        // Arrange
        final theme1 = ACLightCalendarThemeData(
          weekTheme: ACLightWeekThemeData(textColor: Colors.red),
        );

        ACCalendarThemeData? currentTheme = theme1;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 400,
                height: 600,
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return Column(
                      children: [
                        Expanded(
                          child: ACCalendarWidget(
                            range: range,
                            theme: currentTheme,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              currentTheme = null;
                            });
                          },
                          child: const Text('clear'),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Assert -- initial theme is set
        final weekWidgetBefore =
            tester.widget<ACWeekWidget>(find.byType(ACWeekWidget));
        expect(weekWidgetBefore.theme, equals(theme1.weekTheme));

        // Act -- remove the theme
        await tester.tap(find.text('clear'));
        await tester.pumpAndSettle();

        // Assert -- theme became null (fallback to ThemeExtension.of)
        final weekWidgetAfter =
            tester.widget<ACWeekWidget>(find.byType(ACWeekWidget));
        expect(weekWidgetAfter.theme, isNull);
      },
    );
  });
}
