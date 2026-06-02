import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final range = ACDateRange(
    min: DateTime(2024),
    max: DateTime(2025, 12),
  );

  late ACLightCalendarThemeData customTheme;

  setUp(() {
    customTheme = ACLightCalendarThemeData(
      weekTheme: ACLightWeekThemeData(
        textColor: const Color(0xFF112233),
      ),
      dayTheme: ACLightDayThemeData(
        textColor: const Color(0xFF445566),
      ),
      titledMonthTheme: ACLightTitledMonthThemeData(
        titleColor: const Color(0xFF778899),
      ),
    );
  });

  Widget buildWidget({
    ACCalendarThemeData? theme,
    DateTime? initialDate,
  }) =>
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 400,
            height: 600,
            child: ACCalendarScope(
              dateRange: range,
              child: ACRawCalendarWidget(
                range: range,
                initialDate: initialDate,
                theme: theme,
              ),
            ),
          ),
        ),
      );

  group('ACRawCalendarWidget -- forwarding weekTheme', () {
    testWidgets(
      'forwards weekTheme from theme to ACWeekWidget',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget(
          theme: customTheme,
          initialDate: DateTime(2024, 6),
        ));
        await tester.pumpAndSettle();

        // Assert
        final weekWidget = tester.widget<ACWeekWidget>(
          find.byType(ACWeekWidget),
        );
        expect(weekWidget.theme, equals(customTheme.weekTheme));
      },
    );

    testWidgets(
      'ACWeekWidget receives null theme when theme is not provided',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget(
          initialDate: DateTime(2024, 6),
        ));
        await tester.pumpAndSettle();

        // Assert
        final weekWidget = tester.widget<ACWeekWidget>(
          find.byType(ACWeekWidget),
        );
        expect(weekWidget.theme, isNull);
      },
    );
  });

  group('ACRawCalendarWidget -- forwarding dayTheme', () {
    testWidgets(
      'forwards dayTheme from theme to ACTitledMonthWidget',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget(
          theme: customTheme,
          initialDate: DateTime(2024, 6),
        ));
        await tester.pumpAndSettle();

        // Assert
        final titledMonthWidget = tester.widget<ACTitledMonthWidget>(
          find.byType(ACTitledMonthWidget).first,
        );
        expect(titledMonthWidget.dayTheme, equals(customTheme.dayTheme));
      },
    );
  });

  group('ACRawCalendarWidget -- forwarding titledMonthTheme', () {
    testWidgets(
      'forwards titledMonthTheme from theme to ACTitledMonthWidget',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget(
          theme: customTheme,
          initialDate: DateTime(2024, 6),
        ));
        await tester.pumpAndSettle();

        // Assert
        final titledMonthWidget = tester.widget<ACTitledMonthWidget>(
          find.byType(ACTitledMonthWidget).first,
        );
        expect(
          titledMonthWidget.theme,
          equals(customTheme.titledMonthTheme),
        );
      },
    );

    testWidgets(
      'ACTitledMonthWidget receives null theme when theme is not provided',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget(
          initialDate: DateTime(2024, 6),
        ));
        await tester.pumpAndSettle();

        // Assert
        final titledMonthWidget = tester.widget<ACTitledMonthWidget>(
          find.byType(ACTitledMonthWidget).first,
        );
        expect(titledMonthWidget.theme, isNull);
        expect(titledMonthWidget.dayTheme, isNull);
      },
    );
  });
}
