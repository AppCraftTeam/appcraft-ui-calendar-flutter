import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ACWheelPicker масштабирование (T010)', () {
    Widget buildWidget(double scale) {
      return MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(scale)),
        child: const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 200,
              child: ACWheelPicker<String>(
                items: ['Январь', 'Февраль', 'Март'],
                itemExtent: 36,
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
        'элементы видны при textScaleFactor=$scale',
        (tester) async {
          // Arrange & Act
          await tester.pumpWidget(buildWidget(scale));

          // Assert -- хотя бы один из элементов отображается
          final textWidgets = tester.widgetList<Text>(
            find.descendant(
              of: find.byType(ACWheelPicker<String>),
              matching: find.byType(Text),
            ),
          );
          expect(textWidgets, isNotEmpty);
        },
      );
    }
  });

  group('ACWheelPicker touch targets (T030)', () {
    testWidgets(
      'itemExtent >= 48dp при дефолтном значении',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SizedBox(
                height: 200,
                child: ACWheelPicker<String>(
                  items: ['Январь', 'Февраль', 'Март'],
                  itemExtent: 36,
                ),
              ),
            ),
          ),
        );

        // Assert -- ListWheelScrollView использует itemExtent >= 48
        final listWheel = tester.widget<ListWheelScrollView>(
          find.byType(ListWheelScrollView),
        );
        expect(
          listWheel.itemExtent,
          greaterThanOrEqualTo(48),
          reason:
              'itemExtent должен быть >= 48dp для минимального размера touch target',
        );
      },
    );

    testWidgets(
      'itemExtent масштабируется при большом textScaleFactor',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          const MediaQuery(
            data: MediaQueryData(
              textScaler: TextScaler.linear(2),
            ),
            child: MaterialApp(
              home: Scaffold(
                body: SizedBox(
                  height: 200,
                  child: ACWheelPicker<String>(
                    items: ['Январь', 'Февраль', 'Март'],
                    itemExtent: 36,
                  ),
                ),
              ),
            ),
          ),
        );

        // Assert -- при scale=2.0 itemExtent = 36*2 = 72 > 48
        final listWheel = tester.widget<ListWheelScrollView>(
          find.byType(ListWheelScrollView),
        );
        expect(
          listWheel.itemExtent,
          greaterThanOrEqualTo(72),
          reason: 'itemExtent должен масштабироваться с textScaler',
        );
      },
    );
  });

  group('ACWheelPicker boldText (T036)', () {
    testWidgets(
      'при boldText=true fontWeight текста увеличен',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          const MediaQuery(
            data: MediaQueryData(boldText: true),
            child: MaterialApp(
              home: Scaffold(
                body: SizedBox(
                  height: 200,
                  child: ACWheelPicker<String>(
                    items: ['Январь', 'Февраль', 'Март'],
                    itemExtent: 36,
                  ),
                ),
              ),
            ),
          ),
        );

        // Assert
        final textWidgets = tester.widgetList<Text>(
          find.descendant(
            of: find.byType(ACWheelPicker<String>),
            matching: find.byType(Text),
          ),
        );
        expect(textWidgets, isNotEmpty);

        final firstText = textWidgets.first;
        expect(
          firstText.style?.fontWeight,
          isNotNull,
          reason: 'fontWeight должен быть задан при boldText=true',
        );
        expect(
          firstText.style!.fontWeight!.value,
          greaterThanOrEqualTo(FontWeight.w700.value),
          reason: 'fontWeight должен быть >= w700 при boldText=true',
        );
      },
    );
  });
}
