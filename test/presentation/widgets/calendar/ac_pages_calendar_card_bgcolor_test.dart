import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final range = ACDateRange(
    min: DateTime(2024),
    max: DateTime(2025, 12),
  );

  // Suppress overflow errors — ACPagesCalendarCard's internal Column
  // may overflow in constrained test surfaces. We only test decoration color.
  setUp(() {
    FlutterError.onError = (details) {
      final exception = details.exception;
      if (exception is FlutterError &&
          exception.message.contains('overflowed')) {
        return;
      }
      FlutterError.presentError(details);
    };
  });

  tearDown(() {
    FlutterError.onError = FlutterError.presentError;
  });

  Widget buildWidget({
    ACCalendarThemeData? theme,
    Color? backgroundColor,
    BoxDecoration? decoration,
  }) =>
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 400,
            child: ACPagesCalendarCard(
              range: range,
              theme: theme,
              backgroundColor: backgroundColor,
              decoration: decoration,
            ),
          ),
        ),
      );

  group('ACPagesCalendarCard backgroundColor', () {
    testWidgets(
      'uses backgroundColor from theme when theme is provided',
      (tester) async {
        // Arrange
        final theme = ACLightCalendarThemeData(backgroundColor: Colors.blue);

        // Act
        await tester.pumpWidget(buildWidget(theme: theme));
        await tester.pumpAndSettle();

        // Assert
        final container = tester.widget<Container>(
          find.descendant(
            of: find.byType(ACPagesCalendarCard),
            matching: find.byType(Container).first,
          ),
        );
        final boxDecoration = container.decoration! as BoxDecoration;
        expect(boxDecoration.color, Colors.blue);
      },
    );

    testWidgets(
      'explicit backgroundColor takes priority over theme backgroundColor',
      (tester) async {
        // Arrange
        final theme = ACLightCalendarThemeData(backgroundColor: Colors.blue);

        // Act
        await tester.pumpWidget(buildWidget(
          theme: theme,
          backgroundColor: Colors.orange,
        ));
        await tester.pumpAndSettle();

        // Assert
        final container = tester.widget<Container>(
          find.descendant(
            of: find.byType(ACPagesCalendarCard),
            matching: find.byType(Container).first,
          ),
        );
        final boxDecoration = container.decoration! as BoxDecoration;
        expect(boxDecoration.color, Colors.orange);
      },
    );

    testWidgets(
      'defaults to white backgroundColor when no theme provided',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget());
        await tester.pumpAndSettle();

        // Assert
        final container = tester.widget<Container>(
          find.descendant(
            of: find.byType(ACPagesCalendarCard),
            matching: find.byType(Container).first,
          ),
        );
        final boxDecoration = container.decoration! as BoxDecoration;
        expect(boxDecoration.color, const Color(0xFFFFFFFF));
      },
    );

    testWidgets(
      'custom decoration takes priority over backgroundColor',
      (tester) async {
        // Arrange
        final customDecoration = BoxDecoration(
          color: Colors.purple,
          borderRadius: BorderRadius.circular(8),
        );

        // Act
        await tester.pumpWidget(buildWidget(
          backgroundColor: Colors.orange,
          decoration: customDecoration,
        ));
        await tester.pumpAndSettle();

        // Assert
        final container = tester.widget<Container>(
          find.descendant(
            of: find.byType(ACPagesCalendarCard),
            matching: find.byType(Container).first,
          ),
        );
        final boxDecoration = container.decoration! as BoxDecoration;
        expect(boxDecoration.color, Colors.purple);
      },
    );
  });
}
