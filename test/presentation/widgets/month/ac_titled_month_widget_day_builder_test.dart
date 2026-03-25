import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final monthDate = DateTime(2026, 3);

  List<DateTime> generateDays(DateTime month) {
    var date = DateTime(month.year, month.month, 1);
    while (date.weekday != DateTime.monday) {
      date = date.subtract(const Duration(days: 1));
    }
    return List.generate(42, (i) => date.add(Duration(days: i)));
  }

  final days = generateDays(monthDate);

  Widget buildWidget({
    Widget Function(BuildContext context, DateTime day)? dayBuilder,
  }) =>
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 400,
            height: 600,
            child: ACCalendarScope(
              dateRange: ACDateRange(
                min: DateTime(2020),
                max: DateTime(2030),
              ),
              child: ACTitledMonthWidget(
                layout: ACDefaultMonthLayout.mainAxisCount6,
                days: days,
                monthDate: monthDate,
                dayBuilder: dayBuilder,
              ),
            ),
          ),
        ),
      );

  group('ACTitledMonthWidget -- dayBuilder', () {
    testWidgets(
      'с dayBuilder рендерит кастомный виджет вместо ACCalendarDayWidget',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget(
          dayBuilder: (context, day) => Text(
            'custom-${day.day}',
            key: ValueKey('day-${day.day}'),
          ),
        ));

        // Assert
        expect(find.text('custom-15'), findsOneWidget);
        expect(find.byType(ACCalendarDayWidget), findsNothing);
      },
    );

    testWidgets(
      'без dayBuilder рендерит ACCalendarDayWidget',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget());

        // Assert
        expect(find.byType(ACCalendarDayWidget), findsWidgets);
      },
    );
  });
}
