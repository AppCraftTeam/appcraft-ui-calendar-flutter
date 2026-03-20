import 'package:appcraft_ui_calendar_flutter/src/data/ac_cache.dart';
import 'package:test/test.dart';

void main() {
  group('ACCache put/get', () {
    test('stores and retrieves value', () {
      final cache = ACCache<String, int>(10)..put('a', 1);

      expect(cache.get('a'), equals(1));
    });

    test('returns null for missing key', () {
      final cache = ACCache<String, int>(10);

      expect(cache.get('missing'), isNull);
    });
  });

  group('ACCache LRU eviction', () {
    test('evicts least recently used on overflow', () {
      final cache = ACCache<String, int>(3)
        ..put('a', 1)
        ..put('b', 2)
        ..put('c', 3)
        ..put('d', 4); // should evict 'a'

      expect(cache.get('a'), isNull);
      expect(cache.get('b'), equals(2));
      expect(cache.get('d'), equals(4));
    });

    test('get updates access order preventing eviction', () {
      final cache = ACCache<String, int>(3)
        ..put('a', 1)
        ..put('b', 2)
        ..put('c', 3)
        ..get('a') // refresh 'a'
        ..put('d', 4); // should evict 'b' (oldest)

      expect(cache.get('a'), equals(1));
      expect(cache.get('b'), isNull);
    });
  });

  group('ACCache.putIfAbsent', () {
    test('does not overwrite existing value', () {
      final cache = ACCache<String, int>(10)..put('a', 1);

      final result = cache.putIfAbsent('a', () => 99);

      expect(result, equals(1));
      expect(cache.get('a'), equals(1));
    });

    test('calls ifAbsent for missing key', () {
      final cache = ACCache<String, int>(10);

      final result = cache.putIfAbsent('a', () => 42);

      expect(result, equals(42));
      expect(cache.get('a'), equals(42));
    });
  });

  group('ACCache.remove', () {
    test('removes element and decreases length', () {
      final cache = ACCache<String, int>(10)
        ..put('a', 1)
        ..put('b', 2)
        ..remove('a');

      expect(cache.get('a'), isNull);
      expect(cache.length, equals(1));
    });
  });

  group('ACCache.clear', () {
    test('clears all elements', () {
      final cache = ACCache<String, int>(10)
        ..put('a', 1)
        ..put('b', 2)
        ..clear();

      expect(cache.isEmpty, isTrue);
      expect(cache.length, equals(0));
    });
  });

  group('ACCache.containsKey', () {
    test('returns true for existing key', () {
      final cache = ACCache<String, int>(10)..put('a', 1);

      expect(cache.containsKey('a'), isTrue);
    });

    test('returns false for missing key', () {
      final cache = ACCache<String, int>(10);

      expect(cache.containsKey('a'), isFalse);
    });
  });

  group('ACCache maxSize = 1', () {
    test('holds only one element at a time', () {
      final cache = ACCache<String, int>(1)
        ..put('a', 1)
        ..put('b', 2);

      expect(cache.get('a'), isNull);
      expect(cache.get('b'), equals(2));
      expect(cache.length, equals(1));
    });
  });
}
