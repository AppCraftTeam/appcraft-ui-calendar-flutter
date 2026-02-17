import 'package:flutter/material.dart';

import '../../../../../../data/data.dart';
import '../../../../../../domain/domain.dart';
import '../../../../../presentation.dart';

/// Источник данных для календаря.
///
/// Определяет интерфейс для построения месяцев календаря и вычисления их размеров.
abstract class ACCalendarChildDelegate {
  const ACCalendarChildDelegate();

  /// Построение виджета для месяца
  ///
  /// [context] - контекст для построения виджета
  /// [monthDate] - дата месяца (первый день месяца)
  /// [constraints] - ограничения размера
  Widget itemBuilder(
    BuildContext context,
    DateTime monthDate,
    BoxConstraints constraints,
  );

  /// Вычисление размера элемента (высота для вертикального скролла, ширина для горизонтального)
  ///
  /// [monthDate] - дата месяца (первый день месяца)
  /// [constraints] - ограничения размера
  double itemExtentBuilder(
    DateTime monthDate,
    BoxConstraints constraints,
  );

  /// Освобождает ресурсы delegate
  void dispose() {}
}

/// Абстрактный источник данных для календаря с кэшированием.
///
/// Предоставляет механизм кэширования данных месяцев для оптимизации производительности.
abstract class CachedCalendarChildDelegate extends ACCalendarChildDelegate {
  CachedCalendarChildDelegate();

  /// Репозиторий для работы с календарными данными
  final _calendarRepository = const ACCalendarRepository();

  /// Кэш данных месяцев (до 12 месяцев)
  final _monthDataCache = ACCache<DateTime, ACCalendarMonthCache>(12);

  /// Первый день недели (0 - воскресенье, 1 - понедельник и т.д.)
  int? get weekStart;

  /// Получает layout для месяца с заданным количеством недель
  DefaultMonthLayout getMonthLayout(int weeksCount);

  /// Получает кэшированные данные месяца или вычисляет их
  ACCalendarMonthCache getMonthCache(DateTime monthDate) =>
    _monthDataCache.putIfAbsent(monthDate, () {
      final days = _calendarRepository.getMonthDays(
        monthDate,
        weekStart: weekStart,
      );

      final monthLayout = getMonthLayout((days.length / 7).toInt());

      return ACCalendarMonthCache(days: days, layout: monthLayout);
    });

  @override
  void dispose() =>
    _monthDataCache.clear();
}

/// Реализация по умолчанию источника данных для календаря.
///
/// Содержит логику построения месяцев с учетом выбора, диапазона и темы.
class VerticalCalendarChildDelegate extends CachedCalendarChildDelegate {
  VerticalCalendarChildDelegate({
    required this.range,
    int? weekStart,
    this.theme,
    this.selectController,
  })  : _weekStart = weekStart;

  /// Диапазон доступных дат календаря
  final ACDateRange range;

  /// Первый день недели (0 - воскресенье, 1 - понедельник и т.д.)
  final int? _weekStart;

  /// Тема календаря
  final ACCalendarThemeData? theme;

  /// Контроллер выбора дат
  final ACCalendarSelectController? selectController;

  @override
  int? get weekStart => _weekStart;

  @override
  DefaultMonthLayout getMonthLayout(int weeksCount) {
    return switch (weeksCount) {
      4 => DefaultMonthLayout.mainAxisCount4,
      5 => DefaultMonthLayout.mainAxisCount5,
      6 => DefaultMonthLayout.mainAxisCount6,
      _ => DefaultMonthLayout(mainAxisCount: weeksCount), // Fallback для редких случаев
    };
  }

  @override
  Widget itemBuilder(
    BuildContext context,
    DateTime monthDate,
    BoxConstraints constraints,
  ) {
    final monthData = getMonthCache(monthDate);
    final monthWidth = constraints.maxWidth;

    return RepaintBoundary(
      child: SizedBox(
        width: monthWidth,
        height: monthData.layout.calculateHeight(monthWidth),
        child: ACMonthWidget(
          layout: monthData.layout,
          childrenDelegate: DefaultMonthChildDelegate(
            days: monthData.days,
            monthDate: monthDate,
            range: range,
            dayTheme: theme?.dayTheme,
            onSelectStateForDay: selectController?.selectStateForDay,
            onSelectDay: selectController?.selectDay,
          ),
        ),
      ),
    );
  }

  @override
  double itemExtentBuilder(
    DateTime monthDate,
    BoxConstraints constraints,
  ) {
    final monthWidth = constraints.maxWidth;
    final monthData = getMonthCache(monthDate);
    return monthData.layout.calculateHeight(monthWidth);
  }
}

/// Источник данных для постраничного отображения календаря.
///
/// Оптимизирован для горизонтального скролла (страницы):
/// - Всегда использует layout на 6 недель
/// - Размер элемента равен ширине контейнера
class PagesCalendarChildDelegate extends CachedCalendarChildDelegate {
  PagesCalendarChildDelegate({
    required this.range,
    required ACCalendarLayout layout,
    int? weekStart,
    this.theme,
    this.selectController,
  })  : _layout = layout,
        _weekStart = weekStart;

  /// Диапазон доступных дат календаря
  final ACDateRange range;

  /// Настройки лейаута календаря
  final ACCalendarLayout _layout;

  /// Первый день недели (0 - воскресенье, 1 - понедельник и т.д.)
  final int? _weekStart;

  /// Тема календаря
  final ACCalendarThemeData? theme;

  /// Контроллер выбора дат
  final ACCalendarSelectController? selectController;

  ACCalendarLayout get layout => _layout;

  @override
  int? get weekStart => _weekStart;

  @override
  DefaultMonthLayout getMonthLayout(int weeksCount) {
    // Всегда используем layout на 6 недель для постраничного отображения
    return DefaultMonthLayout.mainAxisCount6;
  }

  @override
  Widget itemBuilder(
    BuildContext context,
    DateTime monthDate,
    BoxConstraints constraints,
  ) {
    final monthData = getMonthCache(monthDate);
    final monthWidth = constraints.maxWidth;

    return RepaintBoundary(
      child: SizedBox(
        width: monthWidth,
        height: monthData.layout.calculateHeight(monthWidth),
        child: ACMonthWidget(
          layout: monthData.layout,
          childrenDelegate: DefaultMonthChildDelegate(
            days: monthData.days,
            monthDate: monthDate,
            range: range,
            dayTheme: theme?.dayTheme,
            onSelectStateForDay: selectController?.selectStateForDay,
            onSelectDay: selectController?.selectDay,
          ),
        ),
      ),
    );
  }

  @override
  double itemExtentBuilder(
    DateTime monthDate,
    BoxConstraints constraints,
  ) {
    // Для постраничного отображения размер всегда равен ширине
    return constraints.maxWidth;
  }
}
