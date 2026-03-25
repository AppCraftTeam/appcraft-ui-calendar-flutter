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
            height: 600,
            child: ACCalendarScope(
              dateRange: range,
              child: ACRawCalendarWidget(
                range: range,
                initialDate: DateTime(2024, 6),
                weekWidget: weekWidget,
              ),
            ),
          ),
        ),
      );

  group('ACRawCalendarWidget -- weekWidget', () {
    testWidgets(
      'с weekWidget отображает кастомный виджет вместо ACWeekWidget',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          buildWidget(weekWidget: const _TestWeekWidget()),
        );
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('custom-week'), findsOneWidget);
        expect(find.byType(ACWeekWidget), findsNothing);
      },
    );

    testWidgets(
      'без weekWidget отображает ACWeekWidget по умолчанию',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget());
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(ACWeekWidget), findsOneWidget);
      },
    );
  });
}
