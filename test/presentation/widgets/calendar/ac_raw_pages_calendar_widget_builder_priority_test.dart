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
    Widget Function(BuildContext context, DateTime day)? dayBuilder,
    DateTime? initialMonth,
  }) =>
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 400,
            child: ACRawPagesCalendarWidget(
              range: range,
              initialMonth: initialMonth,
              monthBuilder: monthBuilder,
              dayBuilder: dayBuilder,
            ),
          ),
        ),
      );

  group('ACRawPagesCalendarWidget -- builder priority', () {
    testWidgets(
      'monthBuilder and dayBuilder passed together: '
      'monthBuilder is used, dayBuilder is ignored',
      (tester) async {
        // Arrange
        final initialMonth = DateTime(2024, 6);

        // Act
        await tester.pumpWidget(buildWidget(
          initialMonth: initialMonth,
          monthBuilder: (context, month) => Text(
            'custom-month-${month.month}',
            key: ValueKey('custom-month-${month.month}'),
          ),
          dayBuilder: (context, day) => Text(
            'custom-day-${day.day}',
            key: ValueKey('custom-day-${day.day}'),
          ),
        ));
        await tester.pumpAndSettle();

        // Assert -- the custom monthBuilder is rendered
        expect(
          find.byKey(const ValueKey('custom-month-6')),
          findsOneWidget,
        );
        expect(find.text('custom-month-6'), findsOneWidget);

        // Assert -- ACMonthWidget is absent (monthBuilder replaces it)
        expect(find.byType(ACMonthWidget), findsNothing);

        // Assert -- dayBuilder did not create any widgets
        // (because monthBuilder fully replaced the month)
        expect(find.textContaining('custom-day-'), findsNothing);
      },
    );

    testWidgets(
      'only dayBuilder passed: ACMonthWidget is present, '
      'dayBuilder is used inside',
      (tester) async {
        // Arrange
        final initialMonth = DateTime(2024, 6);

        // Act
        await tester.pumpWidget(buildWidget(
          initialMonth: initialMonth,
          dayBuilder: (context, day) => Text(
            'day-${day.day}',
            key: ValueKey('day-${day.day}'),
          ),
        ));
        await tester.pumpAndSettle();

        // Assert -- ACMonthWidget is present
        expect(find.byType(ACMonthWidget), findsOneWidget);

        // Assert -- dayBuilder is used inside ACMonthWidget
        expect(find.text('day-1'), findsWidgets);
      },
    );
  });
}
