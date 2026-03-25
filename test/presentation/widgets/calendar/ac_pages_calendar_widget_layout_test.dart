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
    double? monthHeight,
    DateTime? initialMonth,
  }) =>
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 400,
            child: ACPagesCalendarWidget(
              range: range,
              initialMonth: initialMonth,
              monthLayout: monthLayout,
              monthHeight: monthHeight,
            ),
          ),
        ),
      );

  group('ACPagesCalendarWidget -- monthLayout и monthHeight', () {
    testWidgets(
      'с monthLayout пробрасывает в ACRawPagesCalendarWidget',
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
        final rawWidget = tester.widget<ACRawPagesCalendarWidget>(
          find.byType(ACRawPagesCalendarWidget),
        );
        expect(rawWidget.monthLayout, equals(layout));
      },
    );

    testWidgets(
      'с monthHeight пробрасывает в ACRawPagesCalendarWidget',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget(
          initialMonth: DateTime(2024, 6),
          monthHeight: 250,
        ));
        await tester.pumpAndSettle();

        // Assert
        final rawWidget = tester.widget<ACRawPagesCalendarWidget>(
          find.byType(ACRawPagesCalendarWidget),
        );
        expect(rawWidget.monthHeight, equals(250));
      },
    );

    testWidgets(
      'с monthLayout и monthHeight оба пробрасываются '
      'в ACRawPagesCalendarWidget',
      (tester) async {
        // Arrange
        final layout = ACDefaultMonthLayout.mainAxisCount5;

        // Act
        await tester.pumpWidget(buildWidget(
          initialMonth: DateTime(2024, 6),
          monthLayout: layout,
          monthHeight: 350,
        ));
        await tester.pumpAndSettle();

        // Assert
        final rawWidget = tester.widget<ACRawPagesCalendarWidget>(
          find.byType(ACRawPagesCalendarWidget),
        );
        expect(rawWidget.monthLayout, equals(layout));
        expect(rawWidget.monthHeight, equals(350));
      },
    );

    testWidgets(
      'без monthLayout и monthHeight оба null '
      'в ACRawPagesCalendarWidget',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget(
          initialMonth: DateTime(2024, 6),
        ));
        await tester.pumpAndSettle();

        // Assert
        final rawWidget = tester.widget<ACRawPagesCalendarWidget>(
          find.byType(ACRawPagesCalendarWidget),
        );
        expect(rawWidget.monthLayout, isNull);
        expect(rawWidget.monthHeight, isNull);
      },
    );
  });
}
