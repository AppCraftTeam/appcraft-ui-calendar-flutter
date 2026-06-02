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
        theme: ThemeData(extensions: [
          ACCalendarThemeExtension(data: theme ?? ACLightCalendarThemeData()),
        ]),
        home: ACCalendarScreen(
          range: range,
          theme: theme,
          initialDate: initialDate,
        ),
      );

  group('ACCalendarScreen -- forwarding theme to ACRawCalendarWidget', () {
    testWidgets(
      'forwards theme to ACRawCalendarWidget',
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
      'ACRawCalendarWidget receives null theme when theme is not provided',
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
      'weekTheme from theme reaches ACWeekWidget through ACRawCalendarWidget',
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
      'dayTheme from theme reaches ACTitledMonthWidget',
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

    testWidgets(
      'titledMonthTheme from theme reaches ACTitledMonthWidget',
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
  });
}
