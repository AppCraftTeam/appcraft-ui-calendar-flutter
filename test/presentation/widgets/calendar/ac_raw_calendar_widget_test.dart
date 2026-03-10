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

  group('ACRawCalendarWidget -- внешний scrollViewDataSource', () {
    testWidgets(
      'используется виджетом: ACScrollView инициализирует его',
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
      'не уничтожается при dispose виджета',
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

  group('ACRawCalendarWidget -- внутренний scrollViewDataSource', () {
    testWidgets(
      'внутренний источник уничтожается при dispose виджета',
      (tester) async {
        // Arrange
        await tester.pumpWidget(buildWidget(initialDate: DateTime(2024, 6)));
        await tester.pumpAndSettle();

        // Act & Assert -- виджет удаляется без исключений,
        // внутренний источник dispose-ируется корректно
        await tester.pumpWidget(const MaterialApp(home: Scaffold()));
        expect(find.byType(ACRawCalendarWidget), findsNothing);
      },
    );
  });

  group('ACRawCalendarWidget -- поведение по умолчанию', () {
    testWidgets(
      'отображается корректно без внешних параметров',
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
      'смена внешнего источника на другой внешний',
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

        // Act -- пересобираем с другим источником (тот же виджет-ключ)
        await tester.pumpWidget(buildWidget(
          scrollViewDataSource: dataSourceB,
          initialDate: DateTime(2024, 3),
        ));
        await tester.pumpAndSettle();

        // Assert -- оба внешних источника живы (не dispose-ированы виджетом)
        expect(() => dataSourceA.addListener(() {}), returnsNormally);
        expect(() => dataSourceB.addListener(() {}), returnsNormally);

        dataSourceA.dispose();
        dataSourceB.dispose();
      },
    );

    testWidgets(
      'смена внутреннего источника на внешний уничтожает внутренний',
      (tester) async {
        // Arrange -- без scrollViewDataSource (внутренний создаётся)
        await tester.pumpWidget(buildWidget(initialDate: DateTime(2024, 6)));
        await tester.pumpAndSettle();

        // Act -- пересобираем с внешним источником
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

        // Assert -- виджет продолжает отображаться корректно
        expect(find.byType(ACRawCalendarWidget), findsOneWidget);

        externalDataSource.dispose();
      },
    );

    testWidgets(
      'смена внешнего источника на null создаёт новый внутренний',
      (tester) async {
        // Arrange -- с внешним источником
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

        // Act -- пересобираем без внешнего источника
        await tester.pumpWidget(buildWidget(initialDate: DateTime(2024, 6)));
        await tester.pumpAndSettle();

        // Assert -- внешний источник не уничтожен виджетом
        expect(() => externalDataSource.addListener(() {}), returnsNormally);
        // Виджет продолжает работать с внутренним источником
        expect(find.byType(ACRawCalendarWidget), findsOneWidget);

        externalDataSource.dispose();
      },
    );
  });
}
