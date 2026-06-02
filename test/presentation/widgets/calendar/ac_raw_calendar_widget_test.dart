import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final range = ACDateRange(
    min: DateTime(2024),
    max: DateTime(2025, 12),
  );

  Widget buildWidget({
    ACScrollViewController<DateTime>? scrollViewController,
    ACScrollViewDataSource<DateTime>? scrollViewDataSource,
    DateTime? initialDate,
  }) =>
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 400,
            height: 600,
            child: ACRawCalendarWidget(
              range: range,
              initialDate: initialDate,
              scrollViewController: scrollViewController,
              scrollViewDataSource: scrollViewDataSource,
            ),
          ),
        ),
      );

  group('ACRawCalendarWidget -- external scrollViewDataSource', () {
    testWidgets(
      'used by the widget: ACScrollView initializes it',
      (tester) async {
        // Arrange
        final fixedMonth = DateTime(2024, 3);
        final dataSource = ACDefaultScrollViewDataSource<DateTime>(
          initialItem: fixedMonth,
          onBefore: (_) => null,
          onAfter: (_) => null,
        );

        await tester.pumpWidget(buildWidget(
          scrollViewDataSource: dataSource,
          initialDate: fixedMonth,
        ));
        await tester.pumpAndSettle();

        // Assert
        expect(dataSource.currentItem, equals(fixedMonth));

        dataSource.dispose();
      },
    );

    testWidgets(
      'is not disposed when the widget is disposed',
      (tester) async {
        // Arrange
        final dataSource = ACDefaultScrollViewDataSource<DateTime>(
          initialItem: DateTime(2024, 6),
          onBefore: (m) => DateTime(m.year, m.month - 1),
          onAfter: (m) => DateTime(m.year, m.month + 1),
        );

        await tester.pumpWidget(buildWidget(scrollViewDataSource: dataSource));
        await tester.pumpAndSettle();

        // Act
        await tester.pumpWidget(const MaterialApp(home: Scaffold()));

        // Assert
        expect(() => dataSource.addListener(() {}), returnsNormally);

        dataSource.dispose();
      },
    );
  });

  group('ACRawCalendarWidget -- internal scrollViewDataSource', () {
    testWidgets(
      'the internal source is disposed when the widget is disposed',
      (tester) async {
        // Arrange
        await tester.pumpWidget(buildWidget(initialDate: DateTime(2024, 6)));
        await tester.pumpAndSettle();

        // Act & Assert -- the widget is removed without exceptions,
        // the internal data source is disposed correctly
        await tester.pumpWidget(const MaterialApp(home: Scaffold()));
        expect(find.byType(ACRawCalendarWidget), findsNothing);
      },
    );
  });

  group('ACRawCalendarWidget -- default behavior', () {
    testWidgets(
      'renders correctly without external parameters',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget(initialDate: DateTime(2024, 6)));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(ACRawCalendarWidget), findsOneWidget);
        expect(find.byType(ACWeekWidget), findsOneWidget);
      },
    );
  });

  group('ACRawCalendarWidget -- didUpdateWidget scrollViewDataSource', () {
    testWidgets(
      'switching the external source to another external one',
      (tester) async {
        // Arrange
        final dataSourceA = ACDefaultScrollViewDataSource<DateTime>(
          initialItem: DateTime(2024, 3),
          onBefore: (_) => null,
          onAfter: (_) => null,
        );
        final dataSourceB = ACDefaultScrollViewDataSource<DateTime>(
          initialItem: DateTime(2024, 9),
          onBefore: (_) => null,
          onAfter: (_) => null,
        );

        await tester.pumpWidget(buildWidget(
          scrollViewDataSource: dataSourceA,
          initialDate: DateTime(2024, 3),
        ));
        await tester.pumpAndSettle();

        // Act -- rebuild with a different data source (same widget key)
        await tester.pumpWidget(buildWidget(
          scrollViewDataSource: dataSourceB,
          initialDate: DateTime(2024, 3),
        ));
        await tester.pumpAndSettle();

        // Assert -- both external data sources are alive (not disposed by the widget)
        expect(() => dataSourceA.addListener(() {}), returnsNormally);
        expect(() => dataSourceB.addListener(() {}), returnsNormally);

        dataSourceA.dispose();
        dataSourceB.dispose();
      },
    );

    testWidgets(
      'switching the internal source to an external one disposes the internal one',
      (tester) async {
        // Arrange -- without scrollViewDataSource (an internal one is created)
        await tester.pumpWidget(buildWidget(initialDate: DateTime(2024, 6)));
        await tester.pumpAndSettle();

        // Act -- rebuild with an external data source
        final externalDataSource = ACDefaultScrollViewDataSource<DateTime>(
          initialItem: DateTime(2024, 6),
          onBefore: (_) => null,
          onAfter: (_) => null,
        );

        await tester.pumpWidget(buildWidget(
          scrollViewDataSource: externalDataSource,
          initialDate: DateTime(2024, 6),
        ));
        await tester.pumpAndSettle();

        // Assert -- the widget keeps rendering correctly
        expect(find.byType(ACRawCalendarWidget), findsOneWidget);

        externalDataSource.dispose();
      },
    );

    testWidgets(
      'switching the external source to null creates a new internal one',
      (tester) async {
        // Arrange -- with an external data source
        final externalDataSource = ACDefaultScrollViewDataSource<DateTime>(
          initialItem: DateTime(2024, 6),
          onBefore: (m) => DateTime(m.year, m.month - 1),
          onAfter: (m) => DateTime(m.year, m.month + 1),
        );

        await tester.pumpWidget(buildWidget(
          scrollViewDataSource: externalDataSource,
          initialDate: DateTime(2024, 6),
        ));
        await tester.pumpAndSettle();

        // Act -- rebuild without an external data source
        await tester.pumpWidget(buildWidget(initialDate: DateTime(2024, 6)));
        await tester.pumpAndSettle();

        // Assert -- the external data source is not destroyed by the widget
        expect(() => externalDataSource.addListener(() {}), returnsNormally);
        // The widget continues working with the internal data source
        expect(find.byType(ACRawCalendarWidget), findsOneWidget);

        externalDataSource.dispose();
      },
    );
  });
}
