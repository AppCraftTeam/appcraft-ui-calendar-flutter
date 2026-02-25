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
  T? _lastCurrentItem;

  ACScrollViewDataSource<T> get _dataSource => widget.dataSource;

  // ─── Lifecycle ────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    widget.controller.attachDataSource(_dataSource, widget.itemExtentBuilder);
    _dataSource.initialize();
    _lastCurrentItem = _dataSource.currentItem;
    _syncControllerState();
    _dataSource.addListener(_onDataSourceChanged);
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(ACScrollView<T> old) {
    super.didUpdateWidget(old);
    if (old.controller != widget.controller) {
      old.controller.removeListener(_onControllerChanged);
      widget.controller
        ..attachDataSource(_dataSource, widget.itemExtentBuilder)
        ..addListener(_onControllerChanged);
    }
    if (old.dataSource != widget.dataSource) {
      old.dataSource.removeListener(_onDataSourceChanged);
      widget.dataSource.addListener(_onDataSourceChanged);
      widget.controller.attachDataSource(widget.dataSource, widget.itemExtentBuilder);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    _dataSource.removeListener(_onDataSourceChanged);
    super.dispose();
  }

  void _onDataSourceChanged() {
    if (!mounted) return;
    final newItem = _dataSource.currentItem;
    if (newItem != _lastCurrentItem) {
      _lastCurrentItem = newItem;
      _syncControllerState();
      widget.onVisibleItemChanged?.call(newItem);
    }
    setState(() {});
  }

  // ─── Controller listener ──────────────────────────────────────────────────

  void _onControllerChanged() {
    if (!mounted) return;
    if (widget.controller.hasClients) {
      _onScroll(widget.controller.position.pixels);
    }
  }

  // ─── Scroll handling ──────────────────────────────────────────────────────

  void _onScroll(double offset) {
    if (_updateCurrentIndex(offset)) {
      _lastCurrentItem = _dataSource.currentItem;
      _syncControllerState();
      widget.onVisibleItemChanged?.call(_lastCurrentItem as T);
    }
    _dataSource.loadMore();
  }

  bool _updateCurrentIndex(double offset) {
    final newIndex = offset < 0
        ? _findIndexByOffset(offset, _dataSource.beforeItems, true)
        : _findIndexByOffset(offset, _dataSource.afterItems, false);
    return _dataSource.setCurrentIndex(newIndex);
  }

  // ─── Controller state sync ────────────────────────────────────────────────

  void _syncControllerState() {
    widget.controller.updateScrollState(
      currentItem: _dataSource.currentItem,
      shouldBefore: _dataSource.shouldBefore,
      shouldAfter: _dataSource.shouldAfter,
    );
  }

  // ─── Extent / offset helpers ──────────────────────────────────────────────

  int _findIndexByOffset(double offset, List<T> items, bool isBefore) {
    double accumulated = 0;
    for (var i = 0; i < items.length; i++) {
      final extent = widget.controller.getExtent(items[i]);
      if (isBefore) {
        accumulated -= extent;
        if (accumulated <= offset) return -(i + 1);
      } else {
        accumulated += extent;
        if (accumulated > offset.abs()) return i;
      }
    }
    return isBefore ? -items.length : items.length - 1;
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) => CustomScrollView(
        physics: widget.physics,
        scrollDirection: widget.scrollDirection ?? Axis.vertical,
        controller: widget.controller,
        center: _centerKey,
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index >= _dataSource.beforeItems.length) return null;
                return widget.itemBuilder(context, _dataSource.beforeItems[index]);
              },
              childCount: _dataSource.beforeItems.length,
            ),
          ),
          SliverList(
            key: _centerKey,
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index >= _dataSource.afterItems.length) return null;
                return widget.itemBuilder(context, _dataSource.afterItems[index]);
              },
              childCount: _dataSource.afterItems.length,
            ),
          ),
        ],
      );
}
