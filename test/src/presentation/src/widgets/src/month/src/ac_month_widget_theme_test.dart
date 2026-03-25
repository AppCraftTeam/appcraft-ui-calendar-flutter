import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // 42 дня для марта 2026 (6 недель x 7 дней),
  // начинаем с понедельника 23 февраля 2026.
  final days = List.generate(42, (i) => DateTime(2026, 2, 23 + i));
  final monthDate = DateTime(2026, 3);

  Widget buildWidget({
    ACDayThemeData? dayTheme,
  }) {
    return MaterialApp(
      theme: ThemeData(
        extensions: [
          ACCalendarThemeExtension(data: ACLightCalendarThemeData()),
        ],
      ),
      home: Scaffold(
        body: SizedBox(
          width: 400,
          height: 600,
          child: ACCalendarScope(
            dateRange: ACDateRange(
              min: DateTime(2026),
              max: DateTime(2026, 12, 31),
            ),
            child: ACMonthWidget(
              layout: ACDefaultMonthLayout(mainAxisCount: 6),
              days: days,
              monthDate: monthDate,
              dayTheme: dayTheme,
            ),
          ),
        ),
      ),
    );
  }

  group('ACMonthWidget -- dayTheme propagation (US2 T016)', () {
    testWidgets(
      'передаёт dayTheme в дочерние ACCalendarDayWidget',
      (tester) async {
        // Arrange
        final customDayTheme = ACLightDayThemeData(
          selectedBackgroundColor: Colors.red,
          middleSelectedBackgroundColor: Colors.pink,
          inactiveTextColor: Colors.grey,
          textColor: Colors.purple,
        );

        // Act
        await tester.pumpWidget(buildWidget(dayTheme: customDayTheme));

        // Assert
        final dayWidgets = tester
            .widgetList<ACCalendarDayWidget>(
              find.byType(ACCalendarDayWidget),
            )
            .toList();

        expect(dayWidgets, isNotEmpty);
        for (final dayWidget in dayWidgets) {
          expect(dayWidget.theme, same(customDayTheme));
        }
      },
    );

    testWidgets(
      'ACCalendarDayWidget получает null theme когда dayTheme не передан',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget());

        // Assert
        final dayWidgets = tester
            .widgetList<ACCalendarDayWidget>(
              find.byType(ACCalendarDayWidget),
            )
            .toList();

        expect(dayWidgets, isNotEmpty);
        for (final dayWidget in dayWidgets) {
          expect(dayWidget.theme, isNull);
        }
      },
    );

    testWidgets(
      'ACDayWidget внутри ACCalendarDayWidget получает переданную тему',
      (tester) async {
        // Arrange
        final customDayTheme = ACLightDayThemeData(
          textColor: Colors.deepOrange,
        );

        // Act
        await tester.pumpWidget(buildWidget(dayTheme: customDayTheme));

        // Assert -- ACDayWidget также получает тему через ACCalendarDayWidget
        final dayWidgets =
            tester.widgetList<ACDayWidget>(find.byType(ACDayWidget)).toList();

        expect(dayWidgets, isNotEmpty);
        for (final dayWidget in dayWidgets) {
          expect(dayWidget.theme, same(customDayTheme));
        }
      },
    );
  });
}
