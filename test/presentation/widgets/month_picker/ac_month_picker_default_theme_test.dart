import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() => initializeDateFormatting('ru'));

  final range = ACDateRange(
    min: DateTime(2020, 1, 1),
    max: DateTime(2030, 12, 31),
  );

  group('ACMonthPicker without theme (defaults)', () {
    testWidgets(
      'renders without errors when no theme is provided',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                height: 200,
                child: ACMonthPicker(
                  range: range,
                  initialDate: DateTime(2024, 6),
                  onDateChanged: (_) {},
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(ACMonthPicker), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'renders two ACWheelPicker widgets for month and year',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                height: 200,
                child: ACMonthPicker(
                  range: range,
                  initialDate: DateTime(2024, 6),
                  onDateChanged: (_) {},
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(ACWheelPicker<int>), findsNWidgets(2));
      },
    );

    testWidgets(
      'uses ACCalendarThemeExtension from ThemeData when no theme provided',
      (tester) async {
        // Arrange
        final extensionTheme = ACLightCalendarThemeData(
          monthPickerTheme: ACLightMonthPickerThemeData(
            selectionColor: Colors.cyan,
          ),
        );

        // Act
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              extensions: [ACCalendarThemeExtension(data: extensionTheme)],
            ),
            home: Scaffold(
              body: SizedBox(
                height: 200,
                child: ACMonthPicker(
                  range: range,
                  initialDate: DateTime(2024, 6),
                  onDateChanged: (_) {},
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Assert: the selection indicator uses the theme extension color
        final containers = find.byType(Container);
        bool foundSelectionColor = false;
        for (final element in containers.evaluate()) {
          final widget = element.widget as Container;
          if (widget.decoration is BoxDecoration) {
            final decoration = widget.decoration! as BoxDecoration;
            if (decoration.color == Colors.cyan) {
              foundSelectionColor = true;
              break;
            }
          }
        }
        expect(foundSelectionColor, isTrue);
      },
    );
  });
}
