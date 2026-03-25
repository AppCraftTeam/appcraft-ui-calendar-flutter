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
            child: ACCalendarWidget(
              range: range,
              initialDate: DateTime(2026, 3, 15),
              monthLayoutBuilder: monthLayoutBuilder,
            ),
          ),
        ),
      );

  group('ACCalendarWidget -- monthLayoutBuilder', () {
    testWidgets(
      'с monthLayoutBuilder пробрасывает его в ACRawCalendarWidget',
      (tester) async {
        // Arrange
        ACMonthLayout layoutBuilder(BuildContext context, DateTime month) =>
            ACDefaultMonthLayout.mainAxisCount4;

        // Act
        await tester.pumpWidget(
          buildWidget(monthLayoutBuilder: layoutBuilder),
        );
        await tester.pumpAndSettle();

        // Assert
        final rawWidget = tester.widget<ACRawCalendarWidget>(
          find.byType(ACRawCalendarWidget),
        );
        expect(rawWidget.monthLayoutBuilder, isNotNull);
      },
    );

    testWidgets(
      'без monthLayoutBuilder ACRawCalendarWidget получает '
      'monthLayoutBuilder == null',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget());
        await tester.pumpAndSettle();

        // Assert
        final rawWidget = tester.widget<ACRawCalendarWidget>(
          find.byType(ACRawCalendarWidget),
        );
        expect(rawWidget.monthLayoutBuilder, isNull);
      },
    );
  });
}
