import 'package:flutter/material.dart';

import '../../../../../presentation.dart';

class ACMonthWidget extends StatelessWidget {

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
    CustomMultiChildLayout(
      delegate: layout,
      children: [
        for (int i = 0; i < childrenDelegate.itemCount; i++)
          LayoutId(
            id: i,
            child: childrenDelegate.buildItem(context, i)
          ),
      ],
    );
}