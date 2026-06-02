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
        home: ACCalendarScreen(
          range: customRange ?? range,
          theme: theme,
          selectController: selectController,
          initialDate: initialDate,
          onVisibleDateChanged: onVisibleDateChanged,
          timeWidget: timeWidget,
          scrollViewPadding: scrollViewPadding,
          weekPadding: weekPadding,
          timeWidgetPadding: timeWidgetPadding,
        ),
      );

  group('ACCalendarScreen -- rendering', () {
    testWidgets(
      'renders correctly with minimal parameters',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget(initialDate: DateTime(2024, 6)));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(ACCalendarScreen), findsOneWidget);
        expect(find.byType(Scaffold), findsOneWidget);
      },
    );

    testWidgets(
      'contains AppBar with year',
      (tester) async {
        // Arrange
        final initialDate = DateTime(2024, 6);

        // Act
        await tester.pumpWidget(buildWidget(initialDate: initialDate));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.text('2024'), findsOneWidget);
      },
    );

    testWidgets(
      'contains ACRawCalendarWidget and ACCalendarScope',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget(initialDate: DateTime(2024, 6)));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(ACRawCalendarWidget), findsOneWidget);
        expect(find.byType(ACCalendarScope), findsOneWidget);
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

  group('ACCalendarScreen -- initialDate', () {
    testWidgets(
      'uses the current date when initialDate is not provided',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget());
        await tester.pumpAndSettle();

        // Assert
        final now = DateTime.now();
        expect(find.text('${now.year}'), findsOneWidget);
      },
    );

    testWidgets(
      'displays the year of the provided initialDate',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget(initialDate: DateTime(2025, 3)));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('2025'), findsOneWidget);
      },
    );
  });

  group('ACCalendarScreen -- styling', () {
    testWidgets(
      'applies background color from theme',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget(
          initialDate: DateTime(2024, 6),
          theme: ACLightCalendarThemeData(backgroundColor: Colors.blue),
        ));
        await tester.pumpAndSettle();

        // Assert
        final scaffold = tester.widget<Scaffold>(find.byType(Scaffold).first);
        expect(scaffold.backgroundColor, equals(Colors.blue));
      },
    );
  });

  group('ACCalendarScreen -- timeWidget', () {
    testWidgets(
      'displays timeWidget',
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
  });

  group('ACCalendarScreen -- onVisibleDateChanged', () {
    testWidgets(
      'widget is created with callback',
      (tester) async {
        // Arrange
        final dates = <DateTime>[];

        // Act
        await tester.pumpWidget(buildWidget(
          initialDate: DateTime(2024, 6),
          onVisibleDateChanged: dates.add,
        ));
        await tester.pumpAndSettle();

        // Assert -- widget renders correctly
        expect(find.byType(ACCalendarScreen), findsOneWidget);
      },
    );
  });

  group('ACCalendarScreen -- selectController', () {
    testWidgets(
      'works with an external selectController',
      (tester) async {
        // Arrange
        final controller = ACCalendarSingleSelectController();

        // Act
        await tester.pumpWidget(buildWidget(
          initialDate: DateTime(2024, 6),
          selectController: controller,
        ));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(ACCalendarScreen), findsOneWidget);

        controller.dispose();
      },
    );
  });

  group('ACCalendarScreen -- year in AppBar is wrapped in GestureDetector', () {
    testWidgets(
      'GestureDetector wraps the year text',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget(initialDate: DateTime(2024, 6)));
        await tester.pumpAndSettle();

        // Assert
        final yearText = find.text('2024');
        final gestureDetector = find.ancestor(
          of: yearText,
          matching: find.byType(GestureDetector),
        );
        expect(gestureDetector, findsAtLeastNWidgets(1));
      },
    );
  });

  group('ACCalendarScreen -- dispose', () {
    testWidgets(
      'is correctly removed from the widget tree',
      (tester) async {
        // Arrange
        await tester.pumpWidget(buildWidget(initialDate: DateTime(2024, 6)));
        await tester.pumpAndSettle();

        // Act
        await tester.pumpWidget(const MaterialApp(home: Scaffold()));

        // Assert
        expect(find.byType(ACCalendarScreen), findsNothing);
      },
    );
  });
}
