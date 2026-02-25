import 'package:flutter/material.dart';

import 'ac_scroll_view_controller.dart';
import 'ac_scroll_view_data_source.dart';

class ACScrollView<T> extends StatefulWidget {
  const ACScrollView({
    required this.controller,
    required this.dataSource,
    required this.itemExtentBuilder,
    required this.itemBuilder,
    this.onVisibleItemChanged,
    this.padding,
    this.physics,
    this.scrollDirection,
    super.key,
  });

  final ACScrollViewController<T> controller;

  /// Источник данных: управляет элементами, индексом и подгрузкой
  final ACScrollViewDataSource<T> dataSource;

  /// Возвращает высоту/ширину элемента — используется для вычисления scroll offset
  final double Function(T item) itemExtentBuilder;

  /// Builder для построения виджета элемента
  final Widget Function(BuildContext context, T item) itemBuilder;

  /// Вызывается при смене текущего видимого элемента
  final void Function(T item)? onVisibleItemChanged;

  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final Axis? scrollDirection;

  @override
  State<ACScrollView<T>> createState() => _ACScrollViewState<T>();
}

class _ACScrollViewState<T> extends State<ACScrollView<T>> {
  final _centerKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _attachDataSourceToController();

    widget.dataSource
      ..initialize()
      ..addListener(_onDataSourceChanged);
  }

  @override
  void didUpdateWidget(ACScrollView<T> old) {
    super.didUpdateWidget(old);

    if (
      old.controller != widget.controller ||
      old.dataSource != widget.dataSource
    ) {
      _attachDataSourceToController();
    }

    if (old.dataSource != widget.dataSource) {
      old.dataSource.removeListener(_onDataSourceChanged);
      widget.dataSource.addListener(_onDataSourceChanged);
    }
  }

  @override
  void dispose() {
    widget.dataSource.removeListener(_onDataSourceChanged);
    super.dispose();
  }

  void _attachDataSourceToController() =>
    widget.controller.attachDataSource(
      widget.dataSource,
      itemExtentBuilder: widget.itemExtentBuilder,
      onVisibleItemChanged: widget.onVisibleItemChanged,
    );

  void _onDataSourceChanged() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) =>
    CustomScrollView(
      physics: widget.physics,
      scrollDirection: widget.scrollDirection ?? Axis.vertical,
      controller: widget.controller,
      center: _centerKey,
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index >= widget.dataSource.beforeItems.length) return null;
              return widget.itemBuilder(context, widget.dataSource.beforeItems[index]);
            },
            childCount: widget.dataSource.beforeItems.length,
          ),
        ),
        SliverList(
          key: _centerKey,
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index >= widget.dataSource.afterItems.length) return null;
              return widget.itemBuilder(context, widget.dataSource.afterItems[index]);
            },
            childCount: widget.dataSource.afterItems.length,
          ),
        ),
      ],
    );
}
