import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ACMonthPicker масштабирование (T013)', () {
    Widget buildWidget(double scale) {
      return MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(scale)),
        child: MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 200,
              child: ACMonthPicker(
                range: ACDateRange(
                  min: DateTime(2024, 1, 1),
                  max: DateTime(2025, 12, 31),
                ),
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
        'элементы пикера видны при textScaleFactor=$scale',
        (tester) async {
          // Arrange & Act
          await tester.pumpWidget(buildWidget(scale));

          // Assert -- находим текстовые элементы внутри пикера
          final textWidgets = tester.widgetList<Text>(
            find.descendant(
              of: find.byType(ACMonthPicker),
              matching: find.byType(Text),
            ),
          );
          expect(textWidgets, isNotEmpty);
        },
      );
    }
  });
}
