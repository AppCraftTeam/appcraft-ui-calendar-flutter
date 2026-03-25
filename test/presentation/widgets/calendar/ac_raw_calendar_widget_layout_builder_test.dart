import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final range = ACDateRange(
    min: DateTime(2020),
    max: DateTime(2030),
  );

  Widget buildWidget({
    ACMonthLayout Function(BuildContext context, DateTime month)?
        monthLayoutBuilder,
  }) =>
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 400,
            height: 600,
            child: ACRawCalendarWidget(
              range: range,
              initialDate: DateTime(2026, 3, 15),
              monthLayoutBuilder: monthLayoutBuilder,
            ),
          ),
        ),
      );

  group('ACRawCalendarWidget -- monthLayoutBuilder', () {
    testWidgets(
      'с monthLayoutBuilder раскладка из коллбэка передаётся '
      'в ACTitledMonthWidget',
      (tester) async {
        // Arrange
        final layout = ACDefaultMonthLayout.mainAxisCount4;

        // Act
        await tester.pumpWidget(buildWidget(
          monthLayoutBuilder: (context, month) => layout,
        ));
        await tester.pumpAndSettle();

        // Assert
        final monthWidget = tester.widget<ACTitledMonthWidget>(
          find.byType(ACTitledMonthWidget).first,
        );
        expect(monthWidget.layout, equals(layout));
        expect(
          (monthWidget.layout as ACDefaultMonthLayout).mainAxisCount,
          equals(4),
        );
      },
    );

    testWidgets(
      'без monthLayoutBuilder ACTitledMonthWidget использует '
      'автоматическую раскладку',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget());
        await tester.pumpAndSettle();

        // Assert
        final monthWidget = tester.widget<ACTitledMonthWidget>(
          find.byType(ACTitledMonthWidget).first,
        );
        expect(monthWidget.layout, isA<ACDefaultMonthLayout>());
      },
    );
  });
}
