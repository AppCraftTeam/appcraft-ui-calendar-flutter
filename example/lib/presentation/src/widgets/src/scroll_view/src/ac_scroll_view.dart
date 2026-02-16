import 'package:flutter/material.dart';

import 'ac_scroll_view_controller.dart';

class ACScrollView<T> extends StatefulWidget {
  const ACScrollView({
    required this.controller,
    required this.itemBuilder,
    this.padding,
    this.physics,
    this.scrollDirection,
    super.key,
  });

  /// Контроллер для списка (управляет и данными, и прокруткой)
  final ACScrollViewController<T> controller;

  /// Builder для построения элементов списка
  final Widget Function(BuildContext context, T item) itemBuilder;

  /// Отступы для списка
  final EdgeInsetsGeometry? padding;

  /// Физика прокрутки
  final ScrollPhysics? physics;

  /// Направление прокрутки (если null, используется Axis.vertical)
  final Axis? scrollDirection;

  @override
  State<ACScrollView<T>> createState() => _ACScrollViewState<T>();
}

class _ACScrollViewState<T> extends State<ACScrollView<T>> {
  final _centerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Настраиваем слушатель для обновления UI
    widget.controller.addListener(_onDataChanged);
  }

  @override
  void didUpdateWidget(ACScrollView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Обновляем controller если изменился
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onDataChanged);
      widget.controller.addListener(_onDataChanged);
    }
  }

  void _onDataChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onDataChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: widget.physics,
      scrollDirection: widget.scrollDirection ?? Axis.vertical,
      controller: widget.controller,
      center: _centerKey,
      slivers: [
        // Элементы ДО центра (растут вверх, в отрицательном направлении)
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final item = widget.controller.beforeItemAt(index);
              if (item == null) return null;
              return widget.itemBuilder(context, item);
            },
            childCount: widget.controller.beforeItemCount,
          ),
        ),

        // Элементы ОТ центра и ПОСЛЕ (растут вниз, в положительном направлении)
        SliverList(
          key: _centerKey,
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final item = widget.controller.afterItemAt(index);
              if (item == null) return null;
              return widget.itemBuilder(context, item);
            },
            childCount: widget.controller.afterItemCount,
          ),
        ),
      ],
    );
  }
}