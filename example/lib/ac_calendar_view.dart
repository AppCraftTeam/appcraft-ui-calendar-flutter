import 'package:flutter/material.dart';

class ACCalendarViewController<T> {
  _ACCalendarViewState<T>? _state;

  void _attach(_ACCalendarViewState<T> state) {
    _state = state;
  }

  void _detach() {
    _state = null;
  }

  bool get isAttached => _state != null;

  void jumpToItem(T item) {
    _state?._jumpToItem(item, animated: false);
  }

  void animateToItem(
    T item, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeOut,
  }) {
    _state?._jumpToItem(
      item,
      animated: true,
      duration: duration,
      curve: curve,
    );
  }

  /// Анимированно перейти к следующему элементу
  void animateToNext({
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeOut,
  }) {
    if (_state == null) return;

    final next = _state!._nextItem();
    if (next != null) {
      animateToItem(next, duration: duration, curve: curve);
    }
  }

  /// Анимированно перейти к предыдущему элементу
  void animateToPrevious({
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeOut,
  }) {
    if (_state == null) return;

    final prev = _state!._previousItem();
    if (prev != null) {
      animateToItem(prev, duration: duration, curve: curve);
    }
  }
}

typedef ItemBuilder<T> = Widget Function(BuildContext context, T item);
typedef ItemProvider<T> = T? Function(T item);
typedef PageChanged<T> = void Function(T item);

class ACCalendarView<T> extends StatefulWidget {
  final T initialItem;
  final ItemBuilder<T> itemBuilder;
  final ItemProvider<T> onBefore;
  final ItemProvider<T> onAfter;
  final PageChanged<T>? onPageChanged;
  final int windowSize;
  final ACCalendarViewController<T>? controller;

  ACCalendarView({
    super.key,
    required this.initialItem,
    required this.itemBuilder,
    required this.onBefore,
    required this.onAfter,
    this.onPageChanged,
    this.windowSize = 5,
    this.controller,
  }) : assert(windowSize.isOdd && windowSize >= 3);

  @override
  State<ACCalendarView<T>> createState() => _ACCalendarViewState<T>();
}

class _ACCalendarViewState<T> extends State<ACCalendarView<T>> {
  final ScrollController _scrollController = ScrollController();

  late List<T> _items;
  late int _currentIndex;
  T? _lastReportedItem;

  double _pageExtent = 0;

  int get _halfWindow => widget.windowSize ~/ 2;

  T? _nextItem() {
    if (_currentIndex < _items.length - 1) {
      return _items[_currentIndex + 1];
    } else {
      final next = widget.onAfter(_items.last);
      if (next != null) _append(next); // добавляем в окно
      return next;
    }
  }

  T? _previousItem() {
    if (_currentIndex > 0) {
      return _items[_currentIndex - 1];
    } else {
      final prev = widget.onBefore(_items.first);
      if (prev != null) _prepend(prev); // добавляем в окно
      return prev;
    }
  }

  @override
  void initState() {
    super.initState();

    _buildInitialWindow();

    _lastReportedItem = _items[_currentIndex];

    widget.controller?._attach(this);

    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_currentIndex * _pageExtent);
    });
  }

  void _buildInitialWindow() {
    final center = widget.initialItem;
    final items = <T>[center];
    var before = center;

    for (int i = 0; i < _halfWindow; i++) {
      final prev = widget.onBefore(before);
      if (prev == null) break;
      items.insert(0, prev);
      before = prev;
    }

    var after = center;

    for (int i = 0; i < _halfWindow; i++) {
      final next = widget.onAfter(after);
      if (next == null) break;
      items.add(next);
      after = next;
    }

    _items = items;
    _currentIndex = items.indexOf(center);
  }


  @override
  void dispose() {
    widget.controller?._detach();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final physicalPage = (_scrollController.offset / _pageExtent).round();
    final newIndex = physicalPage.clamp(0, _items.length - 1);

    if (newIndex == _currentIndex) return;

    _currentIndex = newIndex;

    final currentItem = _items[_currentIndex];
    if (currentItem != _lastReportedItem) {
      _lastReportedItem = currentItem;
      widget.onPageChanged?.call(currentItem);
    }

    _preload();
    _trimWindow();
  }

  void _preload() {
    if (_currentIndex <= _halfWindow) {
      final prev = widget.onBefore(_items.first);
      if (prev != null) _prepend(prev);
    }

    if (_currentIndex >= _items.length - 1 - _halfWindow) {
      final next = widget.onAfter(_items.last);
      if (next != null) _append(next);
    }
  }

  void _prepend(T item) {
    final offsetBefore = _scrollController.offset;

    setState(() {
      _items.insert(0, item);
      _currentIndex++;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(offsetBefore + _pageExtent);
    });
  }

  void _append(T item) {
    setState(() {
      _items.add(item);
    });
  }

  void _trimWindow() {
    final minAllowed = _currentIndex - _halfWindow;
    final maxAllowed = _currentIndex + _halfWindow;

    if (minAllowed > 0) {
      final removeCount = minAllowed;
      final offsetBefore = _scrollController.offset;

      setState(() {
        _items.removeRange(0, removeCount);
        _currentIndex -= removeCount;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.jumpTo(
          offsetBefore - removeCount * _pageExtent,
        );
      });
    }

    final excessEnd = _items.length - 1 - maxAllowed;
    if (excessEnd > 0) {
      setState(() {
        _items.removeRange(
          _items.length - excessEnd,
          _items.length,
        );
      });
    }
  }

  void _jumpToItem(
    T item, {
    required bool animated,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeOut,
  }) {
    if (_items[_currentIndex] == item) return;

    final newItems = <T>[item];

    var before = item;
    for (int i = 0; i < _halfWindow; i++) {
      final prev = widget.onBefore(before);
      if (prev == null) break;
      newItems.insert(0, prev);
      before = prev;
    }

    var after = item;
    for (int i = 0; i < _halfWindow; i++) {
      final next = widget.onAfter(after);
      if (next == null) break;
      newItems.add(next);
      after = next;
    }

    setState(() {
      _items = newItems;
      _currentIndex = newItems.indexOf(item);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final targetOffset = _currentIndex * _pageExtent;

      if (animated) {
        _scrollController.animateTo(
          targetOffset,
          duration: duration,
          curve: curve,
        );
      } else {
        _scrollController.jumpTo(targetOffset);
      }

      _lastReportedItem = item;
      widget.onPageChanged?.call(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    _pageExtent = MediaQuery.of(context).size.width;

    return ListView.builder(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      physics: const PageScrollPhysics(),
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        return SizedBox(
          width: _pageExtent,
          child: widget.itemBuilder(context, item),
        );
      },
    );
  }
}

