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

  group('ACRawCalendarWidget -- weekWidget приоритет над weekTheme', () {
    testWidgets(
      'weekWidget и theme.weekTheme одновременно: weekWidget используется',
      (tester) async {
        // Arrange
        final theme = ACLightCalendarThemeData(
          weekTheme: ACLightWeekThemeData(
            textColor: const Color(0xFF112233),
          ),
        );

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 400,
                height: 600,
                child: ACCalendarScope(
                  dateRange: range,
                  child: ACRawCalendarWidget(
                    range: range,
                    initialDate: DateTime(2024, 6),
                    theme: theme,
                    weekWidget: const _TestWeekWidget(),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('custom-week'), findsOneWidget);
        expect(find.byType(ACWeekWidget), findsNothing);
      },
    );
  });
}
