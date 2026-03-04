import 'package:flutter/foundation.dart';

/// Абстрактный источник данных для ACScrollView.
///
/// Определяет контракт для управления элементами, индексом и подгрузкой.
/// Реализация по умолчанию — [ACDefaultScrollViewDataSource].
abstract class ACScrollViewDataSource<T> extends ChangeNotifier {
  List<T> get beforeItems;
  List<T> get afterItems;
  int get currentIndex;
  T? get currentItem;

  /// Доступен ли предыдущий элемент от текущего.
  bool get shouldBefore;

  /// Доступен ли следующий элемент от текущего.
  bool get shouldAfter;

  /// Достигнут ли край данных в направлении «назад».
  bool get reachedEndBefore;

  /// Достигнут ли край данных в направлении «вперёд».
  bool get reachedEndAfter;

  /// Инициализирует (или переинициализирует) данные с центральным элементом.
  void initialize([T? centerItem]);

  /// Подгружает элементы если необходимо.
  void loadMore();

  /// Устанавливает текущий индекс.
  /// Возвращает true если индекс изменился.
  bool setCurrentIndex(int index);

  /// Загружает предыдущий элемент (от текущего) для анимации навигации.
  /// Возвращает элемент или null если навигация невозможна.
  T? loadBefore();

  /// Загружает следующий элемент (от текущего) для анимации навигации.
  /// Возвращает элемент или null если навигация невозможна.
  T? loadAfter();

}

/// Реализация [ACScrollViewDataSource] по умолчанию.
///
/// Управляет списками элементов (before/after),
/// текущим индексом и логикой подгрузки.
class ACDefaultScrollViewDataSource<T> extends ACScrollViewDataSource<T> {
  ACDefaultScrollViewDataSource({
    required this.initialItem,
    required this.onBefore,
    required this.onAfter,
    this.bufferThreshold = 3,
    this.preloadCount = 10,
  });

  /// Начальный элемент, отображаемый в центре списка
  final T initialItem;

  /// Возвращает элемент перед item, или null если достигнут край.
  final T? Function(T item) onBefore;

  /// Возвращает элемент после item, или null если достигнут край.
  final T? Function(T item) onAfter;

  /// Порог подгрузки: загружает новые элементы когда до края остаётся столько элементов
  final int bufferThreshold;

  /// Количество предзагружаемых элементов при инициализации и подгрузке
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
      if (before == null) { _reachedEndBefore = true; break; }
      _beforeItems.add(before);
      current = before;
    }

    current = center;
    for (var i = 0; i < preloadCount; i++) {
      final after = onAfter(current);
      if (after == null) { _reachedEndAfter = true; break; }
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
      if (before == null) { _reachedEndBefore = true; break; }
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
      if (after == null) { _reachedEndAfter = true; break; }
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
