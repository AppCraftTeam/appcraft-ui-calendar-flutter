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
            ),
          ),
        ),
      );

  group('ACRawPagesCalendarWidget -- monthHeight', () {
    testWidgets(
      'с monthHeight 300 SizedBox вокруг ACScrollView имеет height 300',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget(
          initialMonth: DateTime(2024, 6),
          monthHeight: 300,
        ));
        await tester.pumpAndSettle();

        // Assert
        final scrollViewFinder = find.byType(ACScrollView<DateTime>);
        expect(scrollViewFinder, findsOneWidget);

        // SizedBox непосредственно оборачивающий ACScrollView
        final sizedBoxFinder = find.ancestor(
          of: scrollViewFinder,
          matching: find.byType(SizedBox),
        );

        final sizedBoxes = tester.widgetList<SizedBox>(sizedBoxFinder);
        final matchingBox = sizedBoxes.where(
          (box) => box.height == 300,
        );
        expect(matchingBox, isNotEmpty);
      },
    );

    testWidgets(
      'без monthHeight высота вычисляется из layout.calculateHeight',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget(
          initialMonth: DateTime(2024, 6),
        ));
        await tester.pumpAndSettle();

        // Assert -- высота не равна какому-то произвольному числу,
        // а вычислена из дефолтного layout (mainAxisCount6)
        final scrollViewFinder = find.byType(ACScrollView<DateTime>);
        expect(scrollViewFinder, findsOneWidget);

        final sizedBoxFinder = find.ancestor(
          of: scrollViewFinder,
          matching: find.byType(SizedBox),
        );

        final sizedBoxes = tester.widgetList<SizedBox>(sizedBoxFinder);
        // Должен быть SizedBox с высотой, вычисленной layout
        // 400px width -> calculateHeight(400) для mainAxisCount6
        final expectedHeight =
            ACDefaultMonthLayout.mainAxisCount6.calculateHeight(400);
        final matchingBox = sizedBoxes.where(
          (box) => box.height == expectedHeight,
        );
        expect(matchingBox, isNotEmpty);
      },
    );
  });
}
