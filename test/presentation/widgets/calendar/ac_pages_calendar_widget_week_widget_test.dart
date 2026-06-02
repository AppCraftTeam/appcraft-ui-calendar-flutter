import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestWeekWidget extends StatelessWidget implements PreferredSizeWidget {
  const _TestWeekWidget();

  @override
  Size get preferredSize => const Size.fromHeight(30);

  @override
  Widget build(BuildContext context) => const SizedBox(
        height: 30,
        child: Text('custom-week'),
      );
}

void main() {
  final range = ACDateRange(
    min: DateTime(2024),
    max: DateTime(2025, 12),
  );

  Widget buildWidget({PreferredSizeWidget? weekWidget}) => MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 400,
            child: ACPagesCalendarWidget(
              range: range,
              initialMonth: DateTime(2024, 6),
              weekWidget: weekWidget,
            ),
          ),
        ),
      );

  group(
      'ACPagesCalendarWidget -- forwarding weekWidget to ACRawPagesCalendarWidget',
      () {
    testWidgets(
      'forwards weekWidget to ACRawPagesCalendarWidget',
      (tester) async {
        // Arrange
        const testWeekWidget = _TestWeekWidget();

        // Act
        await tester.pumpWidget(buildWidget(weekWidget: testWeekWidget));
        await tester.pumpAndSettle();

        // Assert
        final rawWidget = tester.widget<ACRawPagesCalendarWidget>(
          find.byType(ACRawPagesCalendarWidget),
        );
        expect(rawWidget.weekWidget, isNotNull);
      },
    );

    testWidgets(
      'without weekWidget ACRawPagesCalendarWidget receives null',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget());
        await tester.pumpAndSettle();

        // Assert
        final rawWidget = tester.widget<ACRawPagesCalendarWidget>(
          find.byType(ACRawPagesCalendarWidget),
        );
        expect(rawWidget.weekWidget, isNull);
      },
    );
  });
}
