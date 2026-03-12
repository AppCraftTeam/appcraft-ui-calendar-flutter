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
    DateTime? initialMonth,
  }) =>
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 400,
            child: ACPagesCalendarCard(
              range: range,
              initialMonth: initialMonth,
              scrollViewController: scrollViewController,
              scrollViewDataSource: scrollViewDataSource,
            ),
          ),
        ),
      );

  group('ACPagesCalendarCard — внешний scrollViewController', () {
    testWidgets('используется виджетом: jumpToItem меняет отображаемый месяц',
        (tester) async {
      final controller = ACScrollViewController<DateTime>();
      final initialMonth = DateTime(2024, 6);
      final targetMonth = DateTime(2024, 9);

      await tester.pumpWidget(buildWidget(
        scrollViewController: controller,
        initialMonth: initialMonth,
      ));
      await tester.pumpAndSettle();

      controller.jumpToItem(targetMonth);
      await tester.pump();

      final header = tester.widget<ACPagesCalendarHeader>(
        find.byType(ACPagesCalendarHeader),
      );
      expect(header.monthDate.year, 2024);
      expect(header.monthDate.month, 9);

      controller.dispose();
    });

    testWidgets('не уничтожается при dispose виджета', (tester) async {
      final controller = ACScrollViewController<DateTime>();

      await tester.pumpWidget(buildWidget(scrollViewController: controller));
      await tester.pumpAndSettle();

      await tester.pumpWidget(const MaterialApp(home: Scaffold()));

      expect(() => controller.addListener(() {}), returnsNormally);

      controller.dispose();
    });
  });

  group('ACPagesCalendarCard — внешний scrollViewDataSource', () {
    testWidgets('используется виджетом: ACScrollView инициализирует его',
        (tester) async {
      final fixedMonth = DateTime(2024, 3);
      final dataSource = ACDefaultScrollViewDataSource<DateTime>(
        initialItem: fixedMonth,
        onBefore: (_) => null,
        onAfter: (_) => null,
      );

      await tester.pumpWidget(buildWidget(
        scrollViewDataSource: dataSource,
        initialMonth: fixedMonth,
      ));
      await tester.pumpAndSettle();

      expect(dataSource.currentItem, equals(fixedMonth));

      dataSource.dispose();
    });

    testWidgets('не уничтожается при dispose виджета', (tester) async {
      final dataSource = ACDefaultScrollViewDataSource<DateTime>(
        initialItem: DateTime(2024, 6),
        onBefore: (m) => DateTime(m.year, m.month - 1),
        onAfter: (m) => DateTime(m.year, m.month + 1),
      );

      await tester.pumpWidget(buildWidget(scrollViewDataSource: dataSource));
      await tester.pumpAndSettle();

      await tester.pumpWidget(const MaterialApp(home: Scaffold()));

      expect(() => dataSource.addListener(() {}), returnsNormally);

      dataSource.dispose();
    });
  });

  group('ACPagesCalendarCard — поведение по умолчанию', () {
    testWidgets('отображается корректно без внешних параметров',
        (tester) async {
      await tester.pumpWidget(buildWidget(initialMonth: DateTime(2024, 6)));
      await tester.pumpAndSettle();

      expect(find.byType(ACPagesCalendarCard), findsOneWidget);
      final header = tester.widget<ACPagesCalendarHeader>(
        find.byType(ACPagesCalendarHeader),
      );
      expect(header.monthDate.year, 2024);
      expect(header.monthDate.month, 6);
    });
  });
}
