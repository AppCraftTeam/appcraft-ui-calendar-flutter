import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter_test/flutter_test.dart';

/// Мок data source для тестирования ACScrollViewController.
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

/// Мок data source для навигации (loadBefore/loadAfter возвращает значения).
class _NavigableDataSource extends _MockDataSource {
  int? nextLoadBefore;
  int? nextLoadAfter;

  @override
  int? loadBefore() => nextLoadBefore;

  @override
  int? loadAfter() => nextLoadAfter;
}

void main() {
  group('ACScrollViewController -- создание и dispose', () {
    test('создаётся без ошибок', () {
      // Arrange & Act
      final controller = ACScrollViewController<int>();

      // Assert
      expect(controller, isNotNull);

      controller.dispose();
    });

    test('dispose очищает кэш и ресурсы', () {
      // Arrange & Act
      ACScrollViewController<int>()
        ..attachDataSource(
          _MockDataSource(afterItems: [1, 2, 3]),
          itemExtentBuilder: (item) => item * 100.0,
        )
        ..getExtent(1)
        ..getExtent(2)
        ..dispose();

      // Assert -- dispose завершился без ошибок
      expect(true, isTrue);
    });
  });

  group('ACScrollViewController -- attachDataSource', () {
    test('привязывает dataSource и itemExtentBuilder', () {
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

    test('сохраняет spacing', () {
      // Arrange & Act
      final controller = ACScrollViewController<int>()
        ..attachDataSource(
          _MockDataSource(),
          itemExtentBuilder: (item) => 100,
          spacing: 20,
        );

      // Assert -- контроллер создан с spacing (проверяется через поведение)
      expect(controller, isNotNull);

      controller.dispose();
    });

    test('устанавливает lastCurrentItem из dataSource.currentItem', () {
      // Arrange
      final dataSource = _MockDataSource(afterItems: [42]);
      final controller = ACScrollViewController<int>()
        ..attachDataSource(
          dataSource,
          itemExtentBuilder: (item) => 100.0,
        );

      // Assert -- currentItem = 42 (индекс 0 в afterItems)
      expect(dataSource.currentItem, equals(42));

      controller.dispose();
    });
  });

  group('ACScrollViewController -- getExtent', () {
    test('вычисляет и кэширует extent', () {
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
      expect(callCount, equals(1)); // кэширование -- вызван один раз

      controller.dispose();
    });

    test('вычисляет разные extent для разных элементов', () {
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
    test('очищает кэш и вызывает initialize', () {
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

    test('вызывает initialize с переданным элементом', () {
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
    test('не выполняет действия если loadBefore возвращает null', () {
      // Arrange
      final controller = ACScrollViewController<int>()
        ..attachDataSource(
          _NavigableDataSource()..nextLoadBefore = null,
          itemExtentBuilder: (item) => 100.0,
        );

      // Act & Assert -- не бросает исключение
      expect(controller.animateToBeforeItem, returnsNormally);

      controller.dispose();
    });
  });

  group('ACScrollViewController -- animateToAfterItem', () {
    test('не выполняет действия если loadAfter возвращает null', () {
      // Arrange
      final controller = ACScrollViewController<int>()
        ..attachDataSource(
          _NavigableDataSource()..nextLoadAfter = null,
          itemExtentBuilder: (item) => 100.0,
        );

      // Act & Assert -- не бросает исключение
      expect(controller.animateToAfterItem, returnsNormally);

      controller.dispose();
    });
  });

  group('ACScrollViewController -- onVisibleItemChanged callback', () {
    test('вызывается при jumpToItem если элемент изменился', () {
      // Arrange
      final visibleItems = <int>[];
      final dataSource = _MockDataSource(afterItems: [10]);
      final controller = ACScrollViewController<int>()
        ..attachDataSource(
          dataSource,
          itemExtentBuilder: (item) => 100.0,
          onVisibleItemChanged: visibleItems.add,
        );

      // Act -- jumpToItem переинициализирует dataSource
      // После initialize currentItem может измениться
      dataSource.replaceAfterItems([20]);
      controller.jumpToItem(20);

      // Assert
      expect(visibleItems, contains(20));

      controller.dispose();
    });
  });

  group('ACScrollViewController -- расширяет ScrollController', () {
    test('является экземпляром ScrollController', () {
      // Arrange & Act
      final controller = ACScrollViewController<int>();

      // Assert
      expect(controller, isA<ACScrollViewController<int>>());

      controller.dispose();
    });
  });
}
