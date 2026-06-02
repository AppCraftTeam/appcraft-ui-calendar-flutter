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

  group('ACRawPagesCalendarWidget -- monthBuilder', () {
    testWidgets(
      'with monthBuilder the month widget is built via builder, '
      'ACMonthWidget is absent',
      (tester) async {
        // Arrange
        final initialMonth = DateTime(2024, 6);

        // Act
        await tester.pumpWidget(buildWidget(
          initialMonth: initialMonth,
          monthBuilder: (context, month) => Text(
            'month-${month.month}',
            key: ValueKey('month-${month.month}'),
          ),
        ));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byKey(const ValueKey('month-6')), findsOneWidget);
        expect(find.text('month-6'), findsOneWidget);
        expect(find.byType(ACMonthWidget), findsNothing);
      },
    );

    testWidgets(
      'without monthBuilder ACMonthWidget is used',
      (tester) async {
        // Arrange
        final initialMonth = DateTime(2024, 6);

        // Act
        await tester.pumpWidget(buildWidget(initialMonth: initialMonth));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(ACMonthWidget), findsOneWidget);
      },
    );
  });
}
