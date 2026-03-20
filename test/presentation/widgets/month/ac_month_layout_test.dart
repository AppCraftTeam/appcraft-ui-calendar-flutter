import 'package:appcraft_ui_calendar_flutter/src/widgets/ac_month_layout.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ACDefaultMonthLayout.calculateHeight', () {
    test('correct formula for width 350 with defaults', () {
      final layout = ACDefaultMonthLayout();
      final height = layout.calculateHeight(350);

      // cellWidth = (350 - 6*8) / 7 = (350 - 48) / 7 = 302 / 7 ≈ 43.14
      // cellHeight = cellWidth / 1.0 = 43.14
      // height = 6 * 43.14 + 5 * 8 = 258.86 + 40 = 298.86
      const expectedCellWidth = (350 - 6 * 8.0) / 7;
      const expectedHeight = 6 * expectedCellWidth + 5 * 8.0;

      expect(height, closeTo(expectedHeight, 0.01));
    });

    test('accounts for mainAxisSpacing and crossAxisSpacing', () {
      final layout = ACDefaultMonthLayout(
        mainAxisSpacing: 4,
        crossAxisSpacing: 2,
      );
      final height = layout.calculateHeight(350);

      const cellWidth = (350 - 6 * 2.0) / 7;
      const expectedHeight = 6 * cellWidth + 5 * 4.0;

      expect(height, closeTo(expectedHeight, 0.01));
    });

    test('correct with childAspectRatio != 1', () {
      final layout = ACDefaultMonthLayout(childAspectRatio: 0.5);
      final height = layout.calculateHeight(350);

      const cellWidth = (350 - 6 * 8.0) / 7;
      const cellHeight = cellWidth / 0.5;
      const expectedHeight = 6 * cellHeight + 5 * 8.0;

      expect(height, closeTo(expectedHeight, 0.01));
    });
  });

  group('ACDefaultMonthLayout.shouldRelayout', () {
    test('returns true when parameters differ', () {
      final layout1 = ACDefaultMonthLayout(mainAxisCount: 5);
      final layout2 = ACDefaultMonthLayout(mainAxisCount: 6);

      expect(layout2.shouldRelayout(layout1), isTrue);
    });

    test('returns false when parameters are the same', () {
      final layout1 = ACDefaultMonthLayout();
      final layout2 = ACDefaultMonthLayout();

      expect(layout2.shouldRelayout(layout1), isFalse);
    });
  });

  group('ACDefaultMonthLayout static presets', () {
    test('mainAxisCount4 has 4 rows', () {
      expect(ACDefaultMonthLayout.mainAxisCount4.mainAxisCount, equals(4));
    });

    test('mainAxisCount5 has 5 rows', () {
      expect(ACDefaultMonthLayout.mainAxisCount5.mainAxisCount, equals(5));
    });

    test('mainAxisCount6 has 6 rows', () {
      expect(ACDefaultMonthLayout.mainAxisCount6.mainAxisCount, equals(6));
    });
  });
}
