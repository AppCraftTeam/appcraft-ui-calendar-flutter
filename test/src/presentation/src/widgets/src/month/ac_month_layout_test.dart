import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ACDefaultMonthLayout -- calculateHeight (обратная совместимость)', () {
    test(
      'возвращает корректную высоту для стандартных параметров',
      () {
        // Arrange
        final layout = ACDefaultMonthLayout(
          crossAxisCount: 7,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 1.0,
          mainAxisCount: 6,
        );
        const width = 400.0;

        // Act
        final height = layout.calculateHeight(width);

        // Assert
        // itemWidth = (400 - 6*8) / 7 = 352 / 7
        // itemHeight = itemWidth / 1.0
        // height = (itemHeight * 6) + (8.0 * 5)
        final expectedItemWidth = (width - 6 * 8.0) / 7;
        final expectedItemHeight = expectedItemWidth / 1.0;
        final expectedHeight = (expectedItemHeight * 6) + (8.0 * 5);

        expect(height, closeTo(expectedHeight, 0.001));
      },
    );

    test(
      'корректно вычисляет высоту при childAspectRatio != 1.0',
      () {
        // Arrange
        final layout = ACDefaultMonthLayout(
          crossAxisCount: 7,
          crossAxisSpacing: 0.0,
          mainAxisSpacing: 0.0,
          childAspectRatio: 2.0,
          mainAxisCount: 5,
        );
        const width = 350.0;

        // Act
        final height = layout.calculateHeight(width);

        // Assert
        // itemWidth = 350 / 7 = 50
        // itemHeight = 50 / 2.0 = 25
        // height = 25 * 5 + 0 = 125
        expect(height, closeTo(125.0, 0.001));
      },
    );

    test(
      'возвращает корректную высоту при нулевых отступах',
      () {
        // Arrange
        final layout = ACDefaultMonthLayout(
          crossAxisCount: 7,
          crossAxisSpacing: 0.0,
          mainAxisSpacing: 0.0,
          childAspectRatio: 1.0,
          mainAxisCount: 6,
        );
        const width = 350.0;

        // Act
        final height = layout.calculateHeight(width);

        // Assert
        // itemWidth = 350 / 7 = 50, itemHeight = 50
        // height = 50 * 6 + 0 = 300
        expect(height, closeTo(300.0, 0.001));
      },
    );
  });

  group('ACDefaultMonthLayout -- shouldRelayout (обратная совместимость)', () {
    test(
      'возвращает false при одинаковых параметрах',
      () {
        // Arrange
        final layout1 = ACDefaultMonthLayout(
          crossAxisCount: 7,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 1.0,
          mainAxisCount: 6,
        );
        final layout2 = ACDefaultMonthLayout(
          crossAxisCount: 7,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 1.0,
          mainAxisCount: 6,
        );

        // Act
        final result = layout1.shouldRelayout(layout2);

        // Assert
        expect(result, isFalse);
      },
    );

    test(
      'возвращает true при различном crossAxisCount',
      () {
        // Arrange
        final layout1 = ACDefaultMonthLayout(crossAxisCount: 7);
        final layout2 = ACDefaultMonthLayout(crossAxisCount: 5);

        // Act
        final result = layout1.shouldRelayout(layout2);

        // Assert
        expect(result, isTrue);
      },
    );

    test(
      'возвращает true при различном mainAxisCount',
      () {
        // Arrange
        final layout1 = ACDefaultMonthLayout(mainAxisCount: 6);
        final layout2 = ACDefaultMonthLayout(mainAxisCount: 5);

        // Act
        final result = layout1.shouldRelayout(layout2);

        // Assert
        expect(result, isTrue);
      },
    );

    test(
      'возвращает true при различном crossAxisSpacing',
      () {
        // Arrange
        final layout1 = ACDefaultMonthLayout(crossAxisSpacing: 8.0);
        final layout2 = ACDefaultMonthLayout(crossAxisSpacing: 4.0);

        // Act
        final result = layout1.shouldRelayout(layout2);

        // Assert
        expect(result, isTrue);
      },
    );

    test(
      'возвращает true при различном mainAxisSpacing',
      () {
        // Arrange
        final layout1 = ACDefaultMonthLayout(mainAxisSpacing: 8.0);
        final layout2 = ACDefaultMonthLayout(mainAxisSpacing: 0.0);

        // Act
        final result = layout1.shouldRelayout(layout2);

        // Assert
        expect(result, isTrue);
      },
    );

    test(
      'возвращает true при различном childAspectRatio',
      () {
        // Arrange
        final layout1 = ACDefaultMonthLayout(childAspectRatio: 1.0);
        final layout2 = ACDefaultMonthLayout(childAspectRatio: 2.0);

        // Act
        final result = layout1.shouldRelayout(layout2);

        // Assert
        expect(result, isTrue);
      },
    );
  });

  group('ACDefaultMonthLayout -- статические пресеты', () {
    test(
      'mainAxisCount4 совпадает с ручным созданием layout(mainAxisCount: 4)',
      () {
        // Arrange
        final preset = ACDefaultMonthLayout.mainAxisCount4;

        // Act
        final heightPreset = preset.calculateHeight(350.0);

        // Assert
        final reference = ACDefaultMonthLayout(mainAxisCount: 4);
        final heightReference = reference.calculateHeight(350.0);

        expect(heightPreset, closeTo(heightReference, 0.001));
      },
    );

    test(
      'mainAxisCount5 совпадает с ручным созданием layout(mainAxisCount: 5)',
      () {
        // Arrange
        final preset = ACDefaultMonthLayout.mainAxisCount5;

        // Act
        final heightPreset = preset.calculateHeight(350.0);

        // Assert
        final reference = ACDefaultMonthLayout(mainAxisCount: 5);
        final heightReference = reference.calculateHeight(350.0);

        expect(heightPreset, closeTo(heightReference, 0.001));
      },
    );

    test(
      'mainAxisCount6 совпадает с ручным созданием layout(mainAxisCount: 6)',
      () {
        // Arrange
        final preset = ACDefaultMonthLayout.mainAxisCount6;

        // Act
        final heightPreset = preset.calculateHeight(350.0);

        // Assert
        final reference = ACDefaultMonthLayout(mainAxisCount: 6);
        final heightReference = reference.calculateHeight(350.0);

        expect(heightPreset, closeTo(heightReference, 0.001));
      },
    );

    test(
      'mainAxisCount4 имеет mainAxisCount равный 4',
      () {
        expect(ACDefaultMonthLayout.mainAxisCount4.mainAxisCount, equals(4));
      },
    );

    test(
      'mainAxisCount5 имеет mainAxisCount равный 5',
      () {
        expect(ACDefaultMonthLayout.mainAxisCount5.mainAxisCount, equals(5));
      },
    );

    test(
      'mainAxisCount6 имеет mainAxisCount равный 6',
      () {
        expect(ACDefaultMonthLayout.mainAxisCount6.mainAxisCount, equals(6));
      },
    );
  });

  group('ACDefaultMonthLayout -- performLayout (обратная совместимость)', () {
    testWidgets(
      'элементы размещаются со стандартной высотой при aspectRatio 1:1',
      (tester) async {
        // Arrange
        const childCount = 14; // 2 строки по 7
        final layout = ACDefaultMonthLayout(
          crossAxisCount: 7,
          crossAxisSpacing: 0.0,
          mainAxisSpacing: 0.0,
          childAspectRatio: 1.0,
          mainAxisCount: 2,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 350,
                height: 200,
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
        // itemWidth = 350 / 7 = 50, itemHeight = 50
        // Второй ряд (index 7) начинается с y = 50
        final firstRowChild = tester.getTopLeft(
          find.byType(SizedBox).at(1),
        );
        final secondRowChild = tester.getTopLeft(
          find.byType(SizedBox).at(8),
        );

        final yDifference = secondRowChild.dy - firstRowChild.dy;
        expect(yDifference, closeTo(50.0, 0.5));
      },
    );

    testWidgets(
      'элементы размещаются с учётом mainAxisSpacing',
      (tester) async {
        // Arrange
        const childCount = 14;
        final layout = ACDefaultMonthLayout(
          crossAxisCount: 7,
          crossAxisSpacing: 0.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 1.0,
          mainAxisCount: 2,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 350,
                height: 200,
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
        // itemWidth = 350 / 7 = 50, itemHeight = 50
        // Второй ряд начинается с y = 50 + 10 = 60
        final firstRowChild = tester.getTopLeft(
          find.byType(SizedBox).at(1),
        );
        final secondRowChild = tester.getTopLeft(
          find.byType(SizedBox).at(8),
        );

        final yDifference = secondRowChild.dy - firstRowChild.dy;
        expect(yDifference, closeTo(60.0, 0.5));
      },
    );
  });
}
