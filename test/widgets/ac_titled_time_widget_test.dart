import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final theme = ACLightCalendarThemeData();

  Widget buildApp(Widget child) => MaterialApp(
        theme: ThemeData(extensions: [ACCalendarThemeExtension(data: theme)]),
        home: Scaffold(
          body: SizedBox(
            width: 400,
            height: 100,
            child: child,
          ),
        ),
      );

  group('ACTitledTimeWidget.single -- rendering', () {
    testWidgets(
      'displays the default title',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildApp(
          ACTitledTimeWidget.single(),
        ));

        // Assert -- defaults to the Russian-localized "time" title
        expect(find.byType(ACTitledTimeWidget), findsOneWidget);
        expect(find.byType(ACTimeInputWidget), findsOneWidget);
      },
    );

    testWidgets(
      'displays a custom title',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildApp(
          ACTitledTimeWidget.single(title: 'Custom Time'),
        ));

        // Assert
        expect(find.text('Custom Time'), findsOneWidget);
      },
    );

    testWidgets(
      'contains a Row with Text and ACTimeInputWidget',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildApp(
          ACTitledTimeWidget.single(title: 'Start'),
        ));

        // Assert
        expect(find.text('Start'), findsOneWidget);
        expect(find.byType(ACTimeInputWidget), findsOneWidget);
      },
    );
  });

  group('ACTitledTimeWidget.range -- rendering', () {
    testWidgets(
      'displays ACTimeRangeInputWidget',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildApp(
          ACTitledTimeWidget.range(),
        ));

        // Assert
        expect(find.byType(ACTitledTimeWidget), findsOneWidget);
        expect(find.byType(ACTimeRangeInputWidget), findsOneWidget);
      },
    );

    testWidgets(
      'displays a custom title for range',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildApp(
          ACTitledTimeWidget.range(title: 'Period'),
        ));

        // Assert
        expect(find.text('Period'), findsOneWidget);
      },
    );
  });

  group('ACTitledTimeWidget -- PreferredSizeWidget', () {
    test('preferredSize returns the default height of 34', () {
      // Arrange & Act
      final widget = ACTitledTimeWidget.single();

      // Assert
      expect(widget.preferredSize, equals(const Size.fromHeight(34)));
    });

    test('preferredSize returns a custom height', () {
      // Arrange & Act
      final widget = ACTitledTimeWidget.single(preferredHeight: 50);

      // Assert
      expect(widget.preferredSize, equals(const Size.fromHeight(50)));
    });

    test('preferredSize for the range constructor defaults to 34', () {
      // Arrange & Act
      final widget = ACTitledTimeWidget.range();

      // Assert
      expect(widget.preferredSize, equals(const Size.fromHeight(34)));
    });
  });

  group('ACTitledTimeWidget -- controller', () {
    testWidgets(
      'single accepts ACTimeInputController',
      (tester) async {
        // Arrange
        final controller =
            ACTimeInputController(time: const TimeOfDay(hour: 14, minute: 30));

        // Act
        await tester.pumpWidget(buildApp(
          ACTitledTimeWidget.single(
            title: 'Time',
            controller: controller,
          ),
        ));

        // Assert
        expect(find.byType(ACTimeInputWidget), findsOneWidget);
      },
    );

    testWidgets(
      'range accepts ACTimeRangeInputController',
      (tester) async {
        // Arrange
        final controller = ACTimeRangeInputController();

        // Act
        await tester.pumpWidget(buildApp(
          ACTitledTimeWidget.range(
            title: 'Range',
            controller: controller,
          ),
        ));

        // Assert
        expect(find.byType(ACTimeRangeInputWidget), findsOneWidget);

        controller.dispose();
      },
    );
  });

  group('ACTitledTimeWidget -- theme', () {
    testWidgets(
      'uses the theme from ACCalendarThemeData when not provided',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildApp(
          ACTitledTimeWidget.single(title: 'Themed'),
        ));

        // Assert -- widget renders without errors
        expect(find.text('Themed'), findsOneWidget);
      },
    );

    testWidgets(
      'uses the provided theme instead of ACCalendarThemeData',
      (tester) async {
        // Arrange
        final customTheme = ACLightTitledTimeThemeData(
          titleTextStyle: const TextStyle(fontSize: 20),
          titleColor: Colors.red,
        );

        // Act
        await tester.pumpWidget(buildApp(
          ACTitledTimeWidget.single(
            title: 'Custom',
            theme: customTheme,
          ),
        ));

        // Assert
        final textWidget = tester.widget<Text>(find.text('Custom'));
        expect(textWidget.style?.color, equals(Colors.red));
      },
    );
  });

  group('ACTitledTimeWidget -- SizedBox wrapper', () {
    testWidgets(
      'is wrapped in a SizedBox with the given height',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildApp(
          ACTitledTimeWidget.single(
            title: 'Height',
            preferredHeight: 60,
          ),
        ));

        // Assert -- check via preferredSize and rendering
        final widget = tester.widget<ACTitledTimeWidget>(
          find.byType(ACTitledTimeWidget),
        );
        expect(widget.preferredSize.height, equals(60));
      },
    );
  });
}
