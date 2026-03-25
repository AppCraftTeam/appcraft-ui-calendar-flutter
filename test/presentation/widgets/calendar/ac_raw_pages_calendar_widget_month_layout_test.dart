import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final range = ACDateRange(
    min: DateTime(2024),
    max: DateTime(2025, 12),
  );

  Widget buildWidget({
    ACMonthLayout? monthLayout,
    DateTime? initialMonth,
  }) =>
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 400,
            child: ACRawPagesCalendarWidget(
              range: range,
              initialMonth: initialMonth,
              monthLayout: monthLayout,
            ),
          ),
        ),
      );

  group('ACRawPagesCalendarWidget -- monthLayout', () {
    testWidgets(
      'с monthLayout mainAxisCount4 ACMonthWidget получает эту раскладку',
      (tester) async {
        // Arrange
        final layout = ACDefaultMonthLayout.mainAxisCount4;

        // Act
        await tester.pumpWidget(buildWidget(
          initialMonth: DateTime(2024, 6),
          monthLayout: layout,
        ));
        await tester.pumpAndSettle();

        // Assert
        final monthWidget = tester.widget<ACMonthWidget>(
          find.byType(ACMonthWidget),
        );
        expect(monthWidget.layout, equals(layout));
      },
    );

    testWidgets(
      'без monthLayout ACMonthWidget использует дефолтную раскладку '
      'mainAxisCount6',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget(
          initialMonth: DateTime(2024, 6),
        ));
        await tester.pumpAndSettle();

        // Assert
        final monthWidget = tester.widget<ACMonthWidget>(
          find.byType(ACMonthWidget),
        );
        final layout = monthWidget.layout;
        expect(layout, isA<ACDefaultMonthLayout>());
        expect(
          (layout as ACDefaultMonthLayout).mainAxisCount,
          equals(6),
        );
      },
    );
  });
}
