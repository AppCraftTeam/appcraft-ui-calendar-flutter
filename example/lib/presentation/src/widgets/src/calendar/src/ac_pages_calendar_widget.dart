import 'package:flutter/material.dart';

import '../../../../../../data/src/ac_cache.dart';
import '../../../../../../data/src/ac_calendar_repository.dart';
import '../../../../../../domain/src/ac_date_range.dart';
import '../../../../../presentation.dart';

/// Календарь с постраничной навигацией по месяцам.
///
/// Отображает один месяц за раз с возможностью горизонтальной прокрутки
/// между месяцами в пределах заданного диапазона [range].
///
/// Включает заголовок с навигацией, строку дней недели и сетку дат месяца.
/// При нажатии на заголовок открывается [ACMonthPicker] для быстрого
/// перехода к нужному месяцу.
class ACPagesCalendarWidget extends StatefulWidget {
  const ACPagesCalendarWidget({
    required this.range,
    this.weekStart,
    this.locale,
    this.theme,
    this.selectController,
    this.initialMonth,
    this.spacing,
    super.key,
  });

  /// Допустимый диапазон дат для навигации.
  final ACDateRange range;

  /// День начала недели (0 — воскресенье, 1 — понедельник и т. д.).
  ///
  /// Если не указан, используется локальное значение по умолчанию.
  final int? weekStart;

  /// Локаль для форматирования дат (например, `'ru'`, `'en'`).
  ///
  /// Если не указана, используется системная локаль.
  final String? locale;

  /// Тема оформления календаря.
  ///
  /// Если не указана, используется [ACLightCalendarThemeData].
  final ACCalendarThemeData? theme;

  /// Контроллер выбора дат.
  ///
  /// Если не указан, выбор дат не поддерживается.
  final ACCalendarSelectController? selectController;

  /// Месяц, отображаемый при первом открытии календаря.
  ///
  /// Если не указан или выходит за пределы [range], используется
  /// текущий месяц (или ближайший допустимый).
  final DateTime? initialMonth;

  /// Отступ между элементами календаря (заголовок, строка недели, сетка дат).
  ///
  /// Если не указан, используется значение по умолчанию `12.0`.
  final double? spacing;

  @override
  State<ACPagesCalendarWidget> createState() => _ACPagesCalendarWidgetState();
}

class _ACPagesCalendarWidgetState extends State<ACPagesCalendarWidget> {
  final _repository = const ACCalendarRepository();

  /// Кэш списков дней для каждого месяца (последние 12 месяцев).
  final _daysCache = ACCache<DateTime, List<DateTime>>(12);

  ACDefaultMonthLayout get _layout => ACDefaultMonthLayout.mainAxisCount6;

  /// Диапазон допустимых месяцев, нормализованный к началу месяца.
  late ACDateRange _range;

  /// Месяц, с которого начинается отображение (используется при создании контроллера).
  late DateTime _initialMonth;

  /// Текущий видимый месяц.
  late DateTime _currentMonth;

  /// Контроллер горизонтальной прокрутки между месяцами.
  ///
  /// Создаётся лениво в [build], пересоздаётся при изменении диапазона дат.
  ACScrollViewController<DateTime>? _scrollViewController;

  /// Флаг отображения выбора месяца вместо сетки дат.
  var _monthPickerShow = false;

  @override
  void initState() {
    _range = ACDateRange(
      min: _repository.startOfMonth(widget.range.min),
      max: _repository.startOfMonth(widget.range.max)
    );

    _initialMonth = _range.clampDate(
      _repository.startOfMonth(widget.initialMonth ?? DateTime.now())
    );

    _currentMonth = _initialMonth;

    super.initState();
  }

  @override
  void didUpdateWidget(ACPagesCalendarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Пересоздаём контроллер при изменении диапазона, так как range
    // передаётся в ACDateRangeScrollViewController через замыкания конструктора
    // и не может быть обновлён без пересоздания контроллера.
    if (
      widget.range.min != oldWidget.range.min ||
      widget.range.max != oldWidget.range.max
    ) {
      _range = ACDateRange(
        min: _repository.startOfMonth(widget.range.min),
        max: _repository.startOfMonth(widget.range.max),
      );

      _scrollViewController?.dispose();
      _scrollViewController = null;

      // Зажимаем текущий месяц в новый диапазон, чтобы не оказаться
      // за его пределами после обновления.
      _currentMonth = _range.clampDate(_currentMonth);
      _initialMonth = _currentMonth;
    }
  }

  @override
  void dispose() {
    _scrollViewController?.dispose();
    super.dispose();
  }

  /// Возвращает список дат для отображения в сетке [monthDate].
  ///
  /// Результат кэшируется, чтобы избежать повторных вычислений при перестройке.
  List<DateTime> _getDays(DateTime monthDate) =>
    _daysCache.putIfAbsent(monthDate, () =>
      _repository.getMonthDays(monthDate, weekStart: widget.weekStart),
    );

  @override
  Widget build(BuildContext context) =>
    LayoutBuilder(
      builder: (context, constraints) {
        final spacing = widget.spacing ?? 12.0;
        final monthWidth = constraints.maxWidth;
        final monthHeight = _layout.calculateHeight(monthWidth);

        // Контроллер создаётся один раз и переиспользуется между перестройками.
        // Обнуляется в didUpdateWidget при изменении range.
        _scrollViewController ??= ACDateRangeScrollViewController(
          range: _range,
          initialMonth: _initialMonth,
          itemExtentBuilder: (monthDate) => monthWidth,
          onVisibleItemChanged: (monthDate) => setState(() {
            _currentMonth = monthDate;
          }),
        );

        final scrollController = _scrollViewController!;

        final weekWidget = ACWeekWidget(
          weekStart: widget.weekStart,
          locale: widget.locale,
        );

        final headerWidget = ACPagesCalendarHeader(
          monthDate: _currentMonth,
          locale: widget.locale,
          monthPickerShow: _monthPickerShow,
          onPrevious: scrollController.shouldBefore ?
            scrollController.animateToBeforeItem :
            null,
          onNext: scrollController.shouldAfter ?
            scrollController.animateToAfterItem :
            null,
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
            controller: scrollController,
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
          range: _range,
          onDateChanged: scrollController.jumpToItem,
          initialDate: _currentMonth,
          locale: widget.locale,
        );

        return ACCalendarScope(
          theme: widget.theme,
          dateRange: widget.range,
          selectController: widget.selectController,
          child: Column(
            spacing: spacing,
            children: [
              headerWidget,

              SizedBox(
                height: weekWidget.preferredSize.height + spacing + monthHeight,
                child: _monthPickerShow ?
                  monthPicker() :
                  Column(
                    spacing: spacing,
                    children: [
                      weekWidget,
                      scrollView(),
                    ],
                  ),
              ),
            ],
          ),
        );
      },
    );
}
