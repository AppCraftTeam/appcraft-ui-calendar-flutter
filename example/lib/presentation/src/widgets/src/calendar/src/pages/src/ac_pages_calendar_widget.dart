import 'package:flutter/material.dart';

import '../../../../../../../../data/src/ac_calendar_repository.dart';
import '../../../../../../../../domain/src/ac_date_range.dart';
import '../../../../../../../presentation.dart';
// TODO: Придумать, как логичнее получать высоту календаря
class ACPagesCalendarWidget extends StatefulWidget {
  const ACPagesCalendarWidget({
    required this.range,
    this.weekStart,
    this.locale,
    this.theme,
    this.selectController,
    this.initialMonth,
    this.spacing,
    this.childDelegate,
    super.key,
  });

  final ACDateRange range;
  final int? weekStart;
  final String? locale;
  final ACCalendarThemeData? theme;
  final ACCalendarSelectController? selectController;
  final DateTime? initialMonth;
  final double? spacing;

  /// Делегат для построения элементов календаря.
  ///
  /// Если не указан, используется [ACDefaultPagesCalendarChildDelegate].
  final ACPagesCalendarChildDelegate? childDelegate;

  @override
  State<ACPagesCalendarWidget> createState() => _ACPagesCalendarWidgetState();
}

class _ACPagesCalendarWidgetState extends State<ACPagesCalendarWidget> {
  final _repository = const ACCalendarRepository();

  late ACDateRange _range;
  late DateTime _initialMonth;
  late DateTime _currentMonth;

  ACScrollViewController<DateTime>? _scrollViewController;

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

  // TODO: Добавить перестроение, если в виджете передаются новый range или initalMonth (либо игнорировать initalMonth)

  @override
  Widget build(BuildContext context) =>
    LayoutBuilder(
      builder: (context, constraints) {
        final spacing = widget.spacing ?? 12.0;
        final monthWidth = constraints.maxWidth;

        _scrollViewController ??= ACDateRangeScrollViewController(
          range: _range,
          initialMonth: _initialMonth,
          itemExtentBuilder: (monthDate) => monthWidth,
          onVisibleItemChanged: (monthDate) => setState(() {
            _currentMonth = monthDate;
          })
        );

        final scrollController = _scrollViewController!;
        final layout = ACDefaultMonthLayout.mainAxisCount6;

        final delegate = widget.childDelegate ?? ACDefaultPagesCalendarChildDelegate(
          range: widget.range,
          layout: layout,
          weekStart: widget.weekStart,
          theme: widget.theme
        );

        final monthHeight = layout.calculateHeight(monthWidth);

        final weekWidget = ACWeekWidget(
          weekStart: widget.weekStart,
          locale: widget.locale,
          theme: widget.theme?.weekTheme,
        );

        final headerWidget = ACPagesCalendarHeader(
          monthDate: _currentMonth,
          locale: widget.locale,
          theme: widget.theme?.calendarHeaderTheme,
          monthPickerShow: _monthPickerShow,
          onPrevious: scrollController.shouldBefore ?
            scrollController.animateToBeforeItem :
            null,
          onNext: scrollController.shouldAfter ?
            scrollController.animateToAfterItem :
            null,
          onMonthTap: () => setState(() {
            _monthPickerShow = !_monthPickerShow;
          })
        );

        Widget scrollView() => SizedBox(
          width: monthWidth,
          height: monthHeight,
          child: ACCalendarSelectionScope(
            selectController: widget.selectController,
            child: ACScrollView<DateTime>(
              physics: const PageScrollPhysics(),
              scrollDirection: Axis.horizontal,
              controller: scrollController,
              itemBuilder: (context, monthDate) =>
                SizedBox(
                  width: monthWidth,
                  height: monthHeight,
                  child: delegate.buildItem(context, monthDate)
                )
            ),
          ),
        );

        Widget monthPicker() => ACMonthPicker(
          range: _range,
          onDateChanged: scrollController.jumpToItem,
          initialDate: _currentMonth,
          locale: widget.locale,
          theme: widget.theme
        );

        return Column(
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
                    scrollView()
                  ],
                ),
            )
          ],
        );
      }
    );
}
