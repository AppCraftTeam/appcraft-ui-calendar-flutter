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

  group('ACRawPagesCalendarWidget -- приоритет builder', () {
    testWidgets(
      'monthBuilder и dayBuilder переданы одновременно: '
      'monthBuilder используется, dayBuilder игнорируется',
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

        // Assert -- кастомный monthBuilder рендерится
        expect(
          find.byKey(const ValueKey('custom-month-6')),
          findsOneWidget,
        );
        expect(find.text('custom-month-6'), findsOneWidget);

        // Assert -- ACMonthWidget отсутствует (monthBuilder заменяет его)
        expect(find.byType(ACMonthWidget), findsNothing);

        // Assert -- dayBuilder не создал виджетов
        // (т.к. monthBuilder полностью заменил месяц)
        expect(find.textContaining('custom-day-'), findsNothing);
      },
    );

    testWidgets(
      'только dayBuilder передан: ACMonthWidget присутствует, '
      'dayBuilder используется внутри',
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

        // Assert -- ACMonthWidget присутствует
        expect(find.byType(ACMonthWidget), findsOneWidget);

        // Assert -- dayBuilder используется внутри ACMonthWidget
        expect(find.text('day-1'), findsWidgets);
      },
    );
  });
}
