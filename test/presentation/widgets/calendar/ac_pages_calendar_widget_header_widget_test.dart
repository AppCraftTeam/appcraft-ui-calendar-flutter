import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestHeaderWidget extends StatelessWidget implements PreferredSizeWidget {
  const _TestHeaderWidget();

  @override
  Size get preferredSize => const Size.fromHeight(40);

  @override
  Widget build(BuildContext context) => const SizedBox(
        height: 40,
        child: Text('custom-header'),
      );
}

void main() {
  final range = ACDateRange(
    min: DateTime(2024),
    max: DateTime(2025, 12),
  );

  Widget buildWidget({PreferredSizeWidget? headerWidget}) => MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 400,
            child: ACPagesCalendarWidget(
              range: range,
              initialMonth: DateTime(2024, 6),
              headerWidget: headerWidget,
            ),
          ),
        ),
      );

  group(
      'ACPagesCalendarWidget -- проброс headerWidget в ACRawPagesCalendarWidget',
      () {
    testWidgets(
      'передаёт headerWidget в ACRawPagesCalendarWidget',
      (tester) async {
        // Arrange
        const testHeaderWidget = _TestHeaderWidget();

        // Act
        await tester.pumpWidget(buildWidget(headerWidget: testHeaderWidget));
        await tester.pumpAndSettle();

        // Assert
        final rawWidget = tester.widget<ACRawPagesCalendarWidget>(
          find.byType(ACRawPagesCalendarWidget),
        );
        expect(rawWidget.headerWidget, isNotNull);
      },
    );

    testWidgets(
      'без headerWidget ACRawPagesCalendarWidget получает null',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget());
        await tester.pumpAndSettle();

        // Assert
        final rawWidget = tester.widget<ACRawPagesCalendarWidget>(
          find.byType(ACRawPagesCalendarWidget),
        );
        expect(rawWidget.headerWidget, isNull);
      },
    );
  });
}
