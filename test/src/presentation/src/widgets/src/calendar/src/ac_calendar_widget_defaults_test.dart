import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final range = ACDateRange(
    min: DateTime(2020),
    max: DateTime(2030),
  );

  group('ACCalendarWidget -- без theme и без ThemeExtension', () {
    testWidgets(
      'рендерится без ошибок при отсутствии theme и ThemeExtension',
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
      'ACWeekWidget получает null theme и использует fallback из ThemeExtension.of',
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

        // Assert -- ACWeekWidget.theme равен null (fallback через ACCalendarThemeExtension.of)
        final weekWidget =
            tester.widget<ACWeekWidget>(find.byType(ACWeekWidget));
        expect(weekWidget.theme, isNull);
      },
    );

    testWidgets(
      'отображает строку дней недели с дефолтными значениями',
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
