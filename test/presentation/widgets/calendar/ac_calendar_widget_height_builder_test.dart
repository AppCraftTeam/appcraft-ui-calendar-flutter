import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final range = ACDateRange(
    min: DateTime(2020),
    max: DateTime(2030),
  );

  Widget buildWidget({
    double Function(BuildContext context, DateTime month)? monthHeightBuilder,
  }) =>
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 400,
            height: 600,
            child: ACCalendarWidget(
              range: range,
              initialDate: DateTime(2026, 3, 15),
              monthHeightBuilder: monthHeightBuilder,
            ),
          ),
        ),
      );

  group('ACCalendarWidget -- monthHeightBuilder', () {
    testWidgets(
      'с monthHeightBuilder пробрасывает его в ACRawCalendarWidget',
      (tester) async {
        // Arrange
        double heightBuilder(BuildContext context, DateTime month) => 300;

        // Act
        await tester.pumpWidget(
          buildWidget(monthHeightBuilder: heightBuilder),
        );
        await tester.pumpAndSettle();

        // Assert
        final rawWidget = tester.widget<ACRawCalendarWidget>(
          find.byType(ACRawCalendarWidget),
        );
        expect(rawWidget.monthHeightBuilder, isNotNull);
      },
    );

    testWidgets(
      'без monthHeightBuilder ACRawCalendarWidget получает '
      'monthHeightBuilder == null',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget());
        await tester.pumpAndSettle();

        // Assert
        final rawWidget = tester.widget<ACRawCalendarWidget>(
          find.byType(ACRawCalendarWidget),
        );
        expect(rawWidget.monthHeightBuilder, isNull);
      },
    );
  });
}
