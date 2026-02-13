import 'package:flutter/material.dart';

import '../../../../../../domain/src/ac_date_range.dart';
import '../../../../../presentation.dart';

class ACMonthWidget extends StatelessWidget {

  /// Создает виджет месяца календаря с дефолтным делегатом
  // ACMonthWidget({
  //   required DateTime monthDate,
  //   required ACDateRange range,
  //   int? weekStart,
  //   ACDaySelectState? Function(DateTime day)? onSelectStateForDay,
  //   void Function(DateTime day)? onSelectDay,
  //   ACDayThemeData? dayTheme,
  //   this.layout = const ACDefaultMonthLayout(),
  //   super.key
  // }) : childrenDelegate = ACMonthDefaultChildDelegate(
  //   monthDate: monthDate,
  //   range: range,
  //   weekStart: weekStart,
  //   onSelectStateForDay: onSelectStateForDay,
  //   onSelectDay: onSelectDay,
  //   dayTheme: dayTheme,
  // );
  
  const ACMonthWidget({
    required this.layout,
    required this.childrenDelegate,
    super.key
  });

  /// Компоновка (layout) месяца, определяющая расположение элементов в сетке
  final ACMonthLayout layout;

  /// Делегат для построения дочерних элементов месяца (дней календаря)
  final ACMonthChildDelegate childrenDelegate;

  @override
  Widget build(BuildContext context) =>
    GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: layout.gridDelegate,
      itemCount: childrenDelegate.itemCount,
      itemBuilder: childrenDelegate.buildItem
    );
}