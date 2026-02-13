import 'package:flutter/material.dart';

abstract class ACMonthLayout {
  const ACMonthLayout();

  SliverGridDelegate get gridDelegate;
  double calculateHeight(double width);
}

class DefaultMonthLayout extends ACMonthLayout {
  const DefaultMonthLayout({
    this.gridDelegate = const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 7,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 1
    ),
    this.mainAxisCount = 6
  });

  @override
  final SliverGridDelegateWithFixedCrossAxisCount gridDelegate;

  final int mainAxisCount;

  @override
  double calculateHeight(double width) {
    final maxCrossAxisSpacing = (gridDelegate.crossAxisCount - 1) * gridDelegate.crossAxisSpacing;
    final itemWidth = (width - maxCrossAxisSpacing) / gridDelegate.crossAxisCount;
    final itemHeight = itemWidth / gridDelegate.childAspectRatio;
    return (itemHeight * mainAxisCount) + (gridDelegate.mainAxisSpacing * (mainAxisCount - 1));
  }
}
