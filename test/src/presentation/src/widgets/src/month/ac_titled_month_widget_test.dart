import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ACTitledMonthWidget масштабирование (T012)', () {
    /// Генерирует 42 дня начиная с понедельника перед 1 марта 2024.
    List<DateTime> generateDays() {
      final start = DateTime(2024, 2, 26); // понедельник перед 1 марта
      return List.generate(42, (i) => start.add(Duration(days: i)));
    }

    Widget buildWidget(double scale) {
      return MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(scale)),
        child: MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              width: 350,
              child: ACTitledMonthWidget(
                layout: ACDefaultMonthLayout(),
                days: generateDays(),
                monthDate: DateTime(2024, 3, 1),
              ),
            ),
          ),
        ),
      );
    }

    for (final scale in [1.0, 1.5, 2.0]) {
      testWidgets(
        'рендерится без overflow при textScaleFactor=$scale',
        (tester) async {
          // Arrange & Act
          await tester.pumpWidget(buildWidget(scale));

          // Assert -- нет исключений при рендере
          expect(tester.takeException(), isNull);
        },
      );

      testWidgets(
        'название месяца отображается при textScaleFactor=$scale',
        (tester) async {
          // Arrange & Act
          await tester.pumpWidget(buildWidget(scale));

          // Assert -- находим текст с названием месяца в заголовке
          final textWidgets = tester.widgetList<Text>(
            find.descendant(
              of: find.byType(ACTitledMonthWidget),
              matching: find.byType(Text),
            ),
          );
          expect(textWidgets, isNotEmpty);
        },
      );
    }
  });

  group('ACTitledMonthWidget boldText (T036)', () {
    /// Генерирует 42 дня начиная с понедельника перед 1 марта 2024.
    List<DateTime> generateDays() {
      final start = DateTime(2024, 2, 26);
      return List.generate(42, (i) => start.add(Duration(days: i)));
    }

    testWidgets(
      'при boldText=true fontWeight заголовка увеличен',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(boldText: true),
            child: MaterialApp(
              home: Scaffold(
                body: SizedBox(
                  height: 400,
                  width: 350,
                  child: ACTitledMonthWidget(
                    layout: ACDefaultMonthLayout(),
                    days: generateDays(),
                    monthDate: DateTime(2024, 3, 1),
                  ),
                ),
              ),
            ),
          ),
        );

        // Assert -- находим текст заголовка месяца (первый Text в виджете)
        final textWidgets = tester.widgetList<Text>(
          find.descendant(
            of: find.byType(ACTitledMonthWidget),
            matching: find.byType(Text),
          ),
        );
        expect(textWidgets, isNotEmpty);

        final titleText = textWidgets.first;
        expect(
          titleText.style?.fontWeight,
          isNotNull,
          reason: 'fontWeight заголовка должен быть задан при boldText=true',
        );
        expect(
          titleText.style!.fontWeight!.value,
          greaterThanOrEqualTo(FontWeight.w700.value),
          reason: 'fontWeight заголовка должен быть >= w700 при boldText=true',
        );
      },
    );
  });
}
