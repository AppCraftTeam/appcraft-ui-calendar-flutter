import 'package:flutter/widgets.dart';

import '../../../../../../data/data.dart';
import '../../../../../../domain/domain.dart';

/// Контроллер для ACCustomScrollView
///
/// Управляет двунаправленным бесконечным списком элементов с центральным элементом.
/// Наследуется от ScrollController для управления как данными, так и прокруткой.
///
/// Аналогично PageController extends ScrollController в Flutter.
abstract class ACScrollViewController<T> extends ScrollController {
  /// Количество элементов ДО центра
  int get beforeItemCount;

  /// Количество элементов ОТ центра и ПОСЛЕ (включая центральный элемент)
  int get afterItemCount;

  /// Получить элемент ДО центра по индексу
  /// index 0 - ближайший к центру, index (beforeItemCount-1) - самый дальний
  T? beforeItemAt(int index);

  /// Получить элемент ОТ центра и ПОСЛЕ по индексу
  /// index 0 = центральный элемент
  T? afterItemAt(int index);

  /// Текущий видимый элемент
  T get currentItem;

  /// Возвращает true, если доступен предыдущий элемент от текущего
  bool get shouldBefore;

  /// Возвращает true, если доступен следующий элемент от текущего
  bool get shouldAfter;

  /// Анимированный переход к предыдущему элементу от текущего
  Future<void> animateToBeforeItem({
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  });

  /// Анимированный переход к следующему элементу от текущего
  Future<void> animateToAfterItem({
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  });

  /// Переход к указанному элементу с полной перезагрузкой
  void jumpToItem(T item);
}

/// Реализация DataController с использованием builder функций
class ACDefaultScrollViewController<T> extends ACScrollViewController<T> {
  ACDefaultScrollViewController({
    required T initialItem,
    required this.onBefore,
    required this.onAfter,
    required this.itemExtentBuilder,
    this.bufferThreshold = 3,
    this.preloadCount = 10,
    this.onVisibleItemChanged
  }) {
    // Инициализируем данные
    _afterItems.add(initialItem);

    // Загружаем элементы ДО центра
    var current = initialItem;
    for (var i = 0; i < preloadCount; i++) {
      final before = onBefore(current);
      if (before != null) {
        _beforeItems.add(before);
        current = before;
      } else {
        break;
      }
    }

    // Загружаем элементы ПОСЛЕ центра
    current = initialItem;
    for (var i = 0; i < preloadCount; i++) {
      final after = onAfter(current);
      if (after != null) {
        _afterItems.add(after);
        current = after;
      } else {
        break;
      }
    }

    // Слушаем изменения offset от ScrollController
    addListener(_onScroll);
  }

  /// Функция для получения предыдущего элемента
  final T? Function(T item) onBefore;

  /// Функция для получения следующего элемента
  final T? Function(T item) onAfter;

  /// Функция для вычисления размера элемента
  final double Function(T item) itemExtentBuilder;

  /// Порог для подгрузки новых элементов
  final int bufferThreshold;

  /// Количество предзагружаемых элементов
  final int preloadCount;

  /// Callback, вызываемый при изменении текущего видимого элемента
  void Function(T item)? onVisibleItemChanged;

  // Внутреннее состояние
  final List<T> _beforeItems = [];
  final List<T> _afterItems = [];
  final Map<T, double> _extentCache = {};
  int _currentIndex = 0;

  @override
  int get beforeItemCount => _beforeItems.length;

  @override
  int get afterItemCount => _afterItems.length;

  @override
  T? beforeItemAt(int index) {
    if (index < 0 || index >= _beforeItems.length) return null;
    return _beforeItems[index];
  }

  @override
  T? afterItemAt(int index) {
    if (index < 0 || index >= _afterItems.length) return null;
    return _afterItems[index];
  }

  int get currentIndex => _currentIndex;

  @override
  bool get shouldBefore => onBefore(currentItem) != null;

  @override
  bool get shouldAfter => onAfter(currentItem) != null;

  @override
  T get currentItem {
    if (_currentIndex < 0) {
      final beforeIndex = (-_currentIndex) - 1;
      return _beforeItems[beforeIndex];
    }
    return _afterItems[_currentIndex];
  }

  double getItemExtent(T item) {
    if (_extentCache.containsKey(item)) {
      return _extentCache[item]!;
    }

    final extent = itemExtentBuilder(item);
    _extentCache[item] = extent;
    return extent;
  }

  /// Вызывается при изменении scroll position
  void _onScroll() {
    if (!hasClients) return;

    final offset = position.pixels;

    // Обновляем текущий индекс
    _updateCurrentIndex(offset);

    // Проверяем необходимость подгрузки и загружаем данные
    if (_shouldLoadMore()) {
      _loadMoreBefore();
      _loadMoreAfter();
    }
  }

  void _updateCurrentIndex(double offset) {
    // offset < 0 означает скролл вверх (в before items)
    // offset > 0 означает скролл вниз (в after items)
    final newIndex = offset < 0
        ? _findIndexByOffset(offset, _beforeItems, true)
        : _findIndexByOffset(offset, _afterItems, false);

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
        onVisibleItemChanged?.call(item);
      }

      notifyListeners();
    }
  }

  bool _shouldLoadMore() {
    var needsLoad = false;

    // Проверяем необходимость подгрузки элементов ДО центра
    if (_currentIndex < 0) {
      final beforeIndex = (-_currentIndex) - 1;
      if (beforeIndex >= _beforeItems.length - bufferThreshold) {
        needsLoad = true;
      }
    }

    // Проверяем необходимость подгрузки элементов ПОСЛЕ центра
    if (_currentIndex >= 0) {
      if (_currentIndex >= _afterItems.length - bufferThreshold) {
        needsLoad = true;
      }
    }

    // Также проверяем при скролле около центра
    if (_beforeItems.length < bufferThreshold) {
      needsLoad = true;
    }
    if (_afterItems.length < bufferThreshold + 1) {
      needsLoad = true;
    }

    return needsLoad;
  }

  void _loadMoreBefore() {
    if (_beforeItems.isEmpty) return;

    final newItems = <T>[];
    var current = _beforeItems.last;

    for (var i = 0; i < preloadCount; i++) {
      final before = onBefore(current);
      if (before != null) {
        newItems.add(before);
        current = before;
      } else {
        break;
      }
    }

    if (newItems.isNotEmpty) {
      _beforeItems.addAll(newItems);
      notifyListeners();
    }
  }

  void _loadMoreAfter() {
    if (_afterItems.isEmpty) return;

    final newItems = <T>[];
    var current = _afterItems.last;

    for (var i = 0; i < preloadCount; i++) {
      final after = onAfter(current);
      if (after != null) {
        newItems.add(after);
        current = after;
      } else {
        break;
      }
    }

    if (newItems.isNotEmpty) {
      _afterItems.addAll(newItems);
      notifyListeners();
    }
  }

  @override
  void jumpToItem(T item) {
    // Очищаем текущие данные
    _beforeItems.clear();
    _afterItems.clear();
    _extentCache.clear();
    _currentIndex = 0;

    _afterItems.add(item);

    // Загружаем элементы ДО центра
    var current = item;
    for (var i = 0; i < preloadCount; i++) {
      final before = onBefore(current);
      if (before != null) {
        _beforeItems.add(before);
        current = before;
      } else {
        break;
      }
    }

    // Загружаем элементы ПОСЛЕ центра
    current = item;
    for (var i = 0; i < preloadCount; i++) {
      final after = onAfter(current);
      if (after != null) {
        _afterItems.add(after);
        current = after;
      } else {
        break;
      }
    }

    onVisibleItemChanged?.call(item);
    notifyListeners();

    // Возвращаем scroll position к центру
    if (hasClients) {
      jumpTo(0);
    }
  }

  @override
  void dispose() {
    _extentCache.clear();
    super.dispose();
  }

  @override
  Future<void> animateToBeforeItem({
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) async {
    if (!hasClients) return;

    final target = onBefore(currentItem);
    if (target == null) return;

    // Если текущий — центральный, target должен быть в beforeItems[0]
    if (_currentIndex == 0) {
      if (_beforeItems.isEmpty || _beforeItems[0] != target) {
        _beforeItems.insert(0, target);
        notifyListeners();
      }
    }
    // Если текущий в beforeItems, target — следующий в том же списке
    else if (_currentIndex < 0) {
      final beforeIndex = (-_currentIndex) - 1;
      if (beforeIndex + 1 >= _beforeItems.length) {
        _beforeItems.add(target);
        notifyListeners();
      }
    }
    // currentIndex > 0: target уже существует в afterItems[currentIndex - 1]

    await animateTo(
      _computeOffsetFor(target),
      duration: duration,
      curve: curve,
    );
  }

  @override
  Future<void> animateToAfterItem({
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) async {
    if (!hasClients) return;

    final target = onAfter(currentItem);
    if (target == null) return;

    // Если текущий в afterItems, target должен быть следующим в том же списке
    if (_currentIndex >= 0 && _currentIndex + 1 >= _afterItems.length) {
      _afterItems.add(target);
      notifyListeners();
    }
    // currentIndex < 0: target уже существует (в beforeItems или afterItems)

    await animateTo(
      _computeOffsetFor(target),
      duration: duration,
      curve: curve,
    );
  }

  /// Вычисляет scroll offset для заданного элемента
  double _computeOffsetFor(T target) {
    // Ищем в afterItems (offset >= 0)
    var accum = 0.0;
    for (final item in _afterItems) {
      if (item == target) return accum;
      accum += getItemExtent(item);
    }

    // Ищем в beforeItems (offset < 0)
    accum = 0.0;
    for (final item in _beforeItems) {
      accum -= getItemExtent(item);
      if (item == target) return accum;
    }

    return 0;
  }

  /// Найти индекс элемента по offset
  int _findIndexByOffset(double offset, List<T> items, bool isBefore) {
    double accumulatedOffset = 0;

    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      final extent = getItemExtent(item);

      if (isBefore) {
        accumulatedOffset -= extent;
        if (accumulatedOffset <= offset) {
          return -(i + 1); // Отрицательный индекс для before items
        }
      } else {
        accumulatedOffset += extent;
        if (accumulatedOffset > offset.abs()) {
          return i;
        }
      }
    }

    return isBefore ? -items.length : items.length - 1;
  }
}