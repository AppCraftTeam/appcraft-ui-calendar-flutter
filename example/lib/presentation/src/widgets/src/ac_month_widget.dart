import 'package:flutter/material.dart';

import '../../../../data/src/ac_calendar_repository.dart';
import '../../../presentation.dart';

class ACMonthWidget extends StatelessWidget {
  const ACMonthWidget({
    required this.monthDate,
    this.weekStart,
    this.theme,
    this.selectStyleForDay,
    this.shouldSelectDay,
    this.onSelectDay,
    super.key
  });

  final DateTime monthDate;
  final int? weekStart;
  final ACCalendarThemeData? theme;
  final ACDaySelectStyle? Function(DateTime day)? selectStyleForDay;
  final bool Function(DateTime day)? shouldSelectDay;
  final void Function(DateTime day)? onSelectDay;

  static const gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 8,
    crossAxisSpacing: 7,
    mainAxisSpacing: 8,
    childAspectRatio: 1
  );

  // static Size calculateItemSize(BoxConstraints constraints) {
  //   final maxWidth = constraints.maxWidth;
  //   final maxCrossAxisSpacing = (gridDelegate.crossAxisCount - 1) * gridDelegate.crossAxisSpacing;
  //   final itemWidth = (maxWidth - maxCrossAxisSpacing) / gridDelegate.crossAxisCount;
  //   final itemHeight = itemWidth / gridDelegate.childAspectRatio;
  //   return Size(itemWidth, itemHeight);
  // }

  // Size _calculateItemSize(double maxWidth) {
  //   final maxCrossAxisSpacing = (gridDelegate.crossAxisCount - 1) * gridDelegate.crossAxisSpacing;
  //   final itemWidth = (maxWidth - maxCrossAxisSpacing) / gridDelegate.crossAxisCount;
  //   final itemHeight = itemWidth / gridDelegate.childAspectRatio;
  //   return Size(itemWidth, itemHeight);
  // }

  static double calculateHeight(double width) {
    final maxCrossAxisSpacing = (gridDelegate.crossAxisCount - 1) * gridDelegate.crossAxisSpacing;
    final itemWidth = (width - maxCrossAxisSpacing) / gridDelegate.crossAxisCount;
    final itemHeight = itemWidth / gridDelegate.childAspectRatio;
    const mainAxisCount = 6;
    return (itemHeight * mainAxisCount) + (gridDelegate.mainAxisSpacing * (mainAxisCount - 1));
  }

  @override
  Widget build(BuildContext context) {
    final days = const ACCalendarRepository().getMonthDays(
      monthDate,
      weekStart: weekStart
    );

    return GridView.builder(
      shrinkWrap: true,
      itemCount: days.length,
      gridDelegate: gridDelegate,
      itemBuilder: (context, index) {
        final day = days[index];
    
        final shouldSelectDay = (this.shouldSelectDay?.call(day) ?? true) &&
          day.month == monthDate.month;
    
        return ACDayWidget(
          dayDate: day,
          theme: theme,
          active: shouldSelectDay,
          selectStyle: shouldSelectDay ?
            selectStyleForDay?.call(day) :
            null,
          onTap: shouldSelectDay ?
            () => onSelectDay?.call(day) :
            null
        );
      }
    );
  }
}