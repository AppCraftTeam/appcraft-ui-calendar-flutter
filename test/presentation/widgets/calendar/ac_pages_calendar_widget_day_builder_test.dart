import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final range = ACDateRange(
    min: DateTime(2020),
    max: DateTime(2030),
  );

  Widget buildWidget({
    Widget Function(BuildContext context, DateTime day)? dayBuilder,
  }) =>
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 400,
            child: ACPagesCalendarWidget(
              range: range,
              initialMonth: DateTime(2026, 3),
              dayBuilder: dayBuilder,
            ),
          ),
        ),
      );

  group('ACPagesCalendarWidget -- dayBuilder', () {
    testWidgets(
      'with dayBuilder forwards it to ACRawPagesCalendarWidget',
      (tester) async {
        // Arrange
        Widget customDayBuilder(BuildContext context, DateTime day) => Text(
              'custom-${day.day}',
              key: ValueKey('day-${day.day}'),
            );

        // Act
        await tester.pumpWidget(buildWidget(dayBuilder: customDayBuilder));
        await tester.pumpAndSettle();

        // Assert
        final rawWidget = tester.widget<ACRawPagesCalendarWidget>(
          find.byType(ACRawPagesCalendarWidget),
        );
        expect(rawWidget.dayBuilder, isNotNull);
        expect(find.text('custom-15'), findsOneWidget);
      },
    );

    testWidgets(
      'without dayBuilder ACRawPagesCalendarWidget receives dayBuilder == null',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget());
        await tester.pumpAndSettle();

        // Assert
        final rawWidget = tester.widget<ACRawPagesCalendarWidget>(
          find.byType(ACRawPagesCalendarWidget),
        );
        expect(rawWidget.dayBuilder, isNull);
        expect(find.byType(ACCalendarDayWidget), findsWidgets);
      },
    );
  });
}
