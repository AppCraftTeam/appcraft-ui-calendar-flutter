import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ACPagesCalendarHeader масштабирование (T008)', () {
    Widget buildWidget(double scale) {
      return MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(scale)),
        child: MaterialApp(
          home: Scaffold(
            body: ACPagesCalendarHeader(
              monthDate: DateTime(2024, 3, 1),
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
        'заголовок месяца отображается при textScaleFactor=$scale',
        (tester) async {
          // Arrange & Act
          await tester.pumpWidget(buildWidget(scale));

          // Assert -- находим текст с названием месяца
          final textWidgets = tester.widgetList<Text>(
            find.descendant(
              of: find.byType(ACPagesCalendarHeader),
              matching: find.byType(Text),
            ),
          );
          expect(textWidgets, isNotEmpty);
        },
      );

      testWidgets(
        'стрелки навигации отображаются при textScaleFactor=$scale',
        (tester) async {
          // Arrange & Act
          await tester.pumpWidget(buildWidget(scale));

          // Assert -- кнопки навигации присутствуют
          expect(
            find.byIcon(Icons.arrow_back_ios_rounded),
            findsOneWidget,
          );
          expect(
            find.byIcon(Icons.arrow_forward_ios_rounded),
            findsOneWidget,
          );
        },
      );
    }
  });

  group('ACPagesCalendarHeader touch targets (T028)', () {
    testWidgets(
      'стрелки навигации имеют зону касания >= 48dp',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ACPagesCalendarHeader(
                monthDate: DateTime(2024, 3, 1),
                onPrevious: () {},
                onNext: () {},
              ),
            ),
          ),
        );

        // Assert -- каждая кнопка-стрелка обёрнута в SizedBox >= 48x48
        final iconButtons = find.byType(IconButton);
        expect(iconButtons, findsNWidgets(2));

        for (final button in iconButtons.evaluate()) {
          final size = tester.getSize(find.byWidget(button.widget));
          expect(
            size.width,
            greaterThanOrEqualTo(48),
            reason: 'Ширина зоны касания стрелки должна быть >= 48dp',
          );
          expect(
            size.height,
            greaterThanOrEqualTo(48),
            reason: 'Высота зоны касания стрелки должна быть >= 48dp',
          );
        }
      },
    );

    testWidgets(
      'заголовок месяца имеет минимальную высоту касания >= 48dp',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ACPagesCalendarHeader(
                monthDate: DateTime(2024, 3, 1),
                onMonthTap: () {},
              ),
            ),
          ),
        );

        // Assert -- ConstrainedBox с minHeight 48 оборачивает заголовок
        final constrainedBoxes = tester.widgetList<ConstrainedBox>(
          find.byType(ConstrainedBox),
        );
        final headerConstrainedBox = constrainedBoxes.where(
          (cb) => cb.constraints.minHeight >= 48,
        );
        expect(
          headerConstrainedBox,
          isNotEmpty,
          reason:
              'Должен существовать ConstrainedBox с minHeight >= 48 для заголовка',
        );
      },
    );
  });

  group('ACPagesCalendarHeader boldText (T036)', () {
    testWidgets(
      'при boldText=true fontWeight текста увеличен',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(boldText: true),
            child: MaterialApp(
              home: Scaffold(
                body: ACPagesCalendarHeader(
                  monthDate: DateTime(2024, 3, 1),
                ),
              ),
            ),
          ),
        );

        // Assert -- текст заголовка имеет увеличенный fontWeight
        final textWidget = tester.widgetList<Text>(
          find.descendant(
            of: find.byType(ACPagesCalendarHeader),
            matching: find.byType(Text),
          ),
        );
        expect(textWidget, isNotEmpty);

        final firstText = textWidget.first;
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
