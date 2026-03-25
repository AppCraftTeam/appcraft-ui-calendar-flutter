import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final range = ACDateRange(
    min: DateTime(2020),
    max: DateTime(2030),
  );

  group('ACCalendarWidget -- горячая замена theme', () {
    testWidgets(
      'ACWeekWidget обновляет theme при смене theme параметра',
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

        // Assert -- начальная тема
        final weekWidgetBefore =
            tester.widget<ACWeekWidget>(find.byType(ACWeekWidget));
        expect(weekWidgetBefore.theme, equals(theme1.weekTheme));

        // Act -- переключаем тему
        await tester.tap(find.text('switch'));
        await tester.pumpAndSettle();

        // Assert -- тема обновилась
        final weekWidgetAfter =
            tester.widget<ACWeekWidget>(find.byType(ACWeekWidget));
        expect(weekWidgetAfter.theme, equals(theme2.weekTheme));
      },
    );

    testWidgets(
      'ACWeekWidget обновляет theme при смене с theme на null',
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

        // Assert -- начальная тема задана
        final weekWidgetBefore =
            tester.widget<ACWeekWidget>(find.byType(ACWeekWidget));
        expect(weekWidgetBefore.theme, equals(theme1.weekTheme));

        // Act -- убираем тему
        await tester.tap(find.text('clear'));
        await tester.pumpAndSettle();

        // Assert -- тема стала null (fallback на ThemeExtension.of)
        final weekWidgetAfter =
            tester.widget<ACWeekWidget>(find.byType(ACWeekWidget));
        expect(weekWidgetAfter.theme, isNull);
      },
    );
  });
}
