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

  group('ACMonthPicker with custom theme', () {
    testWidgets(
      'uses monthPickerTheme from provided theme',
      (tester) async {
        // Arrange
        final customMonthPickerTheme = ACLightMonthPickerThemeData(
          selectionColor: Colors.red,
        );
        final customTheme = ACLightCalendarThemeData(
          monthPickerTheme: customMonthPickerTheme,
        );

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                height: 200,
                child: ACMonthPicker(
                  range: range,
                  initialDate: DateTime(2024, 6),
                  onDateChanged: (_) {},
                  theme: customTheme,
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Assert: the selection indicator container uses the custom color
        // Find the Container with the selection decoration
        final containers = find.byType(Container);
        bool foundSelectionColor = false;
        for (final element in containers.evaluate()) {
          final widget = element.widget as Container;
          if (widget.decoration is BoxDecoration) {
            final decoration = widget.decoration! as BoxDecoration;
            if (decoration.color == Colors.red) {
              foundSelectionColor = true;
              break;
            }
          }
        }
        expect(foundSelectionColor, isTrue);
      },
    );

    testWidgets(
      'uses wheelPickerTheme from provided theme for year wheel',
      (tester) async {
        // Arrange
        final customWheelTheme = ACLightWheelPickerThemeData(
          itemTextColor: Colors.purple,
        );
        final customTheme = ACLightCalendarThemeData(
          wheelPickerTheme: customWheelTheme,
        );

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                height: 200,
                child: ACMonthPicker(
                  range: range,
                  initialDate: DateTime(2024, 6),
                  onDateChanged: (_) {},
                  theme: customTheme,
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Assert: ACWheelPicker for years receives custom theme
        final wheelPickers = find.byType(ACWheelPicker<int>);
        expect(wheelPickers, findsNWidgets(2));

        // The second wheel picker (year) should have the custom theme
        final yearWheelPicker = tester.widget<ACWheelPicker<int>>(
          wheelPickers.last,
        );
        expect(yearWheelPicker.theme, equals(customWheelTheme));
      },
    );

    testWidgets(
      'renders without errors when custom theme is provided',
      (tester) async {
        // Arrange
        final customTheme = ACLightCalendarThemeData(
          monthPickerTheme: ACLightMonthPickerThemeData(),
          wheelPickerTheme: ACLightWheelPickerThemeData(),
        );

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                height: 200,
                child: ACMonthPicker(
                  range: range,
                  initialDate: DateTime(2024, 6),
                  onDateChanged: (_) {},
                  theme: customTheme,
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
  });
}
