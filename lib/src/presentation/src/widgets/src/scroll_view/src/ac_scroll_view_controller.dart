import 'package:flutter/widgets.dart';

import 'ac_scroll_view_data_source.dart';

/// Заглушка data source: все операции — no-op, все коллекции пусты.
/// Используется как начальное значение в [ACScrollViewController],
/// чтобы избежать nullable _dataSource.
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

/// Контроллер для ACScrollView.
///
/// Предоставляет навигационный API: переходы к предыдущему/следующему элементу
/// и прыжок к произвольному элементу.
///
/// Хранит кэш extent'ов элементов и ссылку на dataSource.
class ACScrollViewController<T> extends ScrollController {
  /// Создаёт контроллер для `ACScrollView`.
  ACScrollViewController() {
    addListener(_onScroll);
  }

  ACScrollViewDataSource<T> _dataSource = _EmptyDataSource<T>();
  double Function(T)? _itemExtentBuilder;
  void Function(T item)? _onVisibleItemChanged;
  final Map<T, double> _extentCache = {};
  T? _lastCurrentItem;
  double _spacing = 0;

  /// Привязывает dataSource и itemExtentBuilder к контроллеру.
  /// Вызывается автоматически стейтом ACScrollView.
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

  /// Возвращает кэшированный extent или вычисляет и кэширует.
  double getExtent(T item) => _extentCache[item] ??= _itemExtentBuilder!(item);

  /// Переход к указанному элементу с полной перезагрузкой данных.
  void jumpToItem(T item) {
    _extentCache.clear();
    _dataSource.initialize(item);
    _notifyVisibleItemChanged();
    if (hasClients) jumpTo(0);
  }

  /// Анимированный переход к предыдущему элементу
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

  /// Анимированный переход к следующему элементу
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
