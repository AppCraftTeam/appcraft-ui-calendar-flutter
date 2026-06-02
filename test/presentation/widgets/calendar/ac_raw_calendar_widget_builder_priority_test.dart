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
    Widget Function(BuildContext context, DateTime day)? dayBuilder,
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
              dayBuilder: dayBuilder,
            ),
          ),
        ),
      );

  group('ACRawCalendarWidget -- builder priority', () {
    testWidgets(
      'monthBuilder and dayBuilder passed together: '
      'monthBuilder is used, dayBuilder is ignored',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget(
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
          find.byKey(const ValueKey('custom-month-3')),
          findsAtLeast(1),
        );
        expect(find.text('custom-month-3'), findsAtLeast(1));

        // Assert -- ACTitledMonthWidget is absent (monthBuilder replaces it)
        expect(find.byType(ACTitledMonthWidget), findsNothing);

        // Assert -- dayBuilder did not create any widgets
        expect(find.textContaining('custom-day-'), findsNothing);
      },
    );

    testWidgets(
      'only dayBuilder passed: ACTitledMonthWidget is present, '
      'dayBuilder is used inside',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget(
          dayBuilder: (context, day) => Text(
            'day-${day.day}',
            key: ValueKey('day-${day.day}'),
          ),
        ));
        await tester.pumpAndSettle();

        // Assert -- ACTitledMonthWidget is present
        expect(find.byType(ACTitledMonthWidget), findsWidgets);

        // Assert -- dayBuilder is used inside ACTitledMonthWidget
        expect(find.text('day-1'), findsWidgets);
      },
    );
  });
}
