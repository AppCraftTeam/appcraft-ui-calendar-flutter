import 'package:flutter/material.dart';

class ACCustomScrollViewController<T> {
  _ACCustomScrollViewState<T>? _state;

  /// Проверка, прикреплен ли контроллер
  bool get isAttached => _state != null;

  /// Текущий индекс видимого элемента (относительно center)
  int? get currentIndex => _state?._currentIndex;

  /// Возвращает текущий элемент
  T? get currentItem => _state?.currentItem;

  /// Внутренний ScrollController
  ScrollController? get scrollController => _state?._scrollController;

  // ignore: use_setters_to_change_properties
  void _attach(_ACCustomScrollViewState<T> state) => _state = state;

  void _detach() => _state = null;

  /// Переходит к указанному элементу, полностью перезагружая список
  void jumpToItem(T item) => _state?._jumpToItem(item);

  /// Прокрутка к центру (initialItem)
  void jumpToCenter() => _state?._jumpToCenter();
}

class ACCustomScrollView<T> extends StatefulWidget {
  const ACCustomScrollView({
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

  /// Начальный элемент (центр)
  final T initialItem;

  /// Функция для получения предыдущего элемента
  final T? Function(T currentItem) onBefore;

  /// Функция для получения следующего элемента
  final T? Function(T currentItem) onAfter;

  /// Builder для элемента списка
  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  /// Опциональный header builder (закреплён сверху)
  final Widget Function(BuildContext context)? headerBuilder;

  /// Контроллер
  final ACCustomScrollViewController<T>? controller;

  /// Callback при изменении видимого элемента
  final void Function(T item)? onItemChanged;

  /// Количество предзагружаемых элементов в каждую сторону
  final int preloadCount;

  /// Порог для подгрузки новых элементов
  final int bufferThreshold;

  /// Отступы для списка
  final EdgeInsetsGeometry? padding;

  /// Известная высота элемента (опционально)
  final double? itemHeight;

  @override
  State<ACCustomScrollView<T>> createState() => _ACCustomScrollViewState<T>();
}

class _ACCustomScrollViewState<T> extends State<ACCustomScrollView<T>> {
  late ScrollController _scrollController;

  /// Элементы ДО центра (в порядке от центра назад)
  /// beforeItems[0] - ближайший к центру, beforeItems[last] - самый дальний
  late List<T> _beforeItems;

  /// Элементы ОТ центра и ПОСЛЕ (включая сам центральный элемент)
  /// afterItems[0] = initialItem (центр)
  late List<T> _afterItems;

  /// Текущий индекс: 0 = center, отрицательные = before, положительные = after
  int _currentIndex = 0;

  final _centerKey = GlobalKey();

  T get currentItem {
    if (_currentIndex < 0) {
      final beforeIndex = (-_currentIndex) - 1;
      return _beforeItems[beforeIndex];
    }
    return _afterItems[_currentIndex];
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    _beforeItems = [];
    _afterItems = [widget.initialItem];

    _loadInitialItems();
    widget.controller?._attach(this);
  }

  @override
  void didUpdateWidget(ACCustomScrollView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._detach();
      widget.controller?._attach(this);
    }
  }

  void _loadInitialItems() {
    // Загружаем элементы ДО центра
    var current = widget.initialItem;
    for (var i = 0; i < widget.preloadCount; i++) {
      final before = widget.onBefore(current);
      if (before != null) {
        _beforeItems.add(before);
        current = before;
      } else {
        break;
      }
    }

    // Загружаем элементы ПОСЛЕ центра
    current = widget.initialItem;
    for (var i = 0; i < widget.preloadCount; i++) {
      final after = widget.onAfter(current);
      if (after != null) {
        _afterItems.add(after);
        current = after;
      } else {
        break;
      }
    }
  }

  void _jumpToItem(T item) {
    setState(() {
      _beforeItems = [];
      _afterItems = [item];
      _currentIndex = 0;
    });

    widget.onItemChanged?.call(item);

    _loadInitialItems();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
    });
  }

  void _jumpToCenter() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  void _onScroll() {
    _updateCurrentIndex();
    _checkAndLoadMore();
  }

  void _updateCurrentIndex() {
    if (!_scrollController.hasClients) return;

    final offset = _scrollController.offset;
    final itemHeight = widget.itemHeight ?? 200;

    // offset < 0 означает скролл вверх (в before items)
    // offset > 0 означает скролл вниз (в after items)
    int newIndex;
    if (offset < 0) {
      // Скролл в отрицательную область (before items)
      newIndex = (offset / itemHeight).floor();
    } else {
      // Скролл в положительную область (after items)
      newIndex = (offset / itemHeight).floor();
    }

    if (newIndex != _currentIndex) {
      _currentIndex = newIndex;

      // Получаем текущий элемент для callback
      T? item;
      if (_currentIndex < 0) {
        final beforeIndex = (-_currentIndex) - 1;
        if (beforeIndex < _beforeItems.length) {
          item = _beforeItems[beforeIndex];
        }
      } else {
        if (_currentIndex < _afterItems.length) {
          item = _afterItems[_currentIndex];
        }
      }

      if (item != null) {
        widget.onItemChanged?.call(item);
      }
    }
  }

  void _checkAndLoadMore() {
    // Проверяем необходимость подгрузки элементов ДО центра
    if (_currentIndex < 0) {
      final beforeIndex = (-_currentIndex) - 1;
      if (beforeIndex >= _beforeItems.length - widget.bufferThreshold) {
        _loadMoreBefore();
      }
    }

    // Проверяем необходимость подгрузки элементов ПОСЛЕ центра
    if (_currentIndex >= 0) {
      if (_currentIndex >= _afterItems.length - widget.bufferThreshold) {
        _loadMoreAfter();
      }
    }

    // Также проверяем при скролле около центра
    if (_beforeItems.length < widget.bufferThreshold) {
      _loadMoreBefore();
    }
    if (_afterItems.length < widget.bufferThreshold + 1) {
      _loadMoreAfter();
    }
  }

  void _loadMoreBefore() {
    if (_beforeItems.isEmpty) return;

    final newItems = <T>[];
    var current = _beforeItems.last;

    for (var i = 0; i < widget.preloadCount; i++) {
      final before = widget.onBefore(current);
      if (before != null) {
        newItems.add(before);
        current = before;
      } else {
        break;
      }
    }

    if (newItems.isNotEmpty) {
      setState(() {
        _beforeItems.addAll(newItems);
      });
    }
  }

  void _loadMoreAfter() {
    if (_afterItems.isEmpty) return;

    final newItems = <T>[];
    var current = _afterItems.last;

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
        _afterItems.addAll(newItems);
      });
    }
  }

  @override
  void dispose() {
    widget.controller?._detach();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      center: _centerKey,
      slivers: [
        // Header (если есть) - закреплён сверху
        if (widget.headerBuilder != null)
          SliverPinnedHeader(
            child: widget.headerBuilder!(context),
          ),

        // Элементы ДО центра (растут вверх, в отрицательном направлении)
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index >= _beforeItems.length) return null;
              final item = _beforeItems[index];
              // Индекс для callback: -1, -2, -3, ...
              final itemIndex = -(index + 1);
              return widget.itemBuilder(context, item, itemIndex);
            },
            childCount: _beforeItems.length,
          ),
        ),

        // Элементы ОТ центра и ПОСЛЕ (растут вниз, в положительном направлении)
        SliverList(
          key: _centerKey,
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index >= _afterItems.length) return null;
              final item = _afterItems[index];
              return widget.itemBuilder(context, item, index);
            },
            childCount: _afterItems.length,
          ),
        ),
      ],
    );
  }
}

/// Pinned header sliver
class SliverPinnedHeader extends StatelessWidget {
  const SliverPinnedHeader({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _PinnedHeaderDelegate(child: child),
    );
  }
}

class _PinnedHeaderDelegate extends SliverPersistentHeaderDelegate {
  _PinnedHeaderDelegate({required this.child});

  final Widget child;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(covariant _PinnedHeaderDelegate oldDelegate) {
    return child != oldDelegate.child;
  }
}
