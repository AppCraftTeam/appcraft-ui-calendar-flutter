import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildTestApp(Widget child) {
    return MaterialApp(
      theme: ThemeData(
        extensions: [
          ACCalendarThemeExtension(data: ACLightCalendarThemeData())
        ],
      ),
      home: Scaffold(
        body: SizedBox(
          width: 400,
          child: child,
        ),
      ),
    );
  }

  group('ACTimeRangeInputWidget', () {
    testWidgets('renders two time input fields', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(buildTestApp(
        const ACTimeRangeInputWidget(),
      ));

      // Assert
      expect(find.byType(ACTimeInputWidget), findsNWidgets(2));
    });

    testWidgets('renders default separator', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(buildTestApp(
        const ACTimeRangeInputWidget(),
      ));

      // Assert
      expect(find.text('\u2013'), findsOneWidget);
    });

    testWidgets('renders custom separator', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(buildTestApp(
        const ACTimeRangeInputWidget(separator: 'to'),
      ));

      // Assert
      expect(find.text('to'), findsOneWidget);
    });

    testWidgets('renders with external controller', (tester) async {
      // Arrange
      final controller = ACTimeRangeInputController(
        range: ACTimeSelectRange(
          start: const TimeOfDay(hour: 9, minute: 0),
          end: const TimeOfDay(hour: 17, minute: 0),
        ),
      );

      // Act
      await tester.pumpWidget(buildTestApp(
        ACTimeRangeInputWidget(controller: controller),
      ));

      // Assert
      expect(find.text('09:00'), findsOneWidget);
      expect(find.text('17:00'), findsOneWidget);

      controller.dispose();
    });

    testWidgets('works without external controller', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(buildTestApp(
        const ACTimeRangeInputWidget(),
      ));

      // Assert - should render without errors
      expect(find.byType(ACTimeRangeInputWidget), findsOneWidget);
      expect(find.byType(ACTimeInputWidget), findsNWidgets(2));
    });

    testWidgets('creates internal controller when none provided',
        (tester) async {
      // Arrange & Act
      await tester.pumpWidget(buildTestApp(
        const ACTimeRangeInputWidget(),
      ));

      // Assert - fields should accept input independently
      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(2));

      // Enter time in first field
      await tester.tap(textFields.first);
      await tester.enterText(textFields.first, '0800');
      await tester.pump();

      final firstField = tester.widget<TextField>(textFields.first);
      expect(firstField.controller?.text, equals('08:00'));
    });

    testWidgets('disposes internal controller on widget removal',
        (tester) async {
      // Arrange
      await tester.pumpWidget(buildTestApp(
        const ACTimeRangeInputWidget(),
      ));

      // Act - remove widget (should not throw)
      await tester.pumpWidget(buildTestApp(
        const SizedBox(),
      ));

      // Assert
      expect(find.byType(ACTimeRangeInputWidget), findsNothing);
    });

    testWidgets('does not dispose external controller on widget removal',
        (tester) async {
      // Arrange
      final controller = ACTimeRangeInputController(
        range: ACTimeSelectRange(
          start: const TimeOfDay(hour: 10, minute: 0),
          end: const TimeOfDay(hour: 18, minute: 0),
        ),
      );

      await tester.pumpWidget(buildTestApp(
        ACTimeRangeInputWidget(controller: controller),
      ));

      // Act - remove widget
      await tester.pumpWidget(buildTestApp(
        const SizedBox(),
      ));

      // Assert - controller should still be usable
      expect(
        controller.range.start,
        equals(const TimeOfDay(hour: 10, minute: 0)),
      );
      expect(
        controller.range.end,
        equals(const TimeOfDay(hour: 18, minute: 0)),
      );

      controller.dispose();
    });

    testWidgets('handles controller swap via didUpdateWidget', (tester) async {
      // Arrange
      final controller1 = ACTimeRangeInputController(
        range: ACTimeSelectRange(
          start: const TimeOfDay(hour: 8, minute: 0),
          end: const TimeOfDay(hour: 12, minute: 0),
        ),
      );
      final controller2 = ACTimeRangeInputController(
        range: ACTimeSelectRange(
          start: const TimeOfDay(hour: 14, minute: 0),
          end: const TimeOfDay(hour: 22, minute: 0),
        ),
      );

      await tester.pumpWidget(buildTestApp(
        ACTimeRangeInputWidget(controller: controller1),
      ));
      expect(find.text('08:00'), findsOneWidget);

      // Act
      await tester.pumpWidget(buildTestApp(
        ACTimeRangeInputWidget(controller: controller2),
      ));

      // Assert
      expect(find.text('14:00'), findsOneWidget);
      expect(find.text('22:00'), findsOneWidget);

      controller1.dispose();
      controller2.dispose();
    });

    testWidgets('uses Row layout with Expanded children', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(buildTestApp(
        const ACTimeRangeInputWidget(),
      ));

      // Assert
      expect(find.byType(Row), findsOneWidget);
      expect(find.byType(Expanded), findsNWidgets(2));
    });

    testWidgets('applies custom spacing', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(buildTestApp(
        const ACTimeRangeInputWidget(spacing: 20),
      ));

      // Assert - find the Padding that wraps the separator Text
      final separatorFinder = find.text('\u2013');
      expect(separatorFinder, findsOneWidget);
      final paddingFinder = find.ancestor(
        of: separatorFinder,
        matching: find.byType(Padding),
      );
      final padding = tester.widget<Padding>(paddingFinder.first);
      expect(
        padding.padding,
        equals(const EdgeInsets.symmetric(horizontal: 20)),
      );
    });

    testWidgets('applies custom theme to both fields', (tester) async {
      // Arrange
      final customTheme = ACLightTimeInputThemeData(
        backgroundColor: Colors.green,
      );

      // Act
      await tester.pumpWidget(buildTestApp(
        ACTimeRangeInputWidget(theme: customTheme),
      ));

      // Assert
      expect(find.byType(ACTimeRangeInputWidget), findsOneWidget);
      // Both inner ACTimeInputWidget should use the custom theme
      final containers =
          tester.widgetList<Container>(find.byType(Container)).where((c) {
        final decoration = c.decoration;
        return decoration is BoxDecoration && decoration.color == Colors.green;
      });
      expect(containers.length, equals(2));
    });

    testWidgets('switching from external to null controller creates internal',
        (tester) async {
      // Arrange
      final controller = ACTimeRangeInputController(
        range: ACTimeSelectRange(
          start: const TimeOfDay(hour: 6, minute: 0),
          end: const TimeOfDay(hour: 7, minute: 0),
        ),
      );

      await tester.pumpWidget(buildTestApp(
        ACTimeRangeInputWidget(controller: controller),
      ));
      expect(find.text('06:00'), findsOneWidget);

      // Act - switch to no controller
      await tester.pumpWidget(buildTestApp(
        const ACTimeRangeInputWidget(),
      ));

      // Assert - should render without errors, with empty fields
      expect(find.byType(ACTimeRangeInputWidget), findsOneWidget);

      controller.dispose();
    });
  });
}
