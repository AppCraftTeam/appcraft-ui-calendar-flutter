import 'package:appcraft_ui_calendar_flutter/src/presentation/src/widgets/src/scroll_view/src/ac_scroll_view_data_source.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  /// Creates a simple integer data source centered on [center].
  /// onBefore returns center-1, center-2, ... down to [minValue].
  /// onAfter returns center+1, center+2, ... up to [maxValue].
  ACDefaultScrollViewDataSource<int> createDataSource({
    int center = 0,
    int minValue = -100,
    int maxValue = 100,
    int preloadCount = 10,
    int bufferThreshold = 3,
  }) {
    return ACDefaultScrollViewDataSource<int>(
      initialItem: center,
      onBefore: (item) => item > minValue ? item - 1 : null,
      onAfter: (item) => item < maxValue ? item + 1 : null,
      preloadCount: preloadCount,
      bufferThreshold: bufferThreshold,
    );
  }

  group('ACDefaultScrollViewDataSource.initialize', () {
    test('preloads items before and after', () {
      final ds = createDataSource(preloadCount: 5)..initialize();

      expect(ds.beforeItems.length, equals(5));
      expect(ds.afterItems.length, equals(6)); // initial + 5 after
    });

    test('currentItem returns initialItem after init', () {
      final ds = createDataSource(center: 42)..initialize();

      expect(ds.currentItem, equals(42));
    });

    test('currentIndex is 0 after init', () {
      final ds = createDataSource()..initialize();

      expect(ds.currentIndex, equals(0));
    });
  });

  group('ACDefaultScrollViewDataSource.setCurrentIndex', () {
    test('updates currentItem', () {
      final ds = createDataSource(center: 0, preloadCount: 5)
        ..initialize()
        ..setCurrentIndex(1);

      expect(ds.currentItem, equals(1));
    });

    test('returns true when index changes', () {
      final ds = createDataSource()..initialize();

      expect(ds.setCurrentIndex(1), isTrue);
    });

    test('returns false when index is same', () {
      final ds = createDataSource()..initialize();

      expect(ds.setCurrentIndex(0), isFalse);
    });
  });

  group('ACDefaultScrollViewDataSource.loadMore', () {
    test('loads more items when near buffer threshold', () {
      final ds = createDataSource(preloadCount: 3, bufferThreshold: 3)
        ..initialize();

      final initialAfterCount = ds.afterItems.length; // 4 (initial + 3)
      // Move index close to end of afterItems so threshold triggers
      ds
        ..setCurrentIndex(2)
        ..loadMore();

      expect(ds.afterItems.length, greaterThan(initialAfterCount));
    });
  });

  group('ACDefaultScrollViewDataSource shouldBefore/shouldAfter', () {
    test('shouldBefore is true when previous item exists', () {
      final ds = createDataSource(center: 0)..initialize();

      expect(ds.shouldBefore, isTrue);
    });

    test('shouldAfter is true when next item exists', () {
      final ds = createDataSource(center: 0)..initialize();

      expect(ds.shouldAfter, isTrue);
    });
  });

  group('ACDefaultScrollViewDataSource reachedEnd', () {
    test('reachedEndBefore is true when onBefore returns null', () {
      final ds = createDataSource(center: 0, minValue: 0, preloadCount: 5)
        ..initialize();

      expect(ds.reachedEndBefore, isTrue);
    });

    test('reachedEndAfter is true when onAfter returns null', () {
      final ds = createDataSource(center: 0, maxValue: 0, preloadCount: 5)
        ..initialize();

      expect(ds.reachedEndAfter, isTrue);
    });
  });

  group('ACDefaultScrollViewDataSource.loadBefore/loadAfter', () {
    test('loadBefore returns previous item', () {
      final ds = createDataSource(center: 0)..initialize();

      final result = ds.loadBefore();

      expect(result, equals(-1));
    });

    test('loadAfter returns next item', () {
      final ds = createDataSource(center: 0)..initialize();

      final result = ds.loadAfter();

      // onAfter(0) = 1, which is already in afterItems so no append needed
      expect(result, equals(1));
    });
  });

  group('ACDefaultScrollViewDataSource negative indices', () {
    test('currentItem resolves from beforeItems for negative index', () {
      final ds = createDataSource(center: 0, preloadCount: 5)
        ..initialize()
        ..setCurrentIndex(-1);

      // beforeItems[0] should be -1
      expect(ds.currentItem, equals(-1));
    });
  });
}
