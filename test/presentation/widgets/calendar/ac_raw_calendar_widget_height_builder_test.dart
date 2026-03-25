import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final range = ACDateRange(
    min: DateTime(2020),
    max: DateTime(2030),
  );

  Widget buildWidget({
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
              monthHeightBuilder: monthHeightBuilder,
            ),
          ),
        ),
      );

  group('ACRawCalendarWidget -- monthHeightBuilder', () {
    testWidgets(
      'с monthHeightBuilder высота SizedBox определяется коллбэком',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget(
          monthHeightBuilder: (context, month) => 300.0,
        ));
        await tester.pumpAndSettle();

        // Assert -- находим SizedBox с height == 300 внутри ACScrollView
        final allSizedBoxes = tester.widgetList<SizedBox>(
          find.byType(SizedBox),
        );
        final matchingBox = allSizedBoxes.where(
          (box) => box.height == 300.0 && box.width == 400.0,
        );
        expect(matchingBox, isNotEmpty);
      },
    );

    testWidgets(
      'без monthHeightBuilder высота вычисляется автоматически',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget());
        await tester.pumpAndSettle();

        // Assert -- нет SizedBox с height == 300 (высота вычислена автоматически)
        final allSizedBoxes = tester.widgetList<SizedBox>(
          find.byType(SizedBox),
        );
        final matchingBox = allSizedBoxes.where(
          (box) => box.height == 300.0 && box.width == 400.0,
        );
        expect(matchingBox, isEmpty);
      },
    );
  });
}
