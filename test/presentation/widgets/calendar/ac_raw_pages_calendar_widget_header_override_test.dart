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

  group(
      'ACRawPagesCalendarWidget -- headerWidget приоритет над theme.pagesCalendarHeaderTheme',
      () {
    testWidgets(
      'headerWidget и theme одновременно: headerWidget используется',
      (tester) async {
        // Arrange
        final theme = ACLightCalendarThemeData(
          pagesCalendarHeaderTheme: ACLightPagesCalendarHeaderThemeData(
            monthTextColor: const Color(0xFFAABBCC),
          ),
        );

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 400,
                child: ACCalendarScope(
                  dateRange: range,
                  child: ACRawPagesCalendarWidget(
                    range: range,
                    initialMonth: DateTime(2024, 6),
                    theme: theme,
                    headerWidget: const _TestHeaderWidget(),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('custom-header'), findsOneWidget);
        expect(find.byType(ACPagesCalendarHeader), findsNothing);
      },
    );
  });
}
