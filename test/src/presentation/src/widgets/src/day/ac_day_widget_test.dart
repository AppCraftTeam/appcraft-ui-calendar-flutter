import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ACDayWidget масштабирование (T009)', () {
    Widget buildWidget(double scale) {
      return MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(scale)),
        child: MaterialApp(
          home: Scaffold(
            body: Center(
              child: ACDayWidget(
                dayDate: DateTime(2024, 3, 15),
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
        'число дня отображается при textScaleFactor=$scale',
        (tester) async {
          // Arrange & Act
          await tester.pumpWidget(buildWidget(scale));

          // Assert -- текст "15" присутствует
          expect(find.text('15'), findsOneWidget);
        },
      );
    }
  });

  group('ACDayWidget touch targets (T029)', () {
    testWidgets(
      'GestureDetector имеет HitTestBehavior.opaque при наличии onTap',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: ACDayWidget(
                  dayDate: DateTime(2024, 3, 15),
                  onTap: () {},
                ),
              ),
            ),
          ),
        );

        // Assert
        final gestureDetector = tester.widget<GestureDetector>(
          find.byType(GestureDetector),
        );
        expect(
          gestureDetector.behavior,
          equals(HitTestBehavior.opaque),
          reason:
              'GestureDetector должен иметь HitTestBehavior.opaque для полного покрытия области касания',
        );
      },
    );
  });

  group('ACDayWidget boldText (T035)', () {
    testWidgets(
      'при boldText=true fontWeight текста увеличен',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(boldText: true),
            child: MaterialApp(
              home: Scaffold(
                body: Center(
                  child: ACDayWidget(
                    dayDate: DateTime(2024, 3, 15),
                  ),
                ),
              ),
            ),
          ),
        );

        // Assert
        final textWidget = tester.widget<Text>(find.text('15'));
        expect(
          textWidget.style?.fontWeight,
          isNotNull,
          reason: 'fontWeight должен быть задан при boldText=true',
        );
        expect(
          textWidget.style!.fontWeight!.value,
          greaterThanOrEqualTo(FontWeight.w700.value),
          reason: 'fontWeight должен быть >= w700 при boldText=true',
        );
      },
    );
  });
}
