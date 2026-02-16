/// LRU (Least Recently Used) кэш с ограничением размера.
///
/// Автоматически удаляет самые старые элементы при достижении лимита.
class LRUCache<K, V> {
  LRUCache(this.maxSize) : assert(maxSize > 0, 'maxSize должен быть больше 0');

  /// Максимальное количество элементов в кэше
  final int maxSize;

  final _cache = <K, V>{};
  final _accessOrder = <K>[];

  /// Возвращает значение из кэша или вычисляет его через [ifAbsent]
  ///
  /// Если элемент найден в кэше, обновляет его позицию как самый недавно использованный.
  /// Если элемент не найден, вычисляет значение и добавляет в кэш.
  /// При достижении лимита размера удаляет самый старый элемент.
  V putIfAbsent(K key, V Function() ifAbsent) {
    if (_cache.containsKey(key)) {
      // Обновляем порядок доступа - элемент становится самым свежим
      _accessOrder
        ..remove(key)
        ..add(key);
      return _cache[key]!;
    }

    final value = ifAbsent();

    // Если достигли лимита, удаляем самый старый элемент (первый в списке)
    if (_cache.length >= maxSize) {
      final oldest = _accessOrder.removeAt(0);
      _cache.remove(oldest);
    }

    _cache[key] = value;
    _accessOrder.add(key);
    return value;
  }

  /// Получает значение из кэша или null если элемент отсутствует
  V? get(K key) {
    if (_cache.containsKey(key)) {
      // Обновляем порядок доступа
      _accessOrder
        ..remove(key)
        ..add(key);
      return _cache[key];
    }
    return null;
  }

  /// Добавляет или обновляет значение в кэше
  void put(K key, V value) {
    if (_cache.containsKey(key)) {
      _cache[key] = value;
      // Обновляем порядок доступа
      _accessOrder
        ..remove(key)
        ..add(key);
    } else {
      // Если достигли лимита, удаляем самый старый элемент
      if (_cache.length >= maxSize) {
        final oldest = _accessOrder.removeAt(0);
        _cache.remove(oldest);
      }
      _cache[key] = value;
      _accessOrder.add(key);
    }
  }

  /// Проверяет наличие элемента в кэше
  bool containsKey(K key) => _cache.containsKey(key);

  /// Удаляет элемент из кэша
  V? remove(K key) {
    _accessOrder.remove(key);
    return _cache.remove(key);
  }

  /// Очищает весь кэш
  void clear() {
    _cache.clear();
    _accessOrder.clear();
  }

  /// Текущее количество элементов в кэше
  int get length => _cache.length;

  /// Проверка на пустоту
  bool get isEmpty => _cache.isEmpty;

  /// Проверка на наличие элементов
  bool get isNotEmpty => _cache.isNotEmpty;
}
