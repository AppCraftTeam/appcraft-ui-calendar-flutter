import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ACWeekWidget масштабирование (T007)', () {
    Widget buildWidget(double scale) {
      return MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(scale)),
        child: const MaterialApp(
          home: Scaffold(
            body: ACWeekWidget(),
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
        'текст дней недели отображается при textScaleFactor=$scale',
        (tester) async {
          // Arrange & Act
          await tester.pumpWidget(buildWidget(scale));

          // Assert -- все 7 дней недели присутствуют
          final textWidgets = tester.widgetList<Text>(
            find.descendant(
              of: find.byType(ACWeekWidget),
              matching: find.byType(Text),
            ),
          );
          expect(textWidgets.length, equals(7));
        },
      );
    }
  });

  group('ACWeekWidget boldText (T036)', () {
    testWidgets(
      'при boldText=true fontWeight текста увеличен',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          const MediaQuery(
            data: MediaQueryData(boldText: true),
            child: MaterialApp(
              home: Scaffold(
                body: ACWeekWidget(),
              ),
            ),
          ),
        );

        // Assert
        final textWidgets = tester.widgetList<Text>(
          find.descendant(
            of: find.byType(ACWeekWidget),
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
