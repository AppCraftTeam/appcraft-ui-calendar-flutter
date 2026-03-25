import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final range = ACDateRange(
    min: DateTime(2020),
    max: DateTime(2030),
  );

  group('ACCalendarScreen backgroundColor', () {
    testWidgets(
      'Scaffold has backgroundColor from theme when theme is provided',
      (tester) async {
        // Arrange
        final theme = ACLightCalendarThemeData(backgroundColor: Colors.red);

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: ACCalendarScreen(
              range: range,
              theme: theme,
              initialDate: DateTime(2024, 6),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Assert
        final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
        expect(scaffold.backgroundColor, Colors.red);
      },
    );

    testWidgets(
      'Scaffold backgroundColor defaults to white when no theme is provided',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            home: ACCalendarScreen(
              range: range,
              initialDate: DateTime(2024, 6),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Assert
        final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
        expect(scaffold.backgroundColor, const Color(0xFFFFFFFF));
      },
    );

    testWidgets(
      'Scaffold backgroundColor uses ACCalendarThemeExtension from ThemeData',
      (tester) async {
        // Arrange
        final extensionTheme = ACLightCalendarThemeData(
          backgroundColor: Colors.amber,
        );

        // Act
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              extensions: [ACCalendarThemeExtension(data: extensionTheme)],
            ),
            home: ACCalendarScreen(
              range: range,
              initialDate: DateTime(2024, 6),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Assert
        final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
        expect(scaffold.backgroundColor, Colors.amber);
      },
    );

    testWidgets(
      'AppBar backgroundColor matches Scaffold backgroundColor',
      (tester) async {
        // Arrange
        final theme = ACLightCalendarThemeData(backgroundColor: Colors.green);

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: ACCalendarScreen(
              range: range,
              theme: theme,
              initialDate: DateTime(2024, 6),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Assert
        final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
        final appBar = tester.widget<AppBar>(find.byType(AppBar));
        expect(scaffold.backgroundColor, Colors.green);
        expect(appBar.backgroundColor, Colors.green);
      },
    );
  });
}
