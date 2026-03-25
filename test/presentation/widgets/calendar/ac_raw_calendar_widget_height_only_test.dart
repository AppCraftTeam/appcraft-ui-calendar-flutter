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
    ACMonthLayout Function(BuildContext context, DateTime month)?
        monthLayoutBuilder,
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
              monthLayoutBuilder: monthLayoutBuilder,
            ),
          ),
        ),
      );

  group('ACRawCalendarWidget -- monthHeightBuilder без monthLayoutBuilder', () {
    testWidgets(
      'monthHeightBuilder задан без monthLayoutBuilder: '
      'высота из builder, ACTitledMonthWidget использует автоматическую '
      'раскладку',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget(
          monthHeightBuilder: (context, month) => 200.0,
        ));
        await tester.pumpAndSettle();

        // Assert -- высота из builder (200)
        final allSizedBoxes = tester.widgetList<SizedBox>(
          find.byType(SizedBox),
        );
        final matchingBox = allSizedBoxes.where(
          (box) => box.height == 200.0 && box.width == 400.0,
        );
        expect(matchingBox, isNotEmpty);

        // Assert -- ACTitledMonthWidget использует автоматическую раскладку
        final monthWidget = tester.widget<ACTitledMonthWidget>(
          find.byType(ACTitledMonthWidget).first,
        );
        expect(monthWidget.layout, isA<ACDefaultMonthLayout>());
      },
    );
  });
}
