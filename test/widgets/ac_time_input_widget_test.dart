import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildTestApp(Widget child) {
    return MaterialApp(
      theme: ThemeData(
        extensions: [ACCalendarThemeExtension(data: ACCalendarThemeData())],
      ),
      home: Scaffold(body: child),
    );
  }

  group('ACTimeInputWidget', () {
    testWidgets('renders with default hintText', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(buildTestApp(
        const ACTimeInputWidget(),
      ));

      // Assert
      expect(find.byType(TextField), findsOneWidget);
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.decoration?.hintText, equals('00:00'));
    });

    testWidgets('renders with custom hintText', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(buildTestApp(
        const ACTimeInputWidget(hintText: 'HH:MM'),
      ));

      // Assert
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.decoration?.hintText, equals('HH:MM'));
    });

    testWidgets('renders initial time from controller', (tester) async {
      // Arrange
      final controller = ACTimeInputController(
        time: const TimeOfDay(hour: 14, minute: 30),
      );

      // Act
      await tester.pumpWidget(buildTestApp(
        ACTimeInputWidget(controller: controller),
      ));

      // Assert
      expect(find.text('14:30'), findsOneWidget);

      controller.dispose();
    });

    testWidgets('accepts digit input', (tester) async {
      // Arrange
      await tester.pumpWidget(buildTestApp(
        const ACTimeInputWidget(),
      ));

      // Act
      await tester.tap(find.byType(TextField));
      await tester.enterText(find.byType(TextField), '1');
      await tester.pump();

      // Assert
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, equals('1'));
    });

    testWidgets('inserts colon after two hour digits', (tester) async {
      // Arrange
      await tester.pumpWidget(buildTestApp(
        const ACTimeInputWidget(),
      ));

      // Act
      await tester.tap(find.byType(TextField));
      await tester.enterText(find.byType(TextField), '14');
      await tester.pump();

      // Assert
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, equals('14'));
    });

    testWidgets('formats full time input with colon', (tester) async {
      // Arrange
      await tester.pumpWidget(buildTestApp(
        const ACTimeInputWidget(),
      ));

      // Act
      await tester.tap(find.byType(TextField));
      await tester.enterText(find.byType(TextField), '1430');
      await tester.pump();

      // Assert
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, equals('14:30'));
    });

    testWidgets('rejects first hour digit greater than 2', (tester) async {
      // Arrange
      await tester.pumpWidget(buildTestApp(
        const ACTimeInputWidget(),
      ));

      // Act
      await tester.tap(find.byType(TextField));
      await tester.enterText(find.byType(TextField), '3');
      await tester.pump();

      // Assert
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, equals(''));
    });

    testWidgets('rejects hour 24 and above', (tester) async {
      // Arrange
      await tester.pumpWidget(buildTestApp(
        const ACTimeInputWidget(),
      ));

      // Act
      await tester.tap(find.byType(TextField));
      await tester.enterText(find.byType(TextField), '25');
      await tester.pump();

      // Assert
      final textField = tester.widget<TextField>(find.byType(TextField));
      // First digit '2' is valid, second digit '5' is rejected (2*10+5=25>23)
      expect(textField.controller?.text, equals('2'));
    });

    testWidgets('rejects minute first digit greater than 5', (tester) async {
      // Arrange
      await tester.pumpWidget(buildTestApp(
        const ACTimeInputWidget(),
      ));

      // Act
      await tester.tap(find.byType(TextField));
      await tester.enterText(find.byType(TextField), '1260');
      await tester.pump();

      // Assert
      final textField = tester.widget<TextField>(find.byType(TextField));
      // '12' valid hours, '6' rejected at i=2 (>5), colon not inserted because
      // i==2 was skipped, '0' written at i=3 without colon prefix
      expect(textField.controller?.text, equals('120'));
    });

    testWidgets('accepts valid time 23:59', (tester) async {
      // Arrange
      await tester.pumpWidget(buildTestApp(
        const ACTimeInputWidget(),
      ));

      // Act
      await tester.tap(find.byType(TextField));
      await tester.enterText(find.byType(TextField), '2359');
      await tester.pump();

      // Assert
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, equals('23:59'));
    });

    testWidgets('accepts valid time 00:00', (tester) async {
      // Arrange
      await tester.pumpWidget(buildTestApp(
        const ACTimeInputWidget(),
      ));

      // Act
      await tester.tap(find.byType(TextField));
      await tester.enterText(find.byType(TextField), '0000');
      await tester.pump();

      // Assert
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, equals('00:00'));
    });

    testWidgets('syncs controller time when valid input entered',
        (tester) async {
      // Arrange
      final controller = ACTimeInputController();
      await tester.pumpWidget(buildTestApp(
        ACTimeInputWidget(controller: controller),
      ));

      // Act
      await tester.tap(find.byType(TextField));
      await tester.enterText(find.byType(TextField), '1530');
      await tester.pump();

      // Assert
      expect(
        controller.time,
        equals(const TimeOfDay(hour: 15, minute: 30)),
      );

      controller.dispose();
    });

    testWidgets('controller time is null for incomplete input', (tester) async {
      // Arrange
      final controller = ACTimeInputController();
      await tester.pumpWidget(buildTestApp(
        ACTimeInputWidget(controller: controller),
      ));

      // Act
      await tester.tap(find.byType(TextField));
      await tester.enterText(find.byType(TextField), '15');
      await tester.pump();

      // Assert
      expect(controller.time, isNull);

      controller.dispose();
    });

    testWidgets('updates text when controller time changes externally',
        (tester) async {
      // Arrange
      final controller = ACTimeInputController();
      await tester.pumpWidget(buildTestApp(
        ACTimeInputWidget(controller: controller),
      ));

      // Act
      controller.time = const TimeOfDay(hour: 9, minute: 5);
      await tester.pump();

      // Assert
      expect(find.text('09:05'), findsOneWidget);

      controller.dispose();
    });

    testWidgets('works without controller', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(buildTestApp(
        const ACTimeInputWidget(),
      ));

      // Assert - should render without errors
      expect(find.byType(ACTimeInputWidget), findsOneWidget);

      // Act - should accept input without controller
      await tester.tap(find.byType(TextField));
      await tester.enterText(find.byType(TextField), '1200');
      await tester.pump();

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, equals('12:00'));
    });

    testWidgets('limits input to 4 digits', (tester) async {
      // Arrange
      await tester.pumpWidget(buildTestApp(
        const ACTimeInputWidget(),
      ));

      // Act
      await tester.tap(find.byType(TextField));
      await tester.enterText(find.byType(TextField), '123456');
      await tester.pump();

      // Assert
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, equals('12:34'));
    });

    testWidgets('filters non-digit characters', (tester) async {
      // Arrange
      await tester.pumpWidget(buildTestApp(
        const ACTimeInputWidget(),
      ));

      // Act
      await tester.tap(find.byType(TextField));
      await tester.enterText(find.byType(TextField), '1a2b3c0');
      await tester.pump();

      // Assert
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, equals('12:30'));
    });

    testWidgets('applies custom theme', (tester) async {
      // Arrange
      final customTheme = ACLightTimeInputThemeData(
        backgroundColor: Colors.red,
      );

      // Act
      await tester.pumpWidget(buildTestApp(
        ACTimeInputWidget(theme: customTheme),
      ));

      // Assert
      expect(find.byType(ACTimeInputWidget), findsOneWidget);
      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration?;
      expect(decoration?.color, equals(Colors.red));
    });

    testWidgets('handles controller swap via didUpdateWidget', (tester) async {
      // Arrange
      final controller1 = ACTimeInputController(
        time: const TimeOfDay(hour: 10, minute: 0),
      );
      final controller2 = ACTimeInputController(
        time: const TimeOfDay(hour: 20, minute: 0),
      );

      await tester.pumpWidget(buildTestApp(
        ACTimeInputWidget(controller: controller1),
      ));
      expect(find.text('10:00'), findsOneWidget);

      // Act
      await tester.pumpWidget(buildTestApp(
        ACTimeInputWidget(controller: controller2),
      ));

      // Assert
      expect(find.text('20:00'), findsOneWidget);

      controller1.dispose();
      controller2.dispose();
    });
  });
}
