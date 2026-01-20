import 'package:flutter/material.dart';

class ACPagerController<T> {
  _ACPagerState<T>? _state;

  /// Проверка, прикреплен ли контроллер
  bool get isAttached => _state != null;

  /// Текущий индекс страницы
  int? get currentIndex => _state?._currentIndex;

  /// Общее количество загруженных страниц
  int? get itemCount => _state?._items.length;

  /// Возвращает текущий элемент
  T? get currentItem => _state?.currentItem;

  void _attach(_ACPagerState<T> state) {
    _state = state;
  }

  void _detach() {
    _state = null;
  }

  /// Анимированный переход к предыдущей странице
  Future<void> animateToPrevious({
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) async {
    if (_state == null) {
      throw StateError('ACPagerController is not attached to any ACPager');
    }
    await _state!._animateToPrevious(duration: duration, curve: curve);
  }

  /// Анимированный переход к следующей странице
  Future<void> animateToNext({
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) async {
    if (_state == null) {
      throw StateError('ACPagerController is not attached to any ACPager');
    }
    await _state!._animateToNext(duration: duration, curve: curve);
  }

  /// Переходит к указанному элементу, полностью перезагружая список
  void jumpToItem(T item) {
    _state?._jumpToItem(item);
  }
}

class ACPager<T> extends StatefulWidget {
  const ACPager({
    required this.initialItem,
    required this.onBefore,
    required this.onAfter,
    required this.itemBuilder,
    this.controller,
    this.onPageChanged,
    super.key,
  });

  final T initialItem;
  final T? Function(T currentItem) onBefore;
  final T? Function(T currentItem) onAfter;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final ACPagerController? controller;
  final void Function(T item)? onPageChanged;

  @override
  State<ACPager<T>> createState() => _ACPagerState<T>();
}

class _ACPagerState<T> extends State<ACPager<T>> {
  late PageController _pageController;
  late List<T> _items;
  int _currentIndex = 0;
  bool _isJumping = false;
  
  // Количество предзагружаемых элементов
  static const int _preloadCount = 50;

  // На каком расстоянии от края подгружать
  static const int _bufferThreshold = 3;

  T get currentItem => _items[_currentIndex];

  @override
  void initState() {
    super.initState();
    _items = [widget.initialItem];
    _loadInitialItems();
    _pageController = PageController(initialPage: _currentIndex);
    widget.controller?._attach(this);
  }

  @override
  void didUpdateWidget(ACPager<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._detach();
      widget.controller?._attach(this);
    }
  }

  void _jumpToItem(T item) {
    setState(() {
      _isJumping = true;
      _items = [item];
      _currentIndex = 0;
      _pageController.jumpToPage(0);
    });

    widget.onPageChanged?.call(item);

    _loadInitialItems();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _isJumping = false;
      }
    });
  }

  void _loadInitialItems() {
    // Загружаем _preloadCount элементов влево
    List<T> beforeItems = [];
    T current = _items[0];
    
    for (int i = 0; i < _preloadCount; i++) {
      final before = widget.onBefore(current);
      if (before != null) {
        beforeItems.insert(0, before);
        current = before;
      } else {
        // Достигли начала
        break;
      }
    }
    
    if (beforeItems.isNotEmpty) {
      _items.insertAll(0, beforeItems);

      // Устанавливаем индекс на initialItem
      _currentIndex = beforeItems.length;
    }

    // Загружаем _preloadCount элементов вправо
    current = _items[_currentIndex];
    for (int i = 0; i < _preloadCount; i++) {
      final after = widget.onAfter(current);
      if (after != null) {
        _items.add(after);
        current = after;
      } else {
        // Достигли конца
        break;
      }
    }
  }

  void _onPageChanged(int index) {
    if (_isJumping) return;
    
    setState(() {
      _currentIndex = index;
    });

    // Вызываем callback с текущим элементом
    widget.onPageChanged?.call(_items[index]);

    // Подгружаем элементы слева, когда приближаемся к началу
    if (index <= _bufferThreshold && _items.isNotEmpty) {
      _loadMoreBefore();
    }

    // Подгружаем элементы справа, когда приближаемся к концу
    if (index >= _items.length - _bufferThreshold - 1 && _items.isNotEmpty) {
      _loadMoreAfter();
    }
  }

  void _loadMoreBefore() {
    List<T> newItems = [];
    T current = _items.first;
    
    for (int i = 0; i < _preloadCount; i++) {
      final before = widget.onBefore(current);
      if (before != null) {
        newItems.insert(0, before);
        current = before;
      } else {
        break;
      }
    }
    
    if (newItems.isNotEmpty) {
      _isJumping = true;
      
      setState(() {
        _items.insertAll(0, newItems);
        _currentIndex = _currentIndex + newItems.length;
      });
      
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _pageController.hasClients) {
          _pageController.jumpToPage(_currentIndex);
          _isJumping = false;
        }
      });
    }
  }

  void _loadMoreAfter() {
    List<T> newItems = [];
    T current = _items.last;
    
    for (int i = 0; i < _preloadCount; i++) {
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

  Future<void> _animateToPrevious({
    required Duration duration,
    required Curve curve,
  }) async {
    if (_currentIndex > 0 && _pageController.hasClients) {
      await _pageController.animateToPage(
        _currentIndex - 1,
        duration: duration,
        curve: curve,
      );
    }
  }

  Future<void> _animateToNext({
    required Duration duration,
    required Curve curve,
  }) async {
    if (_currentIndex < _items.length - 1 && _pageController.hasClients) {
      await _pageController.animateToPage(
        _currentIndex + 1,
        duration: duration,
        curve: curve,
      );
    }
  }

  @override
  void dispose() {
    widget.controller?._detach();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
    PageView.builder(
      controller: _pageController,
      onPageChanged: _onPageChanged,
      itemCount: _items.length,
      itemBuilder: (context, index) =>
        widget.itemBuilder(context, _items[index])
    );
}