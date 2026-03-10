import 'package:flutter/material.dart';

import '../../../../../../data/src/ac_cache.dart';
import '../../../../../../data/src/ac_calendar_repository.dart';
import '../../../../../../data/src/ac_default_calendar_repository.dart';
import '../../../../../../domain/src/ac_date_range.dart';
import '../../../../../presentation.dart';

/// Календарь с постраничной навигацией по месяцам без [ACCalendarScope].
class ACRawPagesCalendarWidget extends StatefulWidget {
  const ACRawPagesCalendarWidget({
    required this.range,
    this.scrollViewController,
    this.scrollViewDataSource,
    this.repository,
    this.locale,
    this.initialMonth,
    this.spacing,
    this.timeWidget,
    super.key,
  });

  /// Репозиторий для вычислений календаря.
  ///
  /// Если не указан, используется [ACDefaultCalendarRepository].
  final ACCalendarRepository? repository;

  /// Допустимый диапазон дат для навигации.
  final ACDateRange range;

  /// Локаль для форматирования дат (например, `'ru'`, `'en'`).
  ///
  /// Если не указана, используется системная локаль.
  final String? locale;

  /// Месяц, отображаемый при первом открытии календаря.
  ///
  /// Если не указан или выходит за пределы [range], используется
  /// текущий месяц (или ближайший допустимый).
  final DateTime? initialMonth;

  /// Отступ между элементами календаря (заголовок, строка недели, сетка дат).
  ///
  /// Если не указан, используется значение по умолчанию `12.0`.
  final double? spacing;

  /// Виджет, отображаемый под сеткой дат (например, ввод времени).
  ///
  /// Должен реализовывать [PreferredSizeWidget] для корректного расчёта высоты.
  final PreferredSizeWidget? timeWidget;

  /// Внешний контроллер прокрутки между месяцами.
  ///
  /// Если передан, виджет использует его вместо создания внутреннего.
  /// Вызывающий код несёт ответственность за вызов [ACScrollViewController.dispose].
  final ACScrollViewController<DateTime>? scrollViewController;

  /// Внешний источник данных для [ACScrollView].
  ///
  /// Если передан, виджет использует его вместо создания внутреннего.
  /// Вызывающий код несёт ответственность за вызов [ACScrollViewDataSource.dispose].
  final ACScrollViewDataSource<DateTime>? scrollViewDataSource;

  @override
  State<ACRawPagesCalendarWidget> createState() =>
      _ACRawPagesCalendarWidgetState();
}

class _ACRawPagesCalendarWidgetState extends State<ACRawPagesCalendarWidget> {
  late final ACCalendarRepository _repository =
      widget.repository ?? const ACDefaultCalendarRepository();

  /// Кэш списков дней для каждого месяца (последние 12 месяцев).
  final _daysCache = ACCache<DateTime, List<DateTime>>(12);

  ACDefaultMonthLayout get _layout => ACDefaultMonthLayout.mainAxisCount6;

  /// Диапазон допустимых месяцев, нормализованный к началу месяца.
  late ACDateRange _range;

  /// Текущий видимый месяц.
  late DateTime _currentMonth;

  /// Контроллер горизонтальной прокрутки между месяцами.
  late final ACScrollViewController<DateTime> _scrollViewController;

  /// Источник данных для ACScrollView.
  late final ACScrollViewDataSource<DateTime> _scrollViewDataSource;

  /// Внутренний контроллер, созданный виджетом — уничтожается в [dispose].
  /// null, если контроллер был передан извне.
  ACScrollViewController<DateTime>? _ownedScrollViewController;

  /// Внутренний источник данных, созданный виджетом — уничтожается в [dispose].
  /// null, если источник данных был передан извне.
  ACScrollViewDataSource<DateTime>? _ownedScrollViewDataSource;

  /// Флаг отображения выбора месяца вместо сетки дат.
  var _monthPickerShow = false;

  @override
  void initState() {
    super.initState();

    _range = ACDateRange(
      min: _repository.startOfMonth(widget.range.min),
      max: _repository.startOfMonth(widget.range.max),
    );

    _currentMonth = _range.clampDate(
      _repository.startOfMonth(widget.initialMonth ?? DateTime.now()),
    );

    if (widget.scrollViewController != null) {
      _scrollViewController = widget.scrollViewController!;
    } else {
      final ctrl = ACScrollViewController<DateTime>();
      _ownedScrollViewController = ctrl;
      _scrollViewController = ctrl;
    }

    if (widget.scrollViewDataSource != null) {
      _scrollViewDataSource = widget.scrollViewDataSource!;
    } else {
      final ds = ACDefaultScrollViewDataSource<DateTime>(
        initialItem: _currentMonth,
        onBefore: (month) {
          final prev = _repository.addMonths(month, -1);
          return prev.isBefore(_range.min) ? null : prev;
        },
        onAfter: (month) {
          final next = _repository.addMonths(month, 1);
          return next.isAfter(_range.max) ? null : next;
        },
      );
      _ownedScrollViewDataSource = ds;
      _scrollViewDataSource = ds;
    }
  }

  @override
  void didUpdateWidget(ACRawPagesCalendarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.range.min != oldWidget.range.min ||
        widget.range.max != oldWidget.range.max) {
      _range = ACDateRange(
        min: _repository.startOfMonth(widget.range.min),
        max: _repository.startOfMonth(widget.range.max),
      );

      _currentMonth = _range.clampDate(_currentMonth);
      _scrollViewController.jumpToItem(_currentMonth);
    }
  }

  @override
  void dispose() {
    _ownedScrollViewController?.dispose();
    _ownedScrollViewDataSource?.dispose();
    super.dispose();
  }

  /// Возвращает список дат для отображения в сетке [monthDate].
  ///
  /// Результат кэшируется, чтобы избежать повторных вычислений при перестройке.
  List<DateTime> _getDays(DateTime monthDate) => _daysCache.putIfAbsent(
        monthDate,
        () => _repository.getMonthDays(monthDate),
      );

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final spacing = widget.spacing ?? 12.0;
          final monthWidth = constraints.maxWidth;
          final monthHeight = _layout.calculateHeight(monthWidth);

          final weekWidget = ACWeekWidget(
            repository: widget.repository,
            locale: widget.locale,
          );

          final headerWidget = ACPagesCalendarHeader(
            monthDate: _currentMonth,
            locale: widget.locale,
            monthPickerShow: _monthPickerShow,
            onPrevious: _scrollViewDataSource.shouldBefore
                ? _scrollViewController.animateToBeforeItem
                : null,
            onNext: _scrollViewDataSource.shouldAfter
                ? _scrollViewController.animateToAfterItem
                : null,
            onMonthTap: () => setState(() {
              _monthPickerShow = !_monthPickerShow;
            }),
          );

          Widget scrollView() => SizedBox(
                width: monthWidth,
                height: monthHeight,
                child: ACScrollView<DateTime>(
                  physics: const PageScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  controller: _scrollViewController,
                  dataSource: _scrollViewDataSource,
                  itemExtentBuilder: (_) => monthWidth,
                  onVisibleItemChanged: (monthDate) => setState(() {
                    _currentMonth = monthDate;
                  }),
                  itemBuilder: (context, monthDate) => SizedBox(
                    width: monthWidth,
                    height: monthHeight,
                    child: RepaintBoundary(
                      child: ACMonthWidget(
                        layout: _layout,
                        days: _getDays(monthDate),
                        monthDate: monthDate,
                      ),
                    ),
                  ),
                ),
              );

          Widget monthPicker() => ACMonthPicker(
                repository: widget.repository,
                range: _range,
                onDateChanged: _scrollViewController.jumpToItem,
                initialDate: _currentMonth,
                locale: widget.locale,
              );

          final timeWidget = widget.timeWidget;

          final contentHeight = [
            weekWidget.preferredSize.height,
            spacing,
            monthHeight,
            if (timeWidget != null) ...[
              spacing,
              timeWidget.preferredSize.height,
            ],
          ].fold<double>(0, (sum, v) => sum + v);

          return Column(
            spacing: spacing,
            children: [
              headerWidget,
              SizedBox(
                height: contentHeight,
                child: _monthPickerShow
                    ? monthPicker()
                    : Column(
                        spacing: spacing,
                        children: [
                          weekWidget,
                          scrollView(),
                          if (timeWidget != null) timeWidget
                        ],
                      ),
              )
            ],
          );
        },
      );
}
