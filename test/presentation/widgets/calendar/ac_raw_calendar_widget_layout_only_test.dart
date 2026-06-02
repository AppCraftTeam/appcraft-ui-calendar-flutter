import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final range = ACDateRange(
    min: DateTime(2020),
    max: DateTime(2030),
  );

  Widget buildWidget({
    ACMonthLayout Function(BuildContext context, DateTime month)?
        monthLayoutBuilder,
    double Function(BuildContext context, DateTime month)? monthHeightBuilder,
  }) =>
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 400,
            height: 600,
            child: ACRawCalendarWidget(
              range: range,
              initialDate: DateTime(2026, 3, 15),
              monthLayoutBuilder: monthLayoutBuilder,
              monthHeightBuilder: monthHeightBuilder,
            ),
          ),
        ),
      );

  group('ACRawCalendarWidget -- monthLayoutBuilder without monthHeightBuilder',
      () {
    testWidgets(
      'monthLayoutBuilder set without monthHeightBuilder: '
      'layout from builder, ACTitledMonthWidget receives it',
      (tester) async {
        // Arrange
        final layout = ACDefaultMonthLayout.mainAxisCount4;

        // Act
        await tester.pumpWidget(buildWidget(
          monthLayoutBuilder: (context, month) => layout,
        ));
        await tester.pumpAndSettle();

        // Assert -- ACTitledMonthWidget receives the layout from the builder
        final monthWidget = tester.widget<ACTitledMonthWidget>(
          find.byType(ACTitledMonthWidget).first,
        );
        expect(monthWidget.layout, equals(layout));
        expect(
          (monthWidget.layout as ACDefaultMonthLayout).mainAxisCount,
          equals(4),
        );
      },
    );

    testWidgets(
      'monthLayoutBuilder set without monthHeightBuilder: '
      'height is computed automatically from the given layout',
      (tester) async {
        // Arrange
        final layout = ACDefaultMonthLayout.mainAxisCount4;
        final expectedHeight = ACTitledMonthWidget.headerHeight +
            ACTitledMonthWidget.spacing +
            layout.calculateHeight(400);

        // Act
        await tester.pumpWidget(buildWidget(
          monthLayoutBuilder: (context, month) => layout,
        ));
        await tester.pumpAndSettle();

        // Assert -- SizedBox with height computed from the layout
        final allSizedBoxes = tester.widgetList<SizedBox>(
          find.byType(SizedBox),
        );
        final matchingBox = allSizedBoxes.where(
          (box) => box.height == expectedHeight && box.width == 400.0,
        );
        expect(matchingBox, isNotEmpty);
      },
    );
  });
}
