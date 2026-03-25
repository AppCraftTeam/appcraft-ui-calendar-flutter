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

  group('ACRawCalendarWidget -- проброс weekTheme', () {
    testWidgets(
      'передаёт weekTheme из theme в ACWeekWidget',
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
      'ACWeekWidget получает null theme если theme не передан',
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

  group('ACRawCalendarWidget -- проброс dayTheme', () {
    testWidgets(
      'передаёт dayTheme из theme в ACTitledMonthWidget',
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

  group('ACRawCalendarWidget -- проброс titledMonthTheme', () {
    testWidgets(
      'передаёт titledMonthTheme из theme в ACTitledMonthWidget',
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
      'ACTitledMonthWidget получает null theme если theme не передан',
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
