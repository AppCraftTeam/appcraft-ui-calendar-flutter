import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final range = ACDateRange(
    min: DateTime(2026),
    max: DateTime(2026, 12, 31),
  );

  Widget buildWidget({
    required ACCalendarThemeData globalTheme,
    required ACCalendarThemeData localTheme,
  }) {
    return MaterialApp(
      theme: ThemeData(
        extensions: [
          ACCalendarThemeExtension(data: globalTheme),
        ],
      ),
      home: Scaffold(
        body: SizedBox(
          width: 400,
          height: 600,
          child: ACCalendarWidget(
            range: range,
            theme: localTheme,
            initialDate: DateTime(2026, 3),
          ),
        ),
      ),
    );
  }

  group('ACCalendarWidget -- приоритет параметра над ThemeExtension (US3 T018)',
      () {
    testWidgets(
      'weekTheme из параметра theme используется вместо ThemeExtension',
      (tester) async {
        // Arrange
        final globalWeekTheme = ACLightWeekThemeData(
          textColor: Colors.blue,
        );
        final localWeekTheme = ACLightWeekThemeData(
          textColor: Colors.red,
        );

        final globalTheme = ACLightCalendarThemeData(
          weekTheme: globalWeekTheme,
        );
        final localTheme = ACLightCalendarThemeData(
          weekTheme: localWeekTheme,
        );

        // Act
        await tester.pumpWidget(buildWidget(
          globalTheme: globalTheme,
          localTheme: localTheme,
        ));
        await tester.pumpAndSettle();

        // Assert -- ACWeekWidget должен получить weekTheme из localTheme
        final weekWidget =
            tester.widget<ACWeekWidget>(find.byType(ACWeekWidget));
        expect(weekWidget.theme, same(localWeekTheme));
      },
    );

    testWidgets(
      'dayTheme из параметра theme используется вместо ThemeExtension',
      (tester) async {
        // Arrange
        final globalDayTheme = ACLightDayThemeData(
          textColor: Colors.blue,
        );
        final localDayTheme = ACLightDayThemeData(
          textColor: Colors.red,
        );

        final globalTheme = ACLightCalendarThemeData(
          dayTheme: globalDayTheme,
        );
        final localTheme = ACLightCalendarThemeData(
          dayTheme: localDayTheme,
        );

        // Act
        await tester.pumpWidget(buildWidget(
          globalTheme: globalTheme,
          localTheme: localTheme,
        ));
        await tester.pumpAndSettle();

        // Assert -- ACTitledMonthWidget должен получить dayTheme из localTheme
        final titledMonthWidgets = tester
            .widgetList<ACTitledMonthWidget>(
              find.byType(ACTitledMonthWidget),
            )
            .toList();

        expect(titledMonthWidgets, isNotEmpty);
        for (final widget in titledMonthWidgets) {
          expect(widget.dayTheme, same(localDayTheme));
        }
      },
    );

    testWidgets(
      'titledMonthTheme из параметра theme используется вместо ThemeExtension',
      (tester) async {
        // Arrange
        final globalTitledMonthTheme = ACLightTitledMonthThemeData(
          titleColor: Colors.blue,
        );
        final localTitledMonthTheme = ACLightTitledMonthThemeData(
          titleColor: Colors.red,
        );

        final globalTheme = ACLightCalendarThemeData(
          titledMonthTheme: globalTitledMonthTheme,
        );
        final localTheme = ACLightCalendarThemeData(
          titledMonthTheme: localTitledMonthTheme,
        );

        // Act
        await tester.pumpWidget(buildWidget(
          globalTheme: globalTheme,
          localTheme: localTheme,
        ));
        await tester.pumpAndSettle();

        // Assert -- ACTitledMonthWidget должен получить theme из localTheme
        final titledMonthWidgets = tester
            .widgetList<ACTitledMonthWidget>(
              find.byType(ACTitledMonthWidget),
            )
            .toList();

        expect(titledMonthWidgets, isNotEmpty);
        for (final widget in titledMonthWidgets) {
          expect(widget.theme, same(localTitledMonthTheme));
        }
      },
    );

    testWidgets(
      'все sub-themes из localTheme пробрасываются корректно',
      (tester) async {
        // Arrange
        final globalTheme = ACLightCalendarThemeData(
          dayTheme: ACLightDayThemeData(textColor: Colors.black),
          weekTheme: ACLightWeekThemeData(textColor: Colors.black),
          titledMonthTheme: ACLightTitledMonthThemeData(
            titleColor: Colors.black,
          ),
        );
        final localTheme = ACLightCalendarThemeData(
          dayTheme: ACLightDayThemeData(textColor: Colors.green),
          weekTheme: ACLightWeekThemeData(textColor: Colors.green),
          titledMonthTheme: ACLightTitledMonthThemeData(
            titleColor: Colors.green,
          ),
        );

        // Act
        await tester.pumpWidget(buildWidget(
          globalTheme: globalTheme,
          localTheme: localTheme,
        ));
        await tester.pumpAndSettle();

        // Assert -- проверяем weekTheme
        final weekWidget =
            tester.widget<ACWeekWidget>(find.byType(ACWeekWidget));
        expect(weekWidget.theme?.textColor, Colors.green);

        // Assert -- проверяем dayTheme через ACTitledMonthWidget
        final titledMonthWidget = tester.widget<ACTitledMonthWidget>(
          find.byType(ACTitledMonthWidget).first,
        );
        expect(
          (titledMonthWidget.dayTheme as ACLightDayThemeData?)?.textColor,
          Colors.green,
        );

        // Assert -- проверяем titledMonthTheme
        expect(
          (titledMonthWidget.theme as ACLightTitledMonthThemeData?)?.titleColor,
          Colors.green,
        );
      },
    );
  });
}
