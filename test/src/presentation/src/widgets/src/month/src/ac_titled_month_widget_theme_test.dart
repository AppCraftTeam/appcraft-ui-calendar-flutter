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
    ACTitledMonthThemeData? titledMonthTheme,
    ACCalendarThemeData? extensionTheme,
  }) {
    return MaterialApp(
      theme: ThemeData(
        extensions: [
          ACCalendarThemeExtension(
            data: extensionTheme ?? ACLightCalendarThemeData(),
          ),
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
            child: ACTitledMonthWidget(
              layout: ACDefaultMonthLayout(mainAxisCount: 6),
              days: days,
              monthDate: monthDate,
              dayTheme: dayTheme,
              theme: titledMonthTheme,
            ),
          ),
        ),
      ),
    );
  }

  group('ACTitledMonthWidget -- dayTheme propagation (US2 T015)', () {
    testWidgets(
      'передаёт dayTheme в дочерний ACMonthWidget',
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
        final monthWidget =
            tester.widget<ACMonthWidget>(find.byType(ACMonthWidget));
        expect(monthWidget.dayTheme, same(customDayTheme));
      },
    );

    testWidgets(
      'ACMonthWidget получает null dayTheme когда не передан явно',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget());

        // Assert
        final monthWidget =
            tester.widget<ACMonthWidget>(find.byType(ACMonthWidget));
        expect(monthWidget.dayTheme, isNull);
      },
    );

    testWidgets(
      'titledMonthTheme берётся из ThemeExtension если не передана явно',
      (tester) async {
        // Arrange
        final extensionTheme = ACLightCalendarThemeData(
          titledMonthTheme: ACLightTitledMonthThemeData(
            titleColor: Colors.orange,
          ),
        );

        // Act
        await tester.pumpWidget(buildWidget(extensionTheme: extensionTheme));

        // Assert -- заголовок отображается с цветом из ThemeExtension
        // Первый Text -- заголовок месяца (Align > Text)
        final titleFinder = find.descendant(
          of: find.byType(Align),
          matching: find.byType(Text),
        );
        final textWidget = tester.widget<Text>(titleFinder.first);
        expect(textWidget.style?.color, Colors.orange);
      },
    );

    testWidgets(
      'titledMonthTheme из параметра имеет приоритет над ThemeExtension',
      (tester) async {
        // Arrange
        final extensionTheme = ACLightCalendarThemeData(
          titledMonthTheme: ACLightTitledMonthThemeData(
            titleColor: Colors.orange,
          ),
        );
        final paramTheme = ACLightTitledMonthThemeData(
          titleColor: Colors.cyan,
        );

        // Act
        await tester.pumpWidget(buildWidget(
          extensionTheme: extensionTheme,
          titledMonthTheme: paramTheme,
        ));

        // Assert
        final titleFinder = find.descendant(
          of: find.byType(Align),
          matching: find.byType(Text),
        );
        final textWidget = tester.widget<Text>(titleFinder.first);
        expect(textWidget.style?.color, Colors.cyan);
      },
    );
  });
}
