import 'package:flutter/material.dart';

import '../../../../../presentation.dart';

class ACMonthWidget extends StatelessWidget {

  const ACMonthWidget({
    required this.layout,
    required this.childrenDelegate,
    @Deprecated('GridView с shrinkWrap: true имеет плохую производительность. '
        'Используйте новую реализацию на CustomMultiChildLayout по умолчанию.')
    this.useGridView = false,
    super.key
  });

  /// Компоновка (layout) месяца, определяющая расположение элементов в сетке
  final ACMonthLayout layout;

  /// Делегат для построения дочерних элементов месяца (дней календаря)
  final ACMonthChildDelegate childrenDelegate;

  /// [DEPRECATED] Использовать старую реализацию на GridView.builder
  ///
  /// По умолчанию false - используется оптимизированная реализация на CustomMultiChildLayout.
  /// Установите true только для обратной совместимости.
  @Deprecated('GridView с shrinkWrap: true имеет плохую производительность. '
      'Используйте новую реализацию на CustomMultiChildLayout по умолчанию.')
  final bool useGridView;

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use_from_same_package
    if (useGridView) {
      // Старая реализация на GridView (deprecated)
      return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: layout.gridDelegate,
        itemCount: childrenDelegate.itemCount,
        itemBuilder: childrenDelegate.buildItem
      );
    }

    // Новая оптимизированная реализация на CustomMultiChildLayout
    return CustomMultiChildLayout(
      delegate: _ACMonthLayoutDelegate(
        layout: layout,
        childCount: childrenDelegate.itemCount,
      ),
      children: [
        for (int i = 0; i < childrenDelegate.itemCount; i++)
          LayoutId(
            id: i,
            child: childrenDelegate.buildItem(context, i) ?? const SizedBox.shrink(),
          ),
      ],
    );
  }
}

/// Делегат для CustomMultiChildLayout, который размещает дочерние элементы в сетке
///
/// Оптимизация: использует CustomMultiChildLayout вместо GridView для избежания
/// overhead при вычислении размеров через shrinkWrap: true
class _ACMonthLayoutDelegate extends MultiChildLayoutDelegate {
  _ACMonthLayoutDelegate({
    required this.layout,
    required this.childCount,
  });

  final ACMonthLayout layout;
  final int childCount;

  @override
  void performLayout(Size size) {
    final gridDelegate = layout.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;

    final crossAxisCount = gridDelegate.crossAxisCount;
    final crossAxisSpacing = gridDelegate.crossAxisSpacing;
    final mainAxisSpacing = gridDelegate.mainAxisSpacing;
    final childAspectRatio = gridDelegate.childAspectRatio;

    // Вычисляем размер одного элемента
    final maxCrossAxisSpacing = (crossAxisCount - 1) * crossAxisSpacing;
    final itemWidth = (size.width - maxCrossAxisSpacing) / crossAxisCount;
    final itemHeight = itemWidth / childAspectRatio;

    // Размещаем каждый элемент в соответствующей позиции сетки
    for (int i = 0; i < childCount; i++) {
      if (hasChild(i)) {
        final row = i ~/ crossAxisCount;
        final col = i % crossAxisCount;

        final x = col * (itemWidth + crossAxisSpacing);
        final y = row * (itemHeight + mainAxisSpacing);

        layoutChild(i, BoxConstraints.tight(Size(itemWidth, itemHeight)));
        positionChild(i, Offset(x, y));
      }
    }
  }

  @override
  bool shouldRelayout(_ACMonthLayoutDelegate oldDelegate) =>
    layout != oldDelegate.layout || childCount != oldDelegate.childCount;
}