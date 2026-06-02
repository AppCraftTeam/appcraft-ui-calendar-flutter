import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final range = ACDateRange(
    min: DateTime(2020),
    max: DateTime(2030),
  );

  group('ACCalendarWidget -- theme provided, ThemeExtension also set', () {
    testWidgets(
      'uses weekTheme from provided theme instead of ThemeExtension',
      (tester) async {
        // Arrange
        final widgetTheme = ACLightCalendarThemeData(
          weekTheme: ACLightWeekThemeData(textColor: Colors.red),
        );
        final extensionTheme = ACLightCalendarThemeData(
          weekTheme: ACLightWeekThemeData(textColor: Colors.green),
        );

        // Act
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              extensions: [ACCalendarThemeExtension(data: extensionTheme)],
            ),
            home: Scaffold(
              body: SizedBox(
                width: 400,
                height: 600,
                child: ACCalendarWidget(
                  range: range,
                  theme: widgetTheme,
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Assert
        final weekWidget =
            tester.widget<ACWeekWidget>(find.byType(ACWeekWidget));
        expect(weekWidget.theme, equals(widgetTheme.weekTheme));
      },
    );

    testWidgets(
      'uses default weekTheme from provided theme, not from ThemeExtension',
      (tester) async {
        // Arrange -- theme without explicit weekTheme (default is used)
        final widgetTheme = ACLightCalendarThemeData();
        final extensionTheme = ACLightCalendarThemeData(
          weekTheme: ACLightWeekThemeData(textColor: Colors.purple),
        );

        // Act
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              extensions: [ACCalendarThemeExtension(data: extensionTheme)],
            ),
            home: Scaffold(
              body: SizedBox(
                width: 400,
                height: 600,
                child: ACCalendarWidget(
                  range: range,
                  theme: widgetTheme,
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Assert -- weekTheme from widgetTheme (default), not from extensionTheme
        final weekWidget =
            tester.widget<ACWeekWidget>(find.byType(ACWeekWidget));
        expect(weekWidget.theme, equals(widgetTheme.weekTheme));
        expect(weekWidget.theme?.textColor, isNot(Colors.purple));
      },
    );
  });
}
