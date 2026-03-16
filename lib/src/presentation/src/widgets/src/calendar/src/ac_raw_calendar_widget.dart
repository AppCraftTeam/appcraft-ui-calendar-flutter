import 'package:flutter/material.dart';

import '../../../../../../data/data.dart';
import '../../../../../../domain/domain.dart';
import '../../../../../presentation.dart';

/// Календарь с вертикальной прокруткой по месяцам без [ACCalendarScope].
class ACRawCalendarWidget extends StatefulWidget {
  const ACRawCalendarWidget({
    required this.range,
    this.repository,
    this.scrollViewController,
    this.scrollViewDataSource,
    this.initialDate,
    this.onVisibleDateChanged,
    this.timeWidget,
    this.scrollViewPadding,
    this.weekPadding,
    this.timeWidgetPadding,
    super.key,
  });

  /// Репозиторий для вычислений календаря.
  ///
  /// Если не указан, используется [ACDefaultCalendarRepository].
  final ACCalendarRepository? repository;

  /// Допустимый диапазон дат для навигации.
  final ACDateRange range;

  /// Контроллер прокрутки.
  ///
  /// Если не указан, создаётся автоматически внутри виджета.
  final ACScrollViewController<DateTime>? scrollViewController;

  /// Источник данных для прокрутки по месяцам.
  ///
  /// Если не указан, создаётся автоматически на основе [range].
  /// Владелец переданного источника отвечает за вызов [dispose()].
  final ACScrollViewDataSource<DateTime>? scrollViewDataSource;

  /// Дата, к которой будет выполнена прокрутка при первом открытии.
  ///
  /// Если не указана или выходит за пределы [range], используется текущая дата
  /// (или ближайший допустимый месяц).
  final DateTime? initialDate;

  /// Вызывается при смене видимого месяца во время прокрутки.
  final void Function(DateTime visibleDate)? onVisibleDateChanged;

  /// Виджет, отображаемый под лентой месяцев (например, ввод времени).
  ///
  /// Должен реализовывать [PreferredSizeWidget] для корректного расчёта высоты.
  final PreferredSizeWidget? timeWidget;

  /// Отступы вокруг ленты месяцев.
  final EdgeInsetsGeometry? scrollViewPadding;

  /// Отступы вокруг [ACWeekWidget].
  final EdgeInsetsGeometry? weekPadding;

  /// Отступы вокруг [timeWidget].
  final EdgeInsetsGeometry? timeWidgetPadding;

  @override
  State<ACRawCalendarWidget> createState() => _ACRawCalendarWidgetState();
}

class _ACRawCalendarWidgetState extends State<ACRawCalendarWidget> {
  late final ACCalendarRepository _calendarRepository =
      widget.repository ?? const ACDefaultCalendarRepository();

  /// Кэш данных месяцев (до 12 месяцев).
  final _monthDataCache = ACCache<DateTime, ACCalendarMonthCache>(12);

  /// Диапазон допустимых месяцев, нормализованный к началу месяца.
  late ACDateRange _range;

  /// Текущий видимый месяц.
  late DateTime _currentMonth;

  /// Контроллер вертикальной прокрутки между месяцами.
  late ACScrollViewController<DateTime> _scrollViewController;

  /// Источник данных для ACScrollView.
  late ACScrollViewDataSource<DateTime> _scrollViewDataSource;

  @override
  void initState() {
    super.initState();

    _range = ACDateRange(
      min: _calendarRepository.startOfMonth(widget.range.min),
      max: _calendarRepository.startOfMonth(widget.range.max),
    );

    _currentMonth = _range.clampDate(
      _calendarRepository.startOfMonth(widget.initialDate ?? DateTime.now()),
    );

    _scrollViewController =
        widget.scrollViewController ?? ACScrollViewController<DateTime>();

    _scrollViewDataSource =
        widget.scrollViewDataSource ?? _createDefaultDataSource();
  }

  /// Создаёт внутренний источник данных на основе текущего диапазона.
  ACDefaultScrollViewDataSource<DateTime> _createDefaultDataSource() =>
      ACDefaultScrollViewDataSource<DateTime>(
        initialItem: _currentMonth,
        onBefore: (month) {
          final prev = _calendarRepository.addMonths(month, -1);
          return prev.isBefore(_range.min) ? null : prev;
        },
        onAfter: (month) {
          final next = _calendarRepository.addMonths(month, 1);
          return next.isAfter(_range.max) ? null : next;
        },
      );

  @override
  void didUpdateWidget(ACRawCalendarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.scrollViewController != widget.scrollViewController) {
      if (_scrollViewController != oldWidget.scrollViewController) {
        _scrollViewController.dispose();
      }
      _scrollViewController =
          widget.scrollViewController ?? ACScrollViewController<DateTime>();
    }

    if (oldWidget.scrollViewDataSource != widget.scrollViewDataSource) {
      if (_scrollViewDataSource != oldWidget.scrollViewDataSource) {
        _scrollViewDataSource.dispose();
      }
      _scrollViewDataSource =
          widget.scrollViewDataSource ?? _createDefaultDataSource();
    }

    if (oldWidget.range.min != widget.range.min ||
        oldWidget.range.max != widget.range.max) {
      _range = ACDateRange(
        min: _calendarRepository.startOfMonth(widget.range.min),
        max: _calendarRepository.startOfMonth(widget.range.max),
      );

      _currentMonth = _range.clampDate(_currentMonth);
      _scrollViewController.jumpToItem(_currentMonth);
    }
  }

  @override
  void dispose() {
    if (_scrollViewController != widget.scrollViewController) {
      _scrollViewController.dispose();
    }
    if (_scrollViewDataSource != widget.scrollViewDataSource) {
      _scrollViewDataSource.dispose();
    }
    super.dispose();
  }

  /// Возвращает кэшированные данные месяца или вычисляет их.
  ACCalendarMonthCache _getMonthCache(DateTime monthDate) =>
      _monthDataCache.putIfAbsent(monthDate, () {
        final days = _calendarRepository.getMonthDays(monthDate);

        final weeksCount = (days.length / 7).toInt();
        final ACMonthLayout layout = switch (weeksCount) {
          4 => ACDefaultMonthLayout.mainAxisCount4,
          5 => ACDefaultMonthLayout.mainAxisCount5,
          6 => ACDefaultMonthLayout.mainAxisCount6,
          _ => ACDefaultMonthLayout(mainAxisCount: weeksCount),
        };

        return ACCalendarMonthCache(days: days, layout: layout);
      });

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final timeWidget = widget.timeWidget;

          double itemExtentBuilder(DateTime monthDate) =>
              ACTitledMonthWidget.headerHeight +
              ACTitledMonthWidget.spacing +
              _getMonthCache(monthDate)
                  .layout
                  .calculateHeight(constraints.maxWidth);

          Widget itemBuilder(BuildContext context, DateTime monthDate) {
            final monthData = _getMonthCache(monthDate);
            final height = ACTitledMonthWidget.headerHeight +
                ACTitledMonthWidget.spacing +
                monthData.layout.calculateHeight(constraints.maxWidth);

            return SizedBox(
              width: constraints.maxWidth,
              height: height,
              child: RepaintBoundary(
                child: ACTitledMonthWidget(
                  layout: monthData.layout,
                  days: monthData.days,
                  monthDate: monthDate,
                ),
              ),
            );
          }

          final scrollView = ACScrollView<DateTime>(
              controller: _scrollViewController,
              dataSource: _scrollViewDataSource,
              spacing: 40,
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              padding: widget.scrollViewPadding ?? EdgeInsets.zero,
              itemExtentBuilder: itemExtentBuilder,
              onVisibleItemChanged: (monthDate) {
                _currentMonth = monthDate;
                widget.onVisibleDateChanged?.call(monthDate);
              },
              itemBuilder: itemBuilder);

          return Column(
            children: [
              Padding(
                padding: widget.weekPadding ?? const EdgeInsets.only(bottom: 8),
                child: ACWeekWidget(
                  repository: widget.repository,
                ),
              ),
              Expanded(child: scrollView),
              if (timeWidget != null)
                Padding(
                  padding:
                      widget.timeWidgetPadding ?? const EdgeInsets.only(top: 8),
                  child: timeWidget,
                ),
            ],
          );
        },
      );
}
