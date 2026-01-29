import 'package:flutter/material.dart';

class ACScrollViewController<T> {
  _ACScrollViewState<T>? _state;

  /// Проверка, прикреплен ли контроллер
  bool get isAttached => _state != null;

  /// Текущий индекс видимого элемента
  int? get currentIndex => _state?._currentIndex;

  /// Общее количество загруженных элементов
  int? get itemCount => _state?._items.length;

  /// Возвращает текущий элемент
  T? get currentItem => _state?.currentItem;

  /// Внутренний ScrollController
  ScrollController? get scrollController => _state?._scrollController;

  // ignore: use_setters_to_change_properties
  void _attach(_ACScrollViewState<T> state) => _state = state;

  void _detach() => _state = null;

  /// Переходит к указанному элементу, полностью перезагружая список
  void jumpToItem(T item) => _state?._jumpToItem(item);

  /// Прокрутка к указанному индексу
  void jumpToIndex(int index) => _state?._jumpToIndex(index);
}

class ACScrollView<T> extends StatefulWidget {
  const ACScrollView({
    required this.initialItem,
    required this.onBefore,
    required this.onAfter,
    required this.itemBuilder,
    this.headerBuilder,
    this.controller,
    this.onItemChanged,
    this.preloadCount = 10,
    this.bufferThreshold = 3,
    this.padding,
    this.itemHeight,
    super.key,
  });

  /// Начальный элемент
  final T initialItem;

  /// Функция для получения предыдущего элемента
  final T? Function(T currentItem) onBefore;

  /// Функция для получения следующего элемента
  final T? Function(T currentItem) onAfter;

  /// Builder для элемента списка
  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  /// Опциональный header builder (например, для заголовка недели)
  final Widget Function(BuildContext context)? headerBuilder;

  /// Контроллер
  final ACScrollViewController<T>? controller;

  /// Callback при изменении видимого элемента
  final void Function(T item)? onItemChanged;

  /// Количество предзагружаемых элементов
  final int preloadCount;

  /// Порог для подгрузки новых элементов
  final int bufferThreshold;

  /// Отступы для списка
  final EdgeInsetsGeometry? padding;

  /// Известная высота элемента (если не задана, используется _estimatedItemHeight)
  final double? itemHeight;

  @override
  State<ACScrollView<T>> createState() => _ACScrollViewState<T>();
}

class _ACScrollViewState<T> extends State<ACScrollView<T>> {
  late ScrollController _scrollController;
  late List<T> _items;
  int _currentIndex = 0;
  bool _isJumping = false;
  bool _isLoadingBefore = false;

  // Для отслеживания высоты элементов
  final Map<int, double> _itemHeights = {};
  late double _estimatedItemHeight;
  bool _isControllerInitialized = false;

  T get currentItem => _items[_currentIndex];

  double get _effectiveItemHeight => widget.itemHeight ?? _estimatedItemHeight;

  @override
  void initState() {
    super.initState();
    _estimatedItemHeight = widget.itemHeight ?? 200;
    _items = [widget.initialItem];
    _loadInitialItems();
    widget.controller?._attach(this);
  }

  void _initScrollController(double initialOffset) {
    if (_isControllerInitialized) return;
    _isControllerInitialized = true;
    _scrollController = ScrollController(initialScrollOffset: initialOffset);
    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(ACScrollView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._detach();
      widget.controller?._attach(this);
    }
  }

  void _jumpToItem(T item) {
    _items = [item];
    _currentIndex = 0;
    _itemHeights.clear();

    widget.onItemChanged?.call(item);

    _loadInitialItems();

    // Вычисляем новый offset и прыгаем к нему
    final headerOffset = widget.headerBuilder != null ? 50.0 : 0.0;
    final targetOffset = headerOffset + (_currentIndex * _effectiveItemHeight);

    setState(() {
      _isJumping = true;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _isControllerInitialized && _scrollController.hasClients) {
        _scrollController.jumpTo(targetOffset);
        _isJumping = false;
      }
    });
  }

  void _jumpToIndex(int index) {
    if (index < 0 || index >= _items.length || !_isControllerInitialized) return;
    _scrollToIndex(index);
  }

  void _scrollToIndex(int index) {
    if (!_isControllerInitialized || !_scrollController.hasClients) return;

    // Вычисляем приблизительную позицию
    var offset = 0.0;
    final headerOffset = widget.headerBuilder != null ? 50.0 : 0.0;
    offset += headerOffset;

    for (var i = 0; i < index; i++) {
      offset += _itemHeights[i] ?? _effectiveItemHeight;
    }

    _scrollController.jumpTo(offset.clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    ));
  }

  void _loadInitialItems() {
    // Загружаем preloadCount элементов до начального
    final beforeItems = <T>[];
    var current = _items[0];

    for (var i = 0; i < widget.preloadCount; i++) {
      final before = widget.onBefore(current);
      if (before != null) {
        beforeItems.insert(0, before);
        current = before;
      } else {
        break;
      }
    }

    if (beforeItems.isNotEmpty) {
      _items.insertAll(0, beforeItems);
      _currentIndex = beforeItems.length;
    }

    // Загружаем preloadCount элементов после начального
    current = _items[_currentIndex];
    for (var i = 0; i < widget.preloadCount; i++) {
      final after = widget.onAfter(current);
      if (after != null) {
        _items.add(after);
        current = after;
      } else {
        break;
      }
    }
  }

  void _onScroll() {
    if (_isJumping || !_isControllerInitialized) return;

    // Определяем текущий видимый элемент
    _updateCurrentIndex();

    // Проверяем необходимость подгрузки
    if (_currentIndex <= widget.bufferThreshold && _items.isNotEmpty) {
      _loadMoreBefore();
    }

    if (_currentIndex >= _items.length - widget.bufferThreshold - 1 &&
        _items.isNotEmpty) {
      _loadMoreAfter();
    }
  }

  void _updateCurrentIndex() {
    if (!_isControllerInitialized || !_scrollController.hasClients) return;

    final scrollOffset = _scrollController.offset;
    var accumulatedHeight = widget.headerBuilder != null ? 50.0 : 0.0;
    var newIndex = 0;

    for (var i = 0; i < _items.length; i++) {
      final itemHeight = _itemHeights[i] ?? _effectiveItemHeight;
      if (accumulatedHeight + itemHeight > scrollOffset) {
        newIndex = i;
        break;
      }
      accumulatedHeight += itemHeight;
      newIndex = i;
    }

    if (newIndex != _currentIndex) {
      _currentIndex = newIndex;
      widget.onItemChanged?.call(_items[_currentIndex]);
    }
  }

  void _loadMoreBefore() {
    if (_isLoadingBefore || !_isControllerInitialized) return;

    final newItems = <T>[];
    var current = _items.first;

    for (var i = 0; i < widget.preloadCount; i++) {
      final before = widget.onBefore(current);
      if (before != null) {
        newItems.insert(0, before);
        current = before;
      } else {
        break;
      }
    }

    if (newItems.isNotEmpty) {
      _isLoadingBefore = true;
      _isJumping = true;

      // Сохраняем текущую позицию и offset относительно текущего элемента
      final currentOffset = _scrollController.offset;

      // Вычисляем высоту добавляемых элементов
      final addedHeight = newItems.length * _effectiveItemHeight;

      // Сдвигаем индексы высот
      final newHeights = <int, double>{};
      for (final entry in _itemHeights.entries) {
        newHeights[entry.key + newItems.length] = entry.value;
      }

      setState(() {
        _items.insertAll(0, newItems);
        _currentIndex = _currentIndex + newItems.length;
        _itemHeights
          ..clear()
          ..addAll(newHeights);
      });

      // Корректируем позицию синхронно через microtask
      // чтобы минимизировать видимый скачок
      Future.microtask(() {
        if (mounted && _scrollController.hasClients) {
          _scrollController.jumpTo(currentOffset + addedHeight);
          _isJumping = false;
          _isLoadingBefore = false;
        }
      });
    }
  }

  void _loadMoreAfter() {
    final newItems = <T>[];
    var current = _items.last;

    for (var i = 0; i < widget.preloadCount; i++) {
      final after = widget.onAfter(current);
      if (after != null) {
        newItems.add(after);
        current = after;
      } else {
        break;
      }
    }

    if (newItems.isNotEmpty) {
      setState(() {
        _items.addAll(newItems);
      });
    }
  }

  void _recordItemHeight(int index, double height) {
    if (_itemHeights[index] != height) {
      _itemHeights[index] = height;
      // Обновляем среднюю высоту
      if (_itemHeights.isNotEmpty) {
        _estimatedItemHeight =
            _itemHeights.values.reduce((a, b) => a + b) / _itemHeights.length;
      }
    }
  }

  @override
  void dispose() {
    widget.controller?._detach();
    if (_isControllerInitialized) {
      _scrollController
        ..removeListener(_onScroll)
        ..dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasHeader = widget.headerBuilder != null;
    final itemCount = _items.length + (hasHeader ? 1 : 0);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Вычисляем начальную позицию на основе известной высоты элемента
        final headerOffset = hasHeader ? 50.0 : 0.0;
        final initialOffset = headerOffset + (_currentIndex * _effectiveItemHeight);
        _initScrollController(initialOffset);

        return ListView.builder(
          controller: _scrollController,
          padding: widget.padding,
          itemCount: itemCount,
          itemBuilder: (context, index) {
            if (hasHeader && index == 0) {
              return widget.headerBuilder!(context);
            }

            final itemIndex = hasHeader ? index - 1 : index;
            final item = _items[itemIndex];

            return _MeasuredItem(
              index: itemIndex,
              onHeightMeasured: _recordItemHeight,
              child: widget.itemBuilder(context, item, itemIndex),
            );
          },
        );
      },
    );
  }
}

/// Виджет для измерения высоты элемента
class _MeasuredItem extends StatefulWidget {
  const _MeasuredItem({
    required this.index,
    required this.onHeightMeasured,
    required this.child,
  });

  final int index;
  final void Function(int index, double height) onHeightMeasured;
  final Widget child;

  @override
  State<_MeasuredItem> createState() => _MeasuredItemState();
}

class _MeasuredItemState extends State<_MeasuredItem> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measureHeight();
    });
  }

  void _measureHeight() {
    if (!mounted) return;
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox != null && renderBox.hasSize) {
      widget.onHeightMeasured(widget.index, renderBox.size.height);
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
