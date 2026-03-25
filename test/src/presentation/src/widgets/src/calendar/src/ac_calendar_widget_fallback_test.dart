import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final range = ACDateRange(
    min: DateTime(2020),
    max: DateTime(2030),
  );

  group('ACCalendarWidget -- theme передан, ThemeExtension тоже задан', () {
    testWidgets(
      'использует weekTheme из переданного theme, а не из ThemeExtension',
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
      'использует default weekTheme из переданного theme, не из ThemeExtension',
      (tester) async {
        // Arrange -- theme без явного weekTheme (используется default)
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

        // Assert -- weekTheme из widgetTheme (default), не из extensionTheme
        final weekWidget =
            tester.widget<ACWeekWidget>(find.byType(ACWeekWidget));
        expect(weekWidget.theme, equals(widgetTheme.weekTheme));
        expect(weekWidget.theme?.textColor, isNot(Colors.purple));
      },
    );
  });
}
