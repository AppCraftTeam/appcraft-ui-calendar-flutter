import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final range = ACDateRange(
    min: DateTime(2024),
    max: DateTime(2025, 12),
  );

  Widget buildWidget({
    Widget Function(BuildContext context, DateTime month)? monthBuilder,
    DateTime? initialMonth,
  }) =>
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 400,
            child: ACPagesCalendarWidget(
              range: range,
              initialMonth: initialMonth,
              monthBuilder: monthBuilder,
            ),
          ),
        ),
      );

  group('ACPagesCalendarWidget -- monthBuilder', () {
    testWidgets(
      'with monthBuilder forwards the builder to ACRawPagesCalendarWidget',
      (tester) async {
        // Arrange
        Widget monthBuilder(BuildContext context, DateTime month) =>
            Text('month-${month.month}');

        // Act
        await tester.pumpWidget(buildWidget(
          initialMonth: DateTime(2024, 6),
          monthBuilder: monthBuilder,
        ));
        await tester.pumpAndSettle();

        // Assert
        final rawWidget = tester.widget<ACRawPagesCalendarWidget>(
          find.byType(ACRawPagesCalendarWidget),
        );
        expect(rawWidget.monthBuilder, isNotNull);
      },
    );

    testWidgets(
      'without monthBuilder ACRawPagesCalendarWidget.monthBuilder is null',
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
        expect(rawWidget.monthBuilder, isNull);
      },
    );
  });
}
