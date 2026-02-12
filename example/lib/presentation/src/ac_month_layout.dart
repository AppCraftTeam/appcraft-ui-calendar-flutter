import 'package:flutter/material.dart';

abstract class ACMonthLayout {
  const ACMonthLayout();

  SliverGridDelegate get gridDelegate;
  double calculateHeight(double width);
}

class ACDefaultMonthLayout extends ACMonthLayout {
  const ACDefaultMonthLayout();

  @override
  SliverGridDelegate get gridDelegate => const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 8,
    crossAxisSpacing: 7,
    mainAxisSpacing: 8,
    childAspectRatio: 1
  );

  @override
  double calculateHeight(double width) {
    final gridDelegateWithFixed = gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
    final maxCrossAxisSpacing = (gridDelegateWithFixed.crossAxisCount - 1) * gridDelegateWithFixed.crossAxisSpacing;
    final itemWidth = (width - maxCrossAxisSpacing) / gridDelegateWithFixed.crossAxisCount;
    final itemHeight = itemWidth / gridDelegateWithFixed.childAspectRatio;
    const mainAxisCount = 6;
    return (itemHeight * mainAxisCount) + (gridDelegateWithFixed.mainAxisSpacing * (mainAxisCount - 1));
  }
}
