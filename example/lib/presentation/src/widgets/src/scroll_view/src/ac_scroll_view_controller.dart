import 'package:flutter/widgets.dart';

/// Команда анимированного перехода.
/// Создаётся контроллером, потребляется стейтом ACScrollView.
class ACScrollViewAnimateCommand {
  const ACScrollViewAnimateCommand({
    required this.duration,
    required this.curve,
  });

  final Duration duration;
  final Curve curve;
}

/// Контроллер для ACScrollView.
///
/// Предоставляет навигационный API: переходы к предыдущему/следующему элементу
/// и прыжок к произвольному элементу.
///
/// Данные (beforeItems, afterItems, логика загрузки) хранятся в стейте ACScrollView.
/// Контроллер общается со стейтом через паттерн команд:
/// устанавливает pending-команду + notifyListeners(), стейт исполняет и сбрасывает.
class ACScrollViewController<T> extends ScrollController {
  T? _currentItem;
  bool _shouldBefore = false;
  bool _shouldAfter = false;

  // Pending-команды: устанавливаются публичным API, потребляются стейтом
  T? pendingJumpItem;
  ACScrollViewAnimateCommand? pendingBeforeCommand;
  ACScrollViewAnimateCommand? pendingAfterCommand;

  /// Текущий видимый элемент
  T get currentItem => _currentItem!;

  /// Возвращает true, если доступен предыдущий элемент от текущего
  bool get shouldBefore => _shouldBefore;

  /// Возвращает true, если доступен следующий элемент от текущего
  bool get shouldAfter => _shouldAfter;

  /// Анимированный переход к предыдущему элементу
  void animateToBeforeItem({
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    pendingBeforeCommand = ACScrollViewAnimateCommand(
      duration: duration,
      curve: curve,
    );
    notifyListeners();
  }

  /// Анимированный переход к следующему элементу
  void animateToAfterItem({
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    pendingAfterCommand = ACScrollViewAnimateCommand(
      duration: duration,
      curve: curve,
    );
    notifyListeners();
  }

  /// Переход к указанному элементу с полной перезагрузкой данных
  void jumpToItem(T item) {
    pendingJumpItem = item;
    notifyListeners();
  }

  /// Обновляет навигационное состояние контроллера.
  /// Вызывается автоматически стейтом ACScrollView — не вызывайте напрямую.
  void updateScrollState({
    required T currentItem,
    required bool shouldBefore,
    required bool shouldAfter,
  }) {
    _currentItem = currentItem;
    _shouldBefore = shouldBefore;
    _shouldAfter = shouldAfter;
  }
}
