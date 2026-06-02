import 'package:flutter/material.dart';

/// Abstract layout for the monthly calendar view.
///
/// Extends [MultiChildLayoutDelegate] and adds a [calculateHeight] method
/// for computing the grid height for a given width.
abstract class ACMonthLayout extends MultiChildLayoutDelegate {
  ACMonthLayout();

  /// Computes the month grid height for the given [width].
  double calculateHeight(double width);
}

/// Standard month layout as a uniform grid of days.
///
/// Places days in a [mainAxisCount] × [crossAxisCount] grid (rows × columns).
/// Defaults to 6 rows by 7 columns (the standard month view).
class ACDefaultMonthLayout extends ACMonthLayout {
  ACDefaultMonthLayout({
    this.crossAxisCount = 7,
    this.crossAxisSpacing = 8.0,
    this.mainAxisSpacing = 8.0,
    this.childAspectRatio = 1.0,
    this.mainAxisCount = 6,
  });

  /// Number of columns (days in a week). Defaults to 7.
  final int crossAxisCount;

  /// Horizontal spacing between cells.
  final double crossAxisSpacing;

  /// Vertical spacing between rows.
  final double mainAxisSpacing;

  /// Ratio of cell width to height. Defaults to 1.0 (square).
  final double childAspectRatio;

  /// Number of rows (weeks) in the month.
  final int mainAxisCount;

  /// Preset layout for a 4-week month.
  static final mainAxisCount4 = ACDefaultMonthLayout(mainAxisCount: 4);

  /// Preset layout for a 5-week month.
  static final mainAxisCount5 = ACDefaultMonthLayout(mainAxisCount: 5);

  /// Preset layout for a 6-week month.
  static final mainAxisCount6 = ACDefaultMonthLayout(mainAxisCount: 6);

  @override
  double calculateHeight(double width) {
    final maxCrossAxisSpacing = (crossAxisCount - 1) * crossAxisSpacing;
    final itemWidth = (width - maxCrossAxisSpacing) / crossAxisCount;
    final itemHeight = itemWidth / childAspectRatio;
    return (itemHeight * mainAxisCount) +
        (mainAxisSpacing * (mainAxisCount - 1));
  }

  @override
  void performLayout(Size size) {
    // Compute the size of a single item
    final maxCrossAxisSpacing = (crossAxisCount - 1) * crossAxisSpacing;
    final itemWidth = (size.width - maxCrossAxisSpacing) / crossAxisCount;
    final itemHeight = itemWidth / childAspectRatio;

    // Place each item at its corresponding grid position
    var childIndex = 0;
    while (hasChild(childIndex)) {
      final row = childIndex ~/ crossAxisCount;
      final col = childIndex % crossAxisCount;

      final x = col * (itemWidth + crossAxisSpacing);
      final y = row * (itemHeight + mainAxisSpacing);

      layoutChild(
          childIndex, BoxConstraints.tight(Size(itemWidth, itemHeight)));
      positionChild(childIndex, Offset(x, y));

      childIndex++;
    }
  }

  @override
  bool shouldRelayout(ACDefaultMonthLayout oldDelegate) =>
      crossAxisCount != oldDelegate.crossAxisCount ||
      crossAxisSpacing != oldDelegate.crossAxisSpacing ||
      mainAxisSpacing != oldDelegate.mainAxisSpacing ||
      childAspectRatio != oldDelegate.childAspectRatio ||
      mainAxisCount != oldDelegate.mainAxisCount;
}
