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
    );
  });

  Widget buildWidget({
    ACCalendarThemeData? theme,
    DateTime? initialDate,
  }) =>
      MaterialApp(
        theme: ThemeData(extensions: [
          ACCalendarThemeExtension(data: theme ?? ACLightCalendarThemeData()),
        ]),
        home: Scaffold(
          body: SizedBox(
            width: 400,
            height: 600,
            child: ACCalendarWidget(
              range: range,
              theme: theme,
              initialDate: initialDate,
            ),
          ),
        ),
      );

  group('ACCalendarWidget -- проброс theme в ACRawCalendarWidget', () {
    testWidgets(
      'передаёт theme в ACRawCalendarWidget',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget(
          theme: customTheme,
          initialDate: DateTime(2024, 6),
        ));
        await tester.pumpAndSettle();

        // Assert
        final rawWidget = tester.widget<ACRawCalendarWidget>(
          find.byType(ACRawCalendarWidget),
        );
        expect(rawWidget.theme, equals(customTheme));
      },
    );

    testWidgets(
      'ACRawCalendarWidget получает null theme если theme не передан',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget(
          initialDate: DateTime(2024, 6),
        ));
        await tester.pumpAndSettle();

        // Assert
        final rawWidget = tester.widget<ACRawCalendarWidget>(
          find.byType(ACRawCalendarWidget),
        );
        expect(rawWidget.theme, isNull);
      },
    );

    testWidgets(
      'weekTheme из theme доходит до ACWeekWidget через ACRawCalendarWidget',
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
      'dayTheme из theme доходит до ACTitledMonthWidget через ACRawCalendarWidget',
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
}
