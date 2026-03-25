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
            child: ACRawCalendarWidget(
              range: range,
              initialDate: DateTime(2026, 3, 15),
              monthBuilder: monthBuilder,
            ),
          ),
        ),
      );

  group('ACRawCalendarWidget -- monthBuilder', () {
    testWidgets(
      'с monthBuilder кастомный виджет рендерится, '
      'ACTitledMonthWidget отсутствует',
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
        expect(find.text('month-3'), findsAtLeast(1));
        expect(find.byType(ACTitledMonthWidget), findsNothing);
      },
    );

    testWidgets(
      'без monthBuilder используется ACTitledMonthWidget',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget());
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(ACTitledMonthWidget), findsWidgets);
      },
    );
  });
}
