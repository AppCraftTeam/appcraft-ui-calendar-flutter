import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ACTimeInputWidget масштабирование (T011)', () {
    Widget buildWidget(double scale) {
      return MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(scale)),
        child: const MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 120,
                child: ACTimeInputWidget(),
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
        'hint text отображается при textScaleFactor=$scale',
        (tester) async {
          // Arrange & Act
          await tester.pumpWidget(buildWidget(scale));

          // Assert -- текст подсказки "00:00" присутствует
          expect(find.text('00:00'), findsOneWidget);
        },
      );
    }
  });

  group('ACTimeInputWidget boldText (T036)', () {
    testWidgets(
      'при boldText=true fontWeight текста увеличен',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          const MediaQuery(
            data: MediaQueryData(boldText: true),
            child: MaterialApp(
              home: Scaffold(
                body: Center(
                  child: SizedBox(
                    width: 120,
                    child: ACTimeInputWidget(),
                  ),
                ),
              ),
            ),
          ),
        );

        // Assert -- TextField использует стиль с увеличенным fontWeight
        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(
          textField.style?.fontWeight,
          isNotNull,
          reason: 'fontWeight должен быть задан при boldText=true',
        );
        expect(
          textField.style!.fontWeight!.value,
          greaterThanOrEqualTo(FontWeight.w700.value),
          reason: 'fontWeight должен быть >= w700 при boldText=true',
        );
      },
    );
  });
}
