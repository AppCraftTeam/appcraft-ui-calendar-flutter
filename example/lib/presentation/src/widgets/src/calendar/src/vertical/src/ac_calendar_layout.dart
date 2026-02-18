import 'package:flutter/material.dart';

import '../../../../../../../../data/data.dart';
import '../../../../../../../../domain/domain.dart';
import '../../../../../../../presentation.dart';

/// Источник данных для календаря.
///
/// Определяет интерфейс для построения месяцев календаря и вычисления их размеров.
abstract class ACCalendarLayout {
  const ACCalendarLayout();

  /// Физика прокрутки
  ScrollPhysics get physics;

  /// Направление прокрутки (если null, используется Axis.vertical)
  Axis get scrollDirection;

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
}

/// Абстрактный источник данных для календаря с кэшированием.
///
/// Предоставляет механизм кэширования данных месяцев для оптимизации производительности.
abstract class CachedCalendarChildLayout extends ACCalendarLayout {
  CachedCalendarChildLayout({
    this.weekStart
  });

  /// Репозиторий для работы с календарными данными
  final _calendarRepository = const ACCalendarRepository();

  /// Кэш данных месяцев (до 12 месяцев)
  final _monthDataCache = ACCache<DateTime, ACCalendarMonthCache>(12);

  /// Первый день недели (0 - воскресенье, 1 - понедельник и т.д.)
  final int? weekStart;

  /// Получает кэшированные данные месяца или вычисляет их
  ACCalendarMonthCache getMonthCache(DateTime monthDate) =>
    _monthDataCache.putIfAbsent(monthDate, () {
      final days = _calendarRepository.getMonthDays(
        monthDate,
        weekStart: weekStart,
      );

      ACMonthLayout monthLayout;

      switch (scrollDirection) {
        case Axis.horizontal:
          monthLayout = ACDefaultMonthLayout.mainAxisCount6;
        case Axis.vertical:
          final weeksCount = (days.length / 7).toInt();
          switch (weeksCount) {
            case 4:
              monthLayout = ACDefaultMonthLayout.mainAxisCount4;
            case 5:
              monthLayout = ACDefaultMonthLayout.mainAxisCount5;
            case 6:
              monthLayout = ACDefaultMonthLayout.mainAxisCount6;
            default:
              monthLayout = ACDefaultMonthLayout(
                mainAxisCount: weeksCount
              );
          }
      }

      return ACCalendarMonthCache(days: days, layout: monthLayout);
    });
}

/// Реализация по умолчанию источника данных для календаря.
///
/// Содержит логику построения месяцев с учетом выбора, диапазона и темы.
class ACVerticalCalendarLayout extends CachedCalendarChildLayout {
  ACVerticalCalendarLayout({
    required this.range,
    super.weekStart,
    this.theme,
    this.onSelectStateForDay,
    this.onSelectDay
  });

  /// Диапазон доступных дат календаря
  final ACDateRange range;

  /// Тема календаря
  final ACCalendarThemeData? theme;

  /// Функция определения состояния выбора для конкретного дня
  final ACDaySelectState? Function(DateTime day)? onSelectStateForDay;

  /// Коллбэк при выборе дня
  final void Function(DateTime day)? onSelectDay;

  @override
  ScrollPhysics get physics => const BouncingScrollPhysics();

  @override
  Axis get scrollDirection => Axis.vertical;

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
          childrenDelegate: ACDefaultDaysMonthChildDelegate(
            days: monthData.days,
            onShouldSelect: (day) {
              final isDayInRange = !day.isBefore(range.min) && !day.isAfter(range.max);
              return isDayInRange && day.month == monthDate.month;
            },
            dayTheme: theme?.dayTheme,
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
class ACPagesCalendarLayout extends CachedCalendarChildLayout {
  ACPagesCalendarLayout({
    required this.range,
    super.weekStart,
    this.theme,
    this.onSelectStateForDay,
    this.onSelectDay
  });

  /// Диапазон доступных дат календаря
  final ACDateRange range;

  /// Тема календаря
  final ACCalendarThemeData? theme;

  /// Функция определения состояния выбора для конкретного дня
  final ACDaySelectState? Function(DateTime day)? onSelectStateForDay;

  /// Коллбэк при выборе дня
  final void Function(DateTime day)? onSelectDay;

  @override
  ScrollPhysics get physics => const PageScrollPhysics();

  @override
  Axis get scrollDirection => Axis.horizontal;

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
          childrenDelegate: ACDefaultDaysMonthChildDelegate(
            days: monthData.days,
            onShouldSelect: (day) {
              final isDayInRange = !day.isBefore(range.min) && !day.isAfter(range.max);
              return isDayInRange && day.month == monthDate.month;
            },
            dayTheme: theme?.dayTheme
          ),
        ),
      ),
    );
  }

  @override
  double itemExtentBuilder(
    DateTime monthDate,
    BoxConstraints constraints,
  ) => constraints.maxWidth;

}
