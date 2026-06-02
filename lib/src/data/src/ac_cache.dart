/// An LRU (Least Recently Used) cache with a size limit.
///
/// Automatically removes the oldest entries when the limit is reached.
class ACCache<K, V> {
  /// Creates an LRU cache with the maximum size [maxSize].
  ACCache(this.maxSize) : assert(maxSize > 0, 'maxSize must be greater than 0');

  /// The maximum number of entries in the cache.
  final int maxSize;

  final _cache = <K, V>{};
  final _accessOrder = <K>[];

  /// Returns the value from the cache or computes it via [ifAbsent]
  ///
  /// If the entry is found in the cache, updates its position as the most
  /// recently used.
  /// If the entry is not found, computes the value and adds it to the cache.
  /// When the size limit is reached, removes the oldest entry.
  V putIfAbsent(K key, V Function() ifAbsent) {
    if (_cache.containsKey(key)) {
      // Update the access order - the entry becomes the most recent
      _accessOrder
        ..remove(key)
        ..add(key);
      return _cache[key]!;
    }

    final value = ifAbsent();

    // If the limit is reached, remove the oldest entry (first in the list)
    if (_cache.length >= maxSize) {
      final oldest = _accessOrder.removeAt(0);
      _cache.remove(oldest);
    }

    _cache[key] = value;
    _accessOrder.add(key);
    return value;
  }

  /// Gets the value from the cache or null if the entry is absent
  V? get(K key) {
    if (_cache.containsKey(key)) {
      // Update the access order
      _accessOrder
        ..remove(key)
        ..add(key);
      return _cache[key];
    }
    return null;
  }

  /// Adds or updates a value in the cache
  void put(K key, V value) {
    if (_cache.containsKey(key)) {
      _cache[key] = value;
      // Update the access order
      _accessOrder
        ..remove(key)
        ..add(key);
    } else {
      // If the limit is reached, remove the oldest entry
      if (_cache.length >= maxSize) {
        final oldest = _accessOrder.removeAt(0);
        _cache.remove(oldest);
      }
      _cache[key] = value;
      _accessOrder.add(key);
    }
  }

  /// Checks whether an entry is present in the cache
  bool containsKey(K key) => _cache.containsKey(key);

  /// Removes an entry from the cache
  V? remove(K key) {
    _accessOrder.remove(key);
    return _cache.remove(key);
  }

  /// Clears the entire cache
  void clear() {
    _cache.clear();
    _accessOrder.clear();
  }

  /// The current number of entries in the cache
  int get length => _cache.length;

  /// Whether the cache is empty
  bool get isEmpty => _cache.isEmpty;

  /// Whether the cache contains any entries
  bool get isNotEmpty => _cache.isNotEmpty;
}
