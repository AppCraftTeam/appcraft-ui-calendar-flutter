import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildWidget({
    required ACWeekThemeData globalWeekTheme,
    ACWeekThemeData? paramWeekTheme,
  }) {
    return MaterialApp(
      theme: ThemeData(
        extensions: [
          ACCalendarThemeExtension(
            data: ACLightCalendarThemeData(weekTheme: globalWeekTheme),
          ),
        ],
      ),
      home: Scaffold(
        body: ACWeekWidget(theme: paramWeekTheme),
      ),
    );
  }

  group('ACWeekWidget -- приоритет параметра над ThemeExtension (US3 T019)',
      () {
    testWidgets(
      'текст использует цвет из параметра theme а не из ThemeExtension',
      (tester) async {
        // Arrange
        final globalWeekTheme = ACLightWeekThemeData(
          textColor: Colors.blue,
        );
        final paramWeekTheme = ACLightWeekThemeData(
          textColor: Colors.red,
        );

        // Act
        await tester.pumpWidget(buildWidget(
          globalWeekTheme: globalWeekTheme,
          paramWeekTheme: paramWeekTheme,
        ));

        // Assert -- все Text виджеты внутри ACWeekWidget должны
        // иметь цвет из paramWeekTheme (red), а не из globalWeekTheme (blue)
        final textWidgets = tester
            .widgetList<Text>(
              find.descendant(
                of: find.byType(ACWeekWidget),
                matching: find.byType(Text),
              ),
            )
            .toList();

        expect(textWidgets, isNotEmpty);
        for (final text in textWidgets) {
          expect(text.style?.color, Colors.red);
        }
      },
    );

    testWidgets(
      'текст использует цвет из ThemeExtension когда параметр не передан',
      (tester) async {
        // Arrange
        final globalWeekTheme = ACLightWeekThemeData(
          textColor: Colors.blue,
        );

        // Act
        await tester.pumpWidget(buildWidget(
          globalWeekTheme: globalWeekTheme,
        ));

        // Assert
        final textWidgets = tester
            .widgetList<Text>(
              find.descendant(
                of: find.byType(ACWeekWidget),
                matching: find.byType(Text),
              ),
            )
            .toList();

        expect(textWidgets, isNotEmpty);
        for (final text in textWidgets) {
          expect(text.style?.color, Colors.blue);
        }
      },
    );

    testWidgets(
      'использует дефолтную тему когда ни параметр ни ThemeExtension не заданы',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: ACWeekWidget(),
            ),
          ),
        );

        // Assert -- должен использовать дефолтный цвет ACLightWeekThemeData
        final defaultTheme = ACLightWeekThemeData();
        final textWidgets = tester
            .widgetList<Text>(
              find.descendant(
                of: find.byType(ACWeekWidget),
                matching: find.byType(Text),
              ),
            )
            .toList();

        expect(textWidgets, isNotEmpty);
        for (final text in textWidgets) {
          expect(text.style?.color, defaultTheme.textColor);
        }
      },
    );

    testWidgets(
      'textStyle из параметра theme применяется к тексту',
      (tester) async {
        // Arrange
        final globalWeekTheme = ACLightWeekThemeData(
          textColor: Colors.blue,
        );
        const customTextStyle = TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 16,
        );
        const paramWeekTheme = ACLightWeekThemeData.raw(
          textColor: Colors.red,
          textStyle: customTextStyle,
        );

        // Act
        await tester.pumpWidget(buildWidget(
          globalWeekTheme: globalWeekTheme,
          paramWeekTheme: paramWeekTheme,
        ));

        // Assert
        final textWidgets = tester
            .widgetList<Text>(
              find.descendant(
                of: find.byType(ACWeekWidget),
                matching: find.byType(Text),
              ),
            )
            .toList();

        expect(textWidgets, isNotEmpty);
        for (final text in textWidgets) {
          // textStyle.copyWith(color: textColor) -- fontWeight from param
          expect(text.style?.fontWeight, FontWeight.w800);
          expect(text.style?.color, Colors.red);
        }
      },
    );
  });
}
