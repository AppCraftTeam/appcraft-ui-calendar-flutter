import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // 42 days for March 2026 (6 weeks x 7 days),
  // starting from Monday, February 23, 2026.
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
      'passes dayTheme to the child ACMonthWidget',
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
      'ACMonthWidget receives null dayTheme when not explicitly provided',
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
      'titledMonthTheme is taken from ThemeExtension when not explicitly provided',
      (tester) async {
        // Arrange
        final extensionTheme = ACLightCalendarThemeData(
          titledMonthTheme: ACLightTitledMonthThemeData(
            titleColor: Colors.orange,
          ),
        );

        // Act
        await tester.pumpWidget(buildWidget(extensionTheme: extensionTheme));

        // Assert -- title is rendered with color from ThemeExtension
        // First Text -- month title (Align > Text)
        final titleFinder = find.descendant(
          of: find.byType(Align),
          matching: find.byType(Text),
        );
        final textWidget = tester.widget<Text>(titleFinder.first);
        expect(textWidget.style?.color, Colors.orange);
      },
    );

    testWidgets(
      'titledMonthTheme from parameter has priority over ThemeExtension',
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
