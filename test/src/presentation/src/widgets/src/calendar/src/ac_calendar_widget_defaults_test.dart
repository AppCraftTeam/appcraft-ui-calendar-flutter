import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final range = ACDateRange(
    min: DateTime(2020),
    max: DateTime(2030),
  );

  group('ACCalendarWidget -- without theme and without ThemeExtension', () {
    testWidgets(
      'renders without errors when theme and ThemeExtension are absent',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 400,
                height: 600,
                child: ACCalendarWidget(range: range),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(ACCalendarWidget), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'ACWeekWidget receives null theme and uses fallback from ThemeExtension.of',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 400,
                height: 600,
                child: ACCalendarWidget(range: range),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Assert -- ACWeekWidget.theme is null (fallback via ACCalendarThemeExtension.of)
        final weekWidget =
            tester.widget<ACWeekWidget>(find.byType(ACWeekWidget));
        expect(weekWidget.theme, isNull);
      },
    );

    testWidgets(
      'displays the weekday row with default values',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 400,
                height: 600,
                child: ACCalendarWidget(range: range),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(ACWeekWidget), findsOneWidget);
      },
    );
  });
}
