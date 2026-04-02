import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Тесты для поддержки textScaler в ACDefaultMonthLayout.
///
/// TDD RED PHASE: эти тесты падают до реализации параметра textScaler
/// в конструкторе ACDefaultMonthLayout.
void main() {
  group('ACDefaultMonthLayout -- calculateHeight с textScaler', () {
    test(
      'при TextScaler.linear(2.0) возвращает удвоенную высоту элементов',
      () {
        // Arrange
        final layout = ACDefaultMonthLayout(
          crossAxisCount: 7,
          crossAxisSpacing: 0.0,
          mainAxisSpacing: 0.0,
          childAspectRatio: 1.0,
          mainAxisCount: 6,
          textScaler: const TextScaler.linear(2.0),
        );
        const width = 350.0;

        // Act
        final height = layout.calculateHeight(width);

        // Assert
        // itemWidth = 350 / 7 = 50
        // itemHeight = 50 / 1.0 = 50
        // scaledItemHeight = textScaler.scale(50) = 100
        // height = 100 * 6 + 0 = 600
        expect(height, closeTo(600.0, 0.001));
      },
    );

    test(
      'при TextScaler.linear(1.5) масштабирует высоту, но не spacing',
      () {
        // Arrange
        final layout = ACDefaultMonthLayout(
          crossAxisCount: 7,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 1.0,
          mainAxisCount: 4,
          textScaler: const TextScaler.linear(1.5),
        );
        const width = 400.0;

        // Act
        final height = layout.calculateHeight(width);

        // Assert
        // itemWidth = (400 - 6*8) / 7 = 352 / 7
        // itemHeight = 352/7
        // scaledItemHeight = 1.5 * (352/7)
        // height = scaledItemHeight * 4 + 10 * 3
        final expectedItemWidth = (width - 6 * 8.0) / 7;
        final expectedItemHeight = expectedItemWidth / 1.0;
        final expectedScaledHeight = 1.5 * expectedItemHeight;
        final expectedHeight = (expectedScaledHeight * 4) + (10.0 * 3);

        expect(height, closeTo(expectedHeight, 0.001));
      },
    );

    test(
      'при TextScaler.noScaling результат совпадает с layout без textScaler',
      () {
        // Arrange
        final layoutWithScaler = ACDefaultMonthLayout(
          crossAxisCount: 7,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 1.0,
          mainAxisCount: 6,
          textScaler: TextScaler.noScaling,
        );
        final layoutWithout = ACDefaultMonthLayout(
          crossAxisCount: 7,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 1.0,
          mainAxisCount: 6,
        );
        const width = 400.0;

        // Act
        final heightWithScaler = layoutWithScaler.calculateHeight(width);
        final heightWithout = layoutWithout.calculateHeight(width);

        // Assert
        expect(heightWithScaler, closeTo(heightWithout, 0.001));
      },
    );
  });

  group('ACDefaultMonthLayout -- shouldRelayout с textScaler', () {
    test(
      'возвращает true при изменении textScaler',
      () {
        // Arrange
        final layout1 = ACDefaultMonthLayout(
          textScaler: TextScaler.noScaling,
        );
        final layout2 = ACDefaultMonthLayout(
          textScaler: const TextScaler.linear(2.0),
        );

        // Act
        final result = layout1.shouldRelayout(layout2);

        // Assert
        expect(result, isTrue);
      },
    );

    test(
      'возвращает false при одинаковом textScaler',
      () {
        // Arrange
        final layout1 = ACDefaultMonthLayout(
          textScaler: const TextScaler.linear(1.5),
        );
        final layout2 = ACDefaultMonthLayout(
          textScaler: const TextScaler.linear(1.5),
        );

        // Act
        final result = layout1.shouldRelayout(layout2);

        // Assert
        expect(result, isFalse);
      },
    );

    test(
      'возвращает false при обоих TextScaler.noScaling',
      () {
        // Arrange
        final layout1 = ACDefaultMonthLayout(
          textScaler: TextScaler.noScaling,
        );
        final layout2 = ACDefaultMonthLayout(
          textScaler: TextScaler.noScaling,
        );

        // Act
        final result = layout1.shouldRelayout(layout2);

        // Assert
        expect(result, isFalse);
      },
    );
  });

  group('ACDefaultMonthLayout -- performLayout с textScaler', () {
    testWidgets(
      'с TextScaler.linear(2.0) элементы размещаются с увеличенной высотой',
      (tester) async {
        // Arrange
        const childCount = 14; // 2 строки по 7
        final layout = ACDefaultMonthLayout(
          crossAxisCount: 7,
          crossAxisSpacing: 0.0,
          mainAxisSpacing: 0.0,
          childAspectRatio: 1.0,
          mainAxisCount: 2,
          textScaler: const TextScaler.linear(2.0),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 350,
                height: 400,
                child: CustomMultiChildLayout(
                  delegate: layout,
                  children: List.generate(
                    childCount,
                    (i) => LayoutId(
                      id: i,
                      child: const SizedBox(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Assert
        // itemWidth = 350 / 7 = 50
        // scaledItemHeight = 2.0 * 50 = 100
        // Второй ряд (index 7) начинается с y = 100
        final firstRowChild = tester.getTopLeft(
          find.byType(SizedBox).at(1),
        );
        final secondRowChild = tester.getTopLeft(
          find.byType(SizedBox).at(8),
        );

        final yDifference = secondRowChild.dy - firstRowChild.dy;
        expect(yDifference, closeTo(100.0, 0.5));
      },
    );
  });
}
