import 'package:flutter/material.dart';

abstract class ACMonthLayout extends MultiChildLayoutDelegate {
  ACMonthLayout();

  double calculateHeight(double width);
}

class DefaultMonthLayout extends ACMonthLayout {
  DefaultMonthLayout({
    this.crossAxisCount = 7,
    this.crossAxisSpacing = 8.0,
    this.mainAxisSpacing = 8.0,
    this.childAspectRatio = 1.0,
    this.mainAxisCount = 6,
  });

  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double childAspectRatio;
  final int mainAxisCount;

  static final mainAxisCount4 = DefaultMonthLayout(mainAxisCount: 4);
  static final mainAxisCount5 = DefaultMonthLayout(mainAxisCount: 5);
  static final mainAxisCount6 = DefaultMonthLayout(mainAxisCount: 6);

  @override
  double calculateHeight(double width) {
    final maxCrossAxisSpacing = (crossAxisCount - 1) * crossAxisSpacing;
    final itemWidth = (width - maxCrossAxisSpacing) / crossAxisCount;
    final itemHeight = itemWidth / childAspectRatio;
    return (itemHeight * mainAxisCount) + (mainAxisSpacing * (mainAxisCount - 1));
  }

  @override
  void performLayout(Size size) {
    // Вычисляем размер одного элемента
    final maxCrossAxisSpacing = (crossAxisCount - 1) * crossAxisSpacing;
    final itemWidth = (size.width - maxCrossAxisSpacing) / crossAxisCount;
    final itemHeight = itemWidth / childAspectRatio;

    // Размещаем каждый элемент в соответствующей позиции сетки
    var childIndex = 0;
    while (hasChild(childIndex)) {
      final row = childIndex ~/ crossAxisCount;
      final col = childIndex % crossAxisCount;

      final x = col * (itemWidth + crossAxisSpacing);
      final y = row * (itemHeight + mainAxisSpacing);

      layoutChild(childIndex, BoxConstraints.tight(Size(itemWidth, itemHeight)));
      positionChild(childIndex, Offset(x, y));

      childIndex++;
    }
  }

  @override
  bool shouldRelayout(DefaultMonthLayout oldDelegate) =>
    crossAxisCount != oldDelegate.crossAxisCount ||
    crossAxisSpacing != oldDelegate.crossAxisSpacing ||
    mainAxisSpacing != oldDelegate.mainAxisSpacing ||
    childAspectRatio != oldDelegate.childAspectRatio ||
    mainAxisCount != oldDelegate.mainAxisCount;
}
