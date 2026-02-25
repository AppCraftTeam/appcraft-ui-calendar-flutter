import 'package:flutter/widgets.dart';

import 'ac_scroll_view_data_source.dart';

/// Контроллер для ACScrollView.
///
/// Предоставляет навигационный API: переходы к предыдущему/следующему элементу
/// и прыжок к произвольному элементу.
///
/// Хранит кэш extent'ов элементов и ссылку на dataSource.
class ACScrollViewController<T> extends ScrollController {
  ACScrollViewDataSource<T>? _dataSource;
  double Function(T)? _itemExtentBuilder;
  final Map<T, double> _extentCache = {};

  T? _currentItem;
  bool _shouldBefore = false;
  bool _shouldAfter = false;

  /// Текущий видимый элемент
  T get currentItem => _currentItem!;

  /// Возвращает true, если доступен предыдущий элемент от текущего
  bool get shouldBefore => _shouldBefore;

  /// Возвращает true, если доступен следующий элемент от текущего
  bool get shouldAfter => _shouldAfter;

  /// Привязывает dataSource и itemExtentBuilder к контроллеру.
  /// Вызывается автоматически стейтом ACScrollView.
  void attachDataSource(
    ACScrollViewDataSource<T> dataSource,
    double Function(T) itemExtentBuilder,
  ) {
    _dataSource = dataSource;
    _itemExtentBuilder = itemExtentBuilder;
  }

  // ─── Extent cache ────────────────────────────────────────────────────────

  /// Возвращает кэшированный extent или вычисляет и кэширует.
  double getExtent(T item) =>
      _extentCache[item] ??= _itemExtentBuilder!(item);

  // ─── Navigation ──────────────────────────────────────────────────────────

  /// Переход к указанному элементу с полной перезагрузкой данных.
  void jumpToItem(T item) {
    _extentCache.clear();
    _dataSource!.initialize(item);
    if (hasClients) jumpTo(0);
  }

  /// Анимированный переход к предыдущему элементу
  void animateToBeforeItem({
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    final target = _dataSource!.loadBefore();
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
    final target = _dataSource!.loadAfter();
    if (target == null) return;

    animateTo(
      _computeOffsetFor(target),
      duration: duration,
      curve: curve,
    );
  }

  /// Обновляет навигационное состояние контроллера.
  /// Вызывается автоматически стейтом ACScrollView — не вызывайте напрямую.
  void updateScrollState({
    required T currentItem,
    required bool shouldBefore,
    required bool shouldAfter,
  }) {
    _currentItem = currentItem;
    _shouldBefore = shouldBefore;
    _shouldAfter = shouldAfter;
  }

  // ─── Private ─────────────────────────────────────────────────────────────

  double _computeOffsetFor(T target) {
    final ds = _dataSource!;
    var accum = 0.0;
    for (final item in ds.afterItems) {
      if (item == target) return accum;
      accum += getExtent(item);
    }
    accum = 0.0;
    for (final item in ds.beforeItems) {
      accum -= getExtent(item);
      if (item == target) return accum;
    }
    return 0;
  }

  @override
  void dispose() {
    _extentCache.clear();
    _dataSource = null;
    _itemExtentBuilder = null;
    super.dispose();
  }
}
