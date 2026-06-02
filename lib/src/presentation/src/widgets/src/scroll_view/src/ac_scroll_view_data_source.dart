import 'package:flutter/foundation.dart';

/// Abstract data source for ACScrollView.
///
/// Defines the contract for managing items, the index, and loading.
/// The default implementation is [ACDefaultScrollViewDataSource].
abstract class ACScrollViewDataSource<T> extends ChangeNotifier {
  /// Items located before the center item.
  List<T> get beforeItems;

  /// Items located after the center item (including it).
  List<T> get afterItems;

  /// Current index of the visible item.
  int get currentIndex;

  /// Current visible item, or `null` if there is no data.
  T? get currentItem;

  /// Whether the previous item relative to the current one is available.
  bool get shouldBefore;

  /// Whether the next item relative to the current one is available.
  bool get shouldAfter;

  /// Whether the data edge has been reached in the "backward" direction.
  bool get reachedEndBefore;

  /// Whether the data edge has been reached in the "forward" direction.
  bool get reachedEndAfter;

  /// Initializes (or reinitializes) the data with a center item.
  void initialize([T? centerItem]);

  /// Loads more items if necessary.
  void loadMore();

  /// Sets the current index.
  /// Returns true if the index changed.
  bool setCurrentIndex(int index);

  /// Loads the previous item (relative to the current one) for navigation animation.
  /// Returns the item, or null if navigation is not possible.
  T? loadBefore();

  /// Loads the next item (relative to the current one) for navigation animation.
  /// Returns the item, or null if navigation is not possible.
  T? loadAfter();
}

/// Default implementation of [ACScrollViewDataSource].
///
/// Manages item lists (before/after),
/// the current index, and the loading logic.
class ACDefaultScrollViewDataSource<T> extends ACScrollViewDataSource<T> {
  /// Creates a data source with an initial item and navigation functions.
  ACDefaultScrollViewDataSource({
    required this.initialItem,
    required this.onBefore,
    required this.onAfter,
    this.bufferThreshold = 3,
    this.preloadCount = 10,
  });

  /// Initial item displayed at the center of the list
  final T initialItem;

  /// Returns the item before item, or null if the edge is reached.
  final T? Function(T item) onBefore;

  /// Returns the item after item, or null if the edge is reached.
  final T? Function(T item) onAfter;

  /// Loading threshold: loads new items when this many items remain before the edge
  final int bufferThreshold;

  /// Number of items preloaded on initialization and loading
  final int preloadCount;

  // ─── State ───────────────────────────────────────────────────────────────

  final List<T> _beforeItems = [];
  final List<T> _afterItems = [];
  int _currentIndex = 0;
  bool _reachedEndBefore = false;
  bool _reachedEndAfter = false;

  @override
  List<T> get beforeItems => _beforeItems;

  @override
  List<T> get afterItems => _afterItems;

  @override
  int get currentIndex => _currentIndex;

  @override
  T? get currentItem {
    if (_currentIndex < 0) {
      final i = (-_currentIndex) - 1;
      return i < _beforeItems.length ? _beforeItems[i] : null;
    }
    return _currentIndex < _afterItems.length
        ? _afterItems[_currentIndex]
        : null;
  }

  @override
  bool get reachedEndBefore => _reachedEndBefore;

  @override
  bool get reachedEndAfter => _reachedEndAfter;

  @override
  bool get shouldBefore {
    final item = currentItem;
    return item != null && onBefore(item) != null;
  }

  @override
  bool get shouldAfter {
    final item = currentItem;
    return item != null && onAfter(item) != null;
  }

  // ─── Initialization ──────────────────────────────────────────────────────

  @override
  void initialize([T? centerItem]) {
    final center = centerItem ?? initialItem;
    _beforeItems.clear();
    _afterItems.clear();
    _currentIndex = 0;
    _reachedEndBefore = false;
    _reachedEndAfter = false;

    _afterItems.add(center);

    var current = center;
    for (var i = 0; i < preloadCount; i++) {
      final before = onBefore(current);
      if (before == null) {
        _reachedEndBefore = true;
        break;
      }
      _beforeItems.add(before);
      current = before;
    }

    current = center;
    for (var i = 0; i < preloadCount; i++) {
      final after = onAfter(current);
      if (after == null) {
        _reachedEndAfter = true;
        break;
      }
      _afterItems.add(after);
      current = after;
    }

    notifyListeners();
  }

  // ─── Loading ─────────────────────────────────────────────────────────────

  @override
  void loadMore() {
    if (!_shouldLoadMore()) return;
    _loadMoreBefore();
    _loadMoreAfter();
  }

  @override
  T? loadBefore() {
    final item = currentItem;
    if (item == null) return null;
    final target = onBefore(item);
    if (target == null) return null;

    if (_currentIndex == 0) {
      if (_beforeItems.isEmpty || _beforeItems[0] != target) {
        _beforeItems.insert(0, target);
        notifyListeners();
      }
    } else if (_currentIndex < 0) {
      final beforeIndex = (-_currentIndex) - 1;
      if (beforeIndex + 1 >= _beforeItems.length) {
        _beforeItems.add(target);
        notifyListeners();
      }
    }

    return target;
  }

  @override
  T? loadAfter() {
    final item = currentItem;
    if (item == null) return null;
    final target = onAfter(item);
    if (target == null) return null;

    if (_currentIndex >= 0 && _currentIndex + 1 >= _afterItems.length) {
      _afterItems.add(target);
      notifyListeners();
    }

    return target;
  }

  void _loadMoreBefore() {
    if (_beforeItems.isEmpty || _reachedEndBefore) return;
    final newItems = <T>[];
    var current = _beforeItems.last;
    for (var i = 0; i < preloadCount; i++) {
      final before = onBefore(current);
      if (before == null) {
        _reachedEndBefore = true;
        break;
      }
      newItems.add(before);
      current = before;
    }
    if (newItems.isNotEmpty) {
      _beforeItems.addAll(newItems);
      notifyListeners();
    }
  }

  void _loadMoreAfter() {
    if (_afterItems.isEmpty || _reachedEndAfter) return;
    final newItems = <T>[];
    var current = _afterItems.last;
    for (var i = 0; i < preloadCount; i++) {
      final after = onAfter(current);
      if (after == null) {
        _reachedEndAfter = true;
        break;
      }
      newItems.add(after);
      current = after;
    }
    if (newItems.isNotEmpty) {
      _afterItems.addAll(newItems);
      notifyListeners();
    }
  }

  bool _shouldLoadMore() {
    if (_currentIndex < 0) {
      final beforeIndex = (-_currentIndex) - 1;
      if (beforeIndex >= _beforeItems.length - bufferThreshold) return true;
    }
    if (_currentIndex >= 0) {
      if (_currentIndex >= _afterItems.length - bufferThreshold) return true;
    }
    if (_beforeItems.length < bufferThreshold) return true;
    if (_afterItems.length < bufferThreshold + 1) return true;
    return false;
  }

  // ─── Index management ────────────────────────────────────────────────────

  @override
  bool setCurrentIndex(int index) {
    if (index != _currentIndex) {
      _currentIndex = index;
      return true;
    }
    return false;
  }
}
