import 'package:flutter/material.dart';

import 'ac_scroll_view_controller.dart';

class ACScrollView<T> extends StatefulWidget {
  const ACScrollView({
    required this.controller,
    required this.initialItem,
    required this.onBefore,
    required this.onAfter,
    required this.itemExtentBuilder,
    required this.itemBuilder,
    this.onVisibleItemChanged,
    this.bufferThreshold = 3,
    this.preloadCount = 10,
    this.padding,
    this.physics,
    this.scrollDirection,
    super.key,
  });

  final ACScrollViewController<T> controller;

  /// Начальный элемент, отображаемый в центре списка
  final T initialItem;

  /// Возвращает элемент перед item, или null если достигнут край
  final T? Function(T item) onBefore;

  /// Возвращает элемент после item, или null если достигнут край
  final T? Function(T item) onAfter;

  /// Возвращает высоту/ширину элемента — используется для вычисления scroll offset
  final double Function(T item) itemExtentBuilder;

  /// Builder для построения виджета элемента
  final Widget Function(BuildContext context, T item) itemBuilder;

  /// Вызывается при смене текущего видимого элемента
  final void Function(T item)? onVisibleItemChanged;

  /// Порог подгрузки: загружает новые элементы когда до края остаётся столько элементов
  final int bufferThreshold;

  /// Количество предзагружаемых элементов при инициализации и подгрузке
  final int preloadCount;

  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final Axis? scrollDirection;

  @override
  State<ACScrollView<T>> createState() => _ACScrollViewState<T>();
}

class _ACScrollViewState<T> extends State<ACScrollView<T>> {
  final _centerKey = GlobalKey();

  final List<T> _beforeItems = [];
  final List<T> _afterItems = [];
  final Map<T, double> _extentCache = {};
  int _currentIndex = 0;

  // ─── Lifecycle ────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _initializeData(widget.initialItem);
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(ACScrollView<T> old) {
    super.didUpdateWidget(old);
    if (old.controller != widget.controller) {
      old.controller.removeListener(_onControllerChanged);
      widget.controller.addListener(_onControllerChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    _extentCache.clear();
    super.dispose();
  }

  // ─── Data management ──────────────────────────────────────────────────────

  void _initializeData(T centerItem) {
    _beforeItems.clear();
    _afterItems.clear();
    _extentCache.clear();
    _currentIndex = 0;

    _afterItems.add(centerItem);

    var current = centerItem;
    for (var i = 0; i < widget.preloadCount; i++) {
      final before = widget.onBefore(current);
      if (before == null) break;
      _beforeItems.add(before);
      current = before;
    }

    current = centerItem;
    for (var i = 0; i < widget.preloadCount; i++) {
      final after = widget.onAfter(current);
      if (after == null) break;
      _afterItems.add(after);
      current = after;
    }
  }

  void _loadMoreBefore() {
    if (_beforeItems.isEmpty) return;
    final newItems = <T>[];
    var current = _beforeItems.last;
    for (var i = 0; i < widget.preloadCount; i++) {
      final before = widget.onBefore(current);
      if (before == null) break;
      newItems.add(before);
      current = before;
    }
    if (newItems.isNotEmpty) {
      setState(() => _beforeItems.addAll(newItems));
    }
  }

  void _loadMoreAfter() {
    if (_afterItems.isEmpty) return;
    final newItems = <T>[];
    var current = _afterItems.last;
    for (var i = 0; i < widget.preloadCount; i++) {
      final after = widget.onAfter(current);
      if (after == null) break;
      newItems.add(after);
      current = after;
    }
    if (newItems.isNotEmpty) {
      setState(() => _afterItems.addAll(newItems));
    }
  }

  bool _shouldLoadMore() {
    if (_currentIndex < 0) {
      final beforeIndex = (-_currentIndex) - 1;
      if (beforeIndex >= _beforeItems.length - widget.bufferThreshold) return true;
    }
    if (_currentIndex >= 0) {
      if (_currentIndex >= _afterItems.length - widget.bufferThreshold) return true;
    }
    if (_beforeItems.length < widget.bufferThreshold) return true;
    if (_afterItems.length < widget.bufferThreshold + 1) return true;
    return false;
  }

  // ─── Controller listener ──────────────────────────────────────────────────

  void _onControllerChanged() {
    if (!mounted) return;

    final ctrl = widget.controller;

    // Команда jumpToItem
    final jumpTarget = ctrl.pendingJumpItem;
    if (jumpTarget != null) {
      ctrl.pendingJumpItem = null;
      _handleJump(jumpTarget);
      return;
    }

    // Команда animateToBeforeItem
    final beforeCmd = ctrl.pendingBeforeCommand;
    if (beforeCmd != null) {
      ctrl.pendingBeforeCommand = null;
      _handleAnimateBefore(beforeCmd);
      return;
    }

    // Команда animateToAfterItem
    final afterCmd = ctrl.pendingAfterCommand;
    if (afterCmd != null) {
      ctrl.pendingAfterCommand = null;
      _handleAnimateAfter(afterCmd);
      return;
    }

    // Обычное событие скролла
    if (ctrl.hasClients) {
      _onScroll(ctrl.position.pixels);
    }
  }

  // ─── Scroll handling ──────────────────────────────────────────────────────

  void _onScroll(double offset) {
    _updateCurrentIndex(offset);
    if (_shouldLoadMore()) {
      _loadMoreBefore();
      _loadMoreAfter();
    }
  }

  void _updateCurrentIndex(double offset) {
    final newIndex = offset < 0
        ? _findIndexByOffset(offset, _beforeItems, true)
        : _findIndexByOffset(offset, _afterItems, false);

    if (newIndex != _currentIndex) {
      _currentIndex = newIndex;
      _syncControllerState();
      widget.onVisibleItemChanged?.call(_currentItem);
    }
  }

  // ─── Navigation handlers ──────────────────────────────────────────────────

  void _handleJump(T item) {
    setState(() => _initializeData(item));
    _syncControllerState();
    widget.onVisibleItemChanged?.call(item);
    if (widget.controller.hasClients) {
      widget.controller.jumpTo(0);
    }
  }

  void _handleAnimateBefore(ACScrollViewAnimateCommand cmd) {
    final target = widget.onBefore(_currentItem);
    if (target == null) return;

    if (_currentIndex == 0) {
      if (_beforeItems.isEmpty || _beforeItems[0] != target) {
        setState(() => _beforeItems.insert(0, target));
      }
    } else if (_currentIndex < 0) {
      final beforeIndex = (-_currentIndex) - 1;
      if (beforeIndex + 1 >= _beforeItems.length) {
        setState(() => _beforeItems.add(target));
      }
    }

    widget.controller.animateTo(
      _computeOffsetFor(target),
      duration: cmd.duration,
      curve: cmd.curve,
    );
  }

  void _handleAnimateAfter(ACScrollViewAnimateCommand cmd) {
    final target = widget.onAfter(_currentItem);
    if (target == null) return;

    if (_currentIndex >= 0 && _currentIndex + 1 >= _afterItems.length) {
      setState(() => _afterItems.add(target));
    }

    widget.controller.animateTo(
      _computeOffsetFor(target),
      duration: cmd.duration,
      curve: cmd.curve,
    );
  }

  // ─── Controller state sync ────────────────────────────────────────────────

  void _syncControllerState() {
    widget.controller.updateScrollState(
      currentItem: _currentItem,
      shouldBefore: widget.onBefore(_currentItem) != null,
      shouldAfter: widget.onAfter(_currentItem) != null,
    );
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  T get _currentItem {
    if (_currentIndex < 0) {
      return _beforeItems[(-_currentIndex) - 1];
    }
    return _afterItems[_currentIndex];
  }

  double _getExtent(T item) =>
      _extentCache[item] ??= widget.itemExtentBuilder(item);

  double _computeOffsetFor(T target) {
    var accum = 0.0;
    for (final item in _afterItems) {
      if (item == target) return accum;
      accum += _getExtent(item);
    }
    accum = 0.0;
    for (final item in _beforeItems) {
      accum -= _getExtent(item);
      if (item == target) return accum;
    }
    return 0;
  }

  int _findIndexByOffset(double offset, List<T> items, bool isBefore) {
    double accumulated = 0;
    for (var i = 0; i < items.length; i++) {
      final extent = _getExtent(items[i]);
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
                if (index >= _beforeItems.length) return null;
                return widget.itemBuilder(context, _beforeItems[index]);
              },
              childCount: _beforeItems.length,
            ),
          ),
          SliverList(
            key: _centerKey,
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index >= _afterItems.length) return null;
                return widget.itemBuilder(context, _afterItems[index]);
              },
              childCount: _afterItems.length,
            ),
          ),
        ],
      );
}
