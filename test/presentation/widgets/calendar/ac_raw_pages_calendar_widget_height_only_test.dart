import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final range = ACDateRange(
    min: DateTime(2024),
    max: DateTime(2025, 12),
  );

  Widget buildWidget({
    double? monthHeight,
    ACMonthLayout? monthLayout,
    DateTime? initialMonth,
  }) =>
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 400,
            child: ACRawPagesCalendarWidget(
              range: range,
              initialMonth: initialMonth,
              monthHeight: monthHeight,
              monthLayout: monthLayout,
            ),
          ),
        ),
      );

  group('ACRawPagesCalendarWidget -- monthHeight без monthLayout', () {
    testWidgets(
      'monthHeight задан без monthLayout: '
      'высота фиксирована, ACMonthWidget использует дефолтную раскладку',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget(
          initialMonth: DateTime(2024, 6),
          monthHeight: 200,
        ));
        await tester.pumpAndSettle();

        // Assert -- высота фиксирована на 200
        final scrollViewFinder = find.byType(ACScrollView<DateTime>);
        expect(scrollViewFinder, findsOneWidget);

        final sizedBoxFinder = find.ancestor(
          of: scrollViewFinder,
          matching: find.byType(SizedBox),
        );
        final sizedBoxes = tester.widgetList<SizedBox>(sizedBoxFinder);
        final matchingBox = sizedBoxes.where(
          (box) => box.height == 200,
        );
        expect(matchingBox, isNotEmpty);

        // Assert -- ACMonthWidget использует дефолтную раскладку (mainAxisCount6)
        final monthWidget = tester.widget<ACMonthWidget>(
          find.byType(ACMonthWidget),
        );
        expect(monthWidget.layout, isA<ACDefaultMonthLayout>());
        expect(
          (monthWidget.layout as ACDefaultMonthLayout).mainAxisCount,
          equals(6),
        );
      },
    );
  });
}
