import 'package:flutter/widgets.dart';

import 'ac_scroll_view_data_source.dart';

/// Stub data source: all operations are no-ops, all collections are empty.
/// Used as the initial value in [ACScrollViewController]
/// to avoid a nullable _dataSource.
class _EmptyDataSource<T> extends ACScrollViewDataSource<T> {
  @override
  List<T> get beforeItems => const [];

  @override
  List<T> get afterItems => const [];

  @override
  int get currentIndex => 0;

  @override
  T? get currentItem => null;

  @override
  bool get shouldBefore => false;

  @override
  bool get shouldAfter => false;

  @override
  bool get reachedEndBefore => true;

  @override
  bool get reachedEndAfter => true;

  @override
  void initialize([T? centerItem]) {}

  @override
  void loadMore() {}

  @override
  bool setCurrentIndex(int index) => false;

  @override
  T? loadBefore() => null;

  @override
  T? loadAfter() => null;
}

/// Controller for ACScrollView.
///
/// Provides a navigation API: transitions to the previous/next item
/// and jumping to an arbitrary item.
///
/// Stores a cache of item extents and a reference to the dataSource.
class ACScrollViewController<T> extends ScrollController {
  /// Creates a controller for `ACScrollView`.
  ACScrollViewController() {
    addListener(_onScroll);
  }

  ACScrollViewDataSource<T> _dataSource = _EmptyDataSource<T>();
  double Function(T)? _itemExtentBuilder;
  void Function(T item)? _onVisibleItemChanged;
  final Map<T, double> _extentCache = {};
  T? _lastCurrentItem;
  double _spacing = 0;

  /// Attaches the dataSource and itemExtentBuilder to the controller.
  /// Called automatically by the ACScrollView state.
  void attachDataSource(
    ACScrollViewDataSource<T> dataSource, {
    required double Function(T) itemExtentBuilder,
    double spacing = 0,
    void Function(T item)? onVisibleItemChanged,
  }) {
    _dataSource = dataSource;
    _itemExtentBuilder = itemExtentBuilder;
    _spacing = spacing;
    _onVisibleItemChanged = onVisibleItemChanged;
    _lastCurrentItem = dataSource.currentItem;
  }

  /// Returns the cached extent, or computes and caches it.
  double getExtent(T item) => _extentCache[item] ??= _itemExtentBuilder!(item);

  /// Transition to the specified item with a full data reload.
  void jumpToItem(T item) {
    _extentCache.clear();
    _dataSource.initialize(item);
    _notifyVisibleItemChanged();
    if (hasClients) jumpTo(0);
  }

  /// Animated transition to the previous item
  void animateToBeforeItem({
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    final target = _dataSource.loadBefore();
    if (target == null) return;

    animateTo(
      _computeOffsetFor(target),
      duration: duration,
      curve: curve,
    );
  }

  /// Animated transition to the next item
  void animateToAfterItem({
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    final target = _dataSource.loadAfter();
    if (target == null) return;

    animateTo(
      _computeOffsetFor(target),
      duration: duration,
      curve: curve,
    );
  }

  void _onScroll() {
    if (!hasClients) return;

    final ds = _dataSource;
    final offset = position.pixels;
    final newIndex = offset < 0
        ? _findIndexByOffset(offset, ds.beforeItems, true)
        : _findIndexByOffset(offset, ds.afterItems, false);

    if (ds.setCurrentIndex(newIndex)) {
      final item = ds.currentItem;
      _lastCurrentItem = item;
      if (item != null) _onVisibleItemChanged?.call(item);
    }
    ds.loadMore();
  }

  void _notifyVisibleItemChanged() {
    final newItem = _dataSource.currentItem;
    if (newItem != _lastCurrentItem) {
      _lastCurrentItem = newItem;
      if (newItem != null) _onVisibleItemChanged?.call(newItem);
    }
  }

  int _findIndexByOffset(double offset, List<T> items, bool isBefore) {
    final reachedEnd =
        isBefore ? _dataSource.reachedEndBefore : _dataSource.reachedEndAfter;

    double accumulated = 0;

    for (var i = 0; i < items.length; i++) {
      final isLast = i == items.length - 1;
      final extent =
          getExtent(items[i]) + (isLast && reachedEnd ? 0 : _spacing);

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

  double _computeOffsetFor(T target) {
    final ds = _dataSource;
    var accum = 0.0;

    for (var i = 0; i < ds.afterItems.length; i++) {
      final item = ds.afterItems[i];
      if (item == target) return accum;
      final isLast = i == ds.afterItems.length - 1;
      accum += getExtent(item) + (isLast && ds.reachedEndAfter ? 0 : _spacing);
    }

    accum = 0.0;

    for (var i = 0; i < ds.beforeItems.length; i++) {
      final item = ds.beforeItems[i];
      final isLast = i == ds.beforeItems.length - 1;
      accum -= getExtent(item) + (isLast && ds.reachedEndBefore ? 0 : _spacing);
      if (item == target) return accum;
    }

    return 0;
  }

  @override
  void dispose() {
    removeListener(_onScroll);
    _extentCache.clear();
    _dataSource = _EmptyDataSource<T>();
    _itemExtentBuilder = null;
    super.dispose();
  }
}
