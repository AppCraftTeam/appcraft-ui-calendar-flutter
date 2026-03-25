import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final range = ACDateRange(
    min: DateTime(2020),
    max: DateTime(2030),
  );

  Widget buildWidget({
    Widget Function(BuildContext context, DateTime month)? monthBuilder,
  }) =>
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 400,
            height: 600,
            child: ACCalendarWidget(
              range: range,
              initialDate: DateTime(2026, 3, 15),
              monthBuilder: monthBuilder,
            ),
          ),
        ),
      );

  group('ACCalendarWidget -- monthBuilder', () {
    testWidgets(
      'с monthBuilder пробрасывает его в ACRawCalendarWidget',
      (tester) async {
        // Arrange
        Widget customMonthBuilder(BuildContext context, DateTime month) => Text(
              'month-${month.month}',
              key: ValueKey('month-${month.month}'),
            );

        // Act
        await tester.pumpWidget(buildWidget(monthBuilder: customMonthBuilder));
        await tester.pumpAndSettle();

        // Assert
        final rawWidget = tester.widget<ACRawCalendarWidget>(
          find.byType(ACRawCalendarWidget),
        );
        expect(rawWidget.monthBuilder, isNotNull);
        expect(find.text('month-3'), findsAtLeast(1));
      },
    );

    testWidgets(
      'без monthBuilder ACRawCalendarWidget получает monthBuilder == null',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget());
        await tester.pumpAndSettle();

        // Assert
        final rawWidget = tester.widget<ACRawCalendarWidget>(
          find.byType(ACRawCalendarWidget),
        );
        expect(rawWidget.monthBuilder, isNull);
        expect(find.byType(ACTitledMonthWidget), findsWidgets);
      },
    );
  });
}
