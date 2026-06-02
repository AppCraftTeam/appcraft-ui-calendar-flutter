import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final range = ACDateRange(
    min: DateTime(2024),
    max: DateTime(2025, 12),
  );

  Widget buildWidget({
    ACDateRange? customRange,
    ACCalendarThemeData? theme,
    ACCalendarSelectController? selectController,
    ACScrollViewController<DateTime>? scrollViewController,
    DateTime? initialDate,
    void Function(DateTime)? onVisibleDateChanged,
    PreferredSizeWidget? timeWidget,
    EdgeInsetsGeometry? scrollViewPadding,
    EdgeInsetsGeometry? weekPadding,
    EdgeInsetsGeometry? timeWidgetPadding,
  }) =>
      MaterialApp(
        theme: ThemeData(extensions: [
          ACCalendarThemeExtension(data: theme ?? ACLightCalendarThemeData())
        ]),
        home: Scaffold(
          body: SizedBox(
            width: 400,
            height: 600,
            child: ACCalendarWidget(
              range: customRange ?? range,
              theme: theme,
              selectController: selectController,
              scrollViewController: scrollViewController,
              initialDate: initialDate,
              onVisibleDateChanged: onVisibleDateChanged,
              timeWidget: timeWidget,
              scrollViewPadding: scrollViewPadding,
              weekPadding: weekPadding,
              timeWidgetPadding: timeWidgetPadding,
            ),
          ),
        ),
      );

  group('ACCalendarWidget -- rendering', () {
    testWidgets(
      'renders correctly with minimal parameters',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget(initialDate: DateTime(2024, 6)));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(ACCalendarWidget), findsOneWidget);
        expect(find.byType(ACRawCalendarWidget), findsOneWidget);
      },
    );

    testWidgets(
      'wraps ACRawCalendarWidget in ACCalendarScope',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget(initialDate: DateTime(2024, 6)));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(ACCalendarScope), findsOneWidget);
        expect(find.byType(ACRawCalendarWidget), findsOneWidget);
      },
    );

    testWidgets(
      'contains ACWeekWidget',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget(initialDate: DateTime(2024, 6)));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(ACWeekWidget), findsOneWidget);
      },
    );
  });

  group('ACCalendarWidget -- timeWidget', () {
    testWidgets(
      'displays timeWidget when provided',
      (tester) async {
        // Arrange
        final timeWidget = ACTitledTimeWidget.single(title: 'Time');

        // Act
        await tester.pumpWidget(buildWidget(
          initialDate: DateTime(2024, 6),
          timeWidget: timeWidget,
        ));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Time'), findsOneWidget);
      },
    );

    testWidgets(
      'does not display timeWidget when not provided',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget(initialDate: DateTime(2024, 6)));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(ACTitledTimeWidget), findsNothing);
      },
    );
  });

  group('ACCalendarWidget -- onVisibleDateChanged', () {
    testWidgets(
      'widget is created with onVisibleDateChanged callback',
      (tester) async {
        // Arrange
        final dates = <DateTime>[];

        // Act
        await tester.pumpWidget(buildWidget(
          initialDate: DateTime(2024, 6),
          onVisibleDateChanged: dates.add,
        ));
        await tester.pumpAndSettle();

        // Assert -- widget renders without errors
        expect(find.byType(ACCalendarWidget), findsOneWidget);
        // changedDate may be null if no scroll occurred
      },
    );
  });

  group('ACCalendarWidget -- selectController', () {
    testWidgets(
      'is created with an external selectController',
      (tester) async {
        // Arrange
        final selectController = ACCalendarSingleSelectController();

        // Act
        await tester.pumpWidget(buildWidget(
          initialDate: DateTime(2024, 6),
          selectController: selectController,
        ));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(ACCalendarWidget), findsOneWidget);

        selectController.dispose();
      },
    );

    testWidgets(
      'works without selectController',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget(initialDate: DateTime(2024, 6)));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(ACCalendarWidget), findsOneWidget);
      },
    );
  });

  group('ACCalendarWidget -- scrollViewController', () {
    testWidgets(
      'accepts an external scrollViewController',
      (tester) async {
        // Arrange
        final scrollViewController = ACScrollViewController<DateTime>();

        // Act
        await tester.pumpWidget(buildWidget(
          initialDate: DateTime(2024, 6),
          scrollViewController: scrollViewController,
        ));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(ACCalendarWidget), findsOneWidget);

        scrollViewController.dispose();
      },
    );
  });

  group('ACCalendarWidget -- padding', () {
    testWidgets(
      'is created with custom paddings',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget(
          initialDate: DateTime(2024, 6),
          scrollViewPadding: const EdgeInsets.all(20),
          weekPadding: const EdgeInsets.symmetric(horizontal: 10),
          timeWidgetPadding: const EdgeInsets.only(top: 12),
        ));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(ACCalendarWidget), findsOneWidget);
      },
    );
  });

  group('ACCalendarWidget -- dispose', () {
    testWidgets(
      'is correctly removed from the widget tree',
      (tester) async {
        // Arrange
        await tester.pumpWidget(buildWidget(initialDate: DateTime(2024, 6)));
        await tester.pumpAndSettle();

        // Act
        await tester.pumpWidget(const MaterialApp(home: Scaffold()));

        // Assert
        expect(find.byType(ACCalendarWidget), findsNothing);
      },
    );
  });
}
