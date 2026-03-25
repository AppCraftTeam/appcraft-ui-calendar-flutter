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
        theme: ThemeData(extensions: [
          ACCalendarThemeExtension(data: ACLightCalendarThemeData()),
        ]),
        home: ACCalendarScreen(
          range: range,
          initialDate: DateTime(2024, 6),
          weekWidget: weekWidget,
        ),
      );

  group('ACCalendarScreen -- проброс weekWidget в ACRawCalendarWidget', () {
    testWidgets(
      'передаёт weekWidget в ACRawCalendarWidget',
      (tester) async {
        // Arrange
        const testWeekWidget = _TestWeekWidget();

        // Act
        await tester.pumpWidget(buildWidget(weekWidget: testWeekWidget));
        await tester.pumpAndSettle();

        // Assert
        final rawWidget = tester.widget<ACRawCalendarWidget>(
          find.byType(ACRawCalendarWidget),
        );
        expect(rawWidget.weekWidget, isNotNull);
      },
    );

    testWidgets(
      'без weekWidget ACRawCalendarWidget получает null',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget());
        await tester.pumpAndSettle();

        // Assert
        final rawWidget = tester.widget<ACRawCalendarWidget>(
          find.byType(ACRawCalendarWidget),
        );
        expect(rawWidget.weekWidget, isNull);
      },
    );
  });
}
