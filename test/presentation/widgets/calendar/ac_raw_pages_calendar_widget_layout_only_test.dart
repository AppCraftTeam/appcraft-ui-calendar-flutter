import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final range = ACDateRange(
    min: DateTime(2024),
    max: DateTime(2025, 12),
  );

  Widget buildWidget({
    ACMonthLayout? monthLayout,
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
              monthLayout: monthLayout,
              monthHeight: monthHeight,
            ),
          ),
        ),
      );

  group('ACRawPagesCalendarWidget -- monthLayout without monthHeight', () {
    testWidgets(
      'monthLayout set without monthHeight: '
      'ACMonthWidget uses the given layout',
      (tester) async {
        // Arrange
        final layout = ACDefaultMonthLayout.mainAxisCount4;

        // Act
        await tester.pumpWidget(buildWidget(
          initialMonth: DateTime(2024, 6),
          monthLayout: layout,
        ));
        await tester.pumpAndSettle();

        // Assert -- ACMonthWidget uses the given layout
        final monthWidget = tester.widget<ACMonthWidget>(
          find.byType(ACMonthWidget),
        );
        expect(monthWidget.layout, equals(layout));
        expect(
          (monthWidget.layout as ACDefaultMonthLayout).mainAxisCount,
          equals(4),
        );
      },
    );

    testWidgets(
      'monthLayout set without monthHeight: '
      'height is computed from the given layout',
      (tester) async {
        // Arrange
        final layout = ACDefaultMonthLayout.mainAxisCount4;
        final expectedHeight = layout.calculateHeight(400);

        // Act
        await tester.pumpWidget(buildWidget(
          initialMonth: DateTime(2024, 6),
          monthLayout: layout,
        ));
        await tester.pumpAndSettle();

        // Assert -- the SizedBox around ACScrollView has the height from the layout
        final scrollViewFinder = find.byType(ACScrollView<DateTime>);
        expect(scrollViewFinder, findsOneWidget);

        final sizedBoxFinder = find.ancestor(
          of: scrollViewFinder,
          matching: find.byType(SizedBox),
        );
        final sizedBoxes = tester.widgetList<SizedBox>(sizedBoxFinder);
        final matchingBox = sizedBoxes.where(
          (box) => box.height == expectedHeight,
        );
        expect(matchingBox, isNotEmpty);
      },
    );
  });
}
