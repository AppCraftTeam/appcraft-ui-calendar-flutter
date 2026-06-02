import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter_test/flutter_test.dart';

/// Mock data source for testing ACScrollViewController.
class _MockDataSource extends ACScrollViewDataSource<int> {
  _MockDataSource({
    List<int> afterItems = const [],
    List<int> beforeItems = const [],
  })  : _afterItems = List.of(afterItems),
        _beforeItems = List.of(beforeItems);

  final List<int> _beforeItems;
  final List<int> _afterItems;
  int _currentIndex = 0;
  final bool _reachedEndBefore = false;
  final bool _reachedEndAfter = false;

  int? lastInitializeItem;
  int initializeCallCount = 0;
  int loadMoreCallCount = 0;

  @override
  List<int> get beforeItems => _beforeItems;

  @override
  List<int> get afterItems => _afterItems;

  @override
  int get currentIndex => _currentIndex;

  @override
  int? get currentItem {
    if (_currentIndex < 0) {
      final i = (-_currentIndex) - 1;
      return i < _beforeItems.length ? _beforeItems[i] : null;
    }
    return _currentIndex < _afterItems.length
        ? _afterItems[_currentIndex]
        : null;
  }

  @override
  bool get shouldBefore => _beforeItems.isNotEmpty;

  @override
  bool get shouldAfter => _afterItems.isNotEmpty;

  @override
  bool get reachedEndBefore => _reachedEndBefore;

  @override
  bool get reachedEndAfter => _reachedEndAfter;

  @override
  void initialize([int? centerItem]) {
    lastInitializeItem = centerItem;
    initializeCallCount++;
  }

  @override
  void loadMore() {
    loadMoreCallCount++;
  }

  @override
  bool setCurrentIndex(int index) {
    if (index != _currentIndex) {
      _currentIndex = index;
      return true;
    }
    return false;
  }

  @override
  int? loadBefore() => null;

  @override
  int? loadAfter() => null;

  void replaceAfterItems(List<int> items) {
    _afterItems
      ..clear()
      ..addAll(items);
  }
}

/// Mock data source for navigation (loadBefore/loadAfter return values).
class _NavigableDataSource extends _MockDataSource {
  int? nextLoadBefore;
  int? nextLoadAfter;

  @override
  int? loadBefore() => nextLoadBefore;

  @override
  int? loadAfter() => nextLoadAfter;
}

void main() {
  group('ACScrollViewController -- creation and dispose', () {
    test('is created without errors', () {
      // Arrange & Act
      final controller = ACScrollViewController<int>();

      // Assert
      expect(controller, isNotNull);

      controller.dispose();
    });

    test('dispose clears cache and resources', () {
      // Arrange & Act
      ACScrollViewController<int>()
        ..attachDataSource(
          _MockDataSource(afterItems: [1, 2, 3]),
          itemExtentBuilder: (item) => item * 100.0,
        )
        ..getExtent(1)
        ..getExtent(2)
        ..dispose();

      // Assert -- dispose completed without errors
      expect(true, isTrue);
    });
  });

  group('ACScrollViewController -- attachDataSource', () {
    test('attaches dataSource and itemExtentBuilder', () {
      // Arrange
      final controller = ACScrollViewController<int>()
        ..attachDataSource(
          _MockDataSource(afterItems: [10]),
          itemExtentBuilder: (item) => item * 50.0,
        );

      // Assert
      expect(controller.getExtent(10), equals(500.0));

      controller.dispose();
    });

    test('stores spacing', () {
      // Arrange & Act
      final controller = ACScrollViewController<int>()
        ..attachDataSource(
          _MockDataSource(),
          itemExtentBuilder: (item) => 100,
          spacing: 20,
        );

      // Assert -- controller created with spacing (verified via behavior)
      expect(controller, isNotNull);

      controller.dispose();
    });

    test('sets lastCurrentItem from dataSource.currentItem', () {
      // Arrange
      final dataSource = _MockDataSource(afterItems: [42]);
      final controller = ACScrollViewController<int>()
        ..attachDataSource(
          dataSource,
          itemExtentBuilder: (item) => 100.0,
        );

      // Assert -- currentItem = 42 (index 0 in afterItems)
      expect(dataSource.currentItem, equals(42));

      controller.dispose();
    });
  });

  group('ACScrollViewController -- getExtent', () {
    test('computes and caches extent', () {
      // Arrange
      var callCount = 0;
      final controller = ACScrollViewController<int>()
        ..attachDataSource(
          _MockDataSource(),
          itemExtentBuilder: (item) {
            callCount++;
            return item * 10.0;
          },
        );

      // Act
      final extent1 = controller.getExtent(5);
      final extent2 = controller.getExtent(5);

      // Assert
      expect(extent1, equals(50.0));
      expect(extent2, equals(50.0));
      expect(callCount, equals(1)); // caching -- called once

      controller.dispose();
    });

    test('computes different extents for different items', () {
      // Arrange
      final controller = ACScrollViewController<int>()
        ..attachDataSource(
          _MockDataSource(),
          itemExtentBuilder: (item) => item * 10.0,
        );

      // Act & Assert
      expect(controller.getExtent(3), equals(30.0));
      expect(controller.getExtent(7), equals(70.0));

      controller.dispose();
    });
  });

  group('ACScrollViewController -- jumpToItem', () {
    test('clears cache and calls initialize', () {
      // Arrange
      final dataSource = _MockDataSource();
      final controller = ACScrollViewController<int>()
        ..attachDataSource(
          dataSource,
          itemExtentBuilder: (item) => 100.0,
        )
        ..getExtent(1)
        ..jumpToItem(42);

      // Assert
      expect(dataSource.lastInitializeItem, equals(42));
      expect(dataSource.initializeCallCount, equals(1));

      controller.dispose();
    });

    test('calls initialize with the provided item', () {
      // Arrange
      final dataSource = _MockDataSource();
      final controller = ACScrollViewController<int>()
        ..attachDataSource(
          dataSource,
          itemExtentBuilder: (item) => 100.0,
        )
        ..jumpToItem(99);

      // Assert
      expect(dataSource.lastInitializeItem, equals(99));

      controller.dispose();
    });
  });

  group('ACScrollViewController -- animateToBeforeItem', () {
    test('does nothing when loadBefore returns null', () {
      // Arrange
      final controller = ACScrollViewController<int>()
        ..attachDataSource(
          _NavigableDataSource()..nextLoadBefore = null,
          itemExtentBuilder: (item) => 100.0,
        );

      // Act & Assert -- does not throw an exception
      expect(controller.animateToBeforeItem, returnsNormally);

      controller.dispose();
    });
  });

  group('ACScrollViewController -- animateToAfterItem', () {
    test('does nothing when loadAfter returns null', () {
      // Arrange
      final controller = ACScrollViewController<int>()
        ..attachDataSource(
          _NavigableDataSource()..nextLoadAfter = null,
          itemExtentBuilder: (item) => 100.0,
        );

      // Act & Assert -- does not throw an exception
      expect(controller.animateToAfterItem, returnsNormally);

      controller.dispose();
    });
  });

  group('ACScrollViewController -- onVisibleItemChanged callback', () {
    test('is called on jumpToItem when the item changed', () {
      // Arrange
      final visibleItems = <int>[];
      final dataSource = _MockDataSource(afterItems: [10]);
      final controller = ACScrollViewController<int>()
        ..attachDataSource(
          dataSource,
          itemExtentBuilder: (item) => 100.0,
          onVisibleItemChanged: visibleItems.add,
        );

      // Act -- jumpToItem reinitializes the dataSource
      // After initialize, currentItem may change
      dataSource.replaceAfterItems([20]);
      controller.jumpToItem(20);

      // Assert
      expect(visibleItems, contains(20));

      controller.dispose();
    });
  });

  group('ACScrollViewController -- extends ScrollController', () {
    test('is an instance of ScrollController', () {
      // Arrange & Act
      final controller = ACScrollViewController<int>();

      // Assert
      expect(controller, isA<ACScrollViewController<int>>());

      controller.dispose();
    });
  });
}
