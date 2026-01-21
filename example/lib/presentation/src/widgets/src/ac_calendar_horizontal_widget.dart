import 'package:flutter/material.dart';

import '../../../../data/src/ac_calendar_repository.dart';
import '../../../../domain/src/ac_date_range.dart';
import '../../../presentation.dart';
// TODO: Добавить анимацию появления пикера
class ACCalendarHorizontalWidget extends StatefulWidget {
  const ACCalendarHorizontalWidget({
    required this.range,
    this.weekStart,
    this.locale,
    this.theme,
    this.selectController,
    super.key,
  });

  final ACDateRange range;
  final int? weekStart;
  final String? locale;
  final ACCalendarThemeData? theme;
  final ACCalendarSelectController? selectController;

  @override
  State<ACCalendarHorizontalWidget> createState() => _ACCalendarHorizontalWidgetState();
}

class _ACCalendarHorizontalWidgetState extends State<ACCalendarHorizontalWidget> {
  final _pagerController = ACPagerController<DateTime>();
  final _calendarRepository = const ACCalendarRepository();

  var _monthDate = DateTime.now();
  var _monthPickerShow = false;

  @override
  void initState() {
    widget.selectController?.addListener(_selectControllerListener);
    super.initState();
  }

  @override
  void didUpdateWidget(ACCalendarHorizontalWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectController != widget.selectController) {
      oldWidget.selectController?.removeListener(_selectControllerListener);
      widget.selectController?.addListener(_selectControllerListener);
    }
  }

  void _selectControllerListener() =>
    setState(() {});

  @override
  Widget build(BuildContext context) =>
    Column(
      spacing: 12,
      children: [
        ACCalendarHorizontalHeader(
          monthPickerShow: _monthPickerShow,
          theme: widget.theme?.calendarHeaderTheme,
          locale: widget.locale,
          onMonthTap: () => setState(() {
            _monthPickerShow = !_monthPickerShow;
          }),
          monthDate: _monthDate,
          onPrevious: _monthDate.isBefore(widget.range.min) ?
            null :
            _pagerController.animateToPrevious,
          onNext: _monthDate.isAfter(widget.range.max) ?
            null :
            _pagerController.animateToNext
        ),
        
        if (!_monthPickerShow)
          ACWeekWidget(
            weekStart: widget.weekStart,
            locale: widget.locale,
            theme: widget.theme?.weekTheme
          ),

        if (!_monthPickerShow)
          Expanded(
            child: ACPager<DateTime>(
              controller: _pagerController,
              initialItem: _calendarRepository.startOfMonth(DateTime.now()),
              onBefore: (date) => date.isBefore(widget.range.min) ?
                null :
                _calendarRepository.addMonths(date, -1),
              onAfter: (date) => date.isAfter(widget.range.max) ?
                null :
                _calendarRepository.addMonths(date, 1),
              onPageChanged: (date) => setState(() {
                _monthDate = date;
              }),
              itemBuilder: (context, date) =>
                ACMonthWidget(
                  monthDate: date,
                  theme: widget.theme,
                  onSelectDay: widget.selectController?.selectDay,
                  selectStyleForDay: widget.selectController?.selectStyleForDay
                )
            ),
          ),

        if (_monthPickerShow)
          Expanded(
            child: ACMonthPicker(
              range: widget.range,
              theme: widget.theme,
              locale: widget.locale,
              onDateChanged: (date) {
                setState(() {
                  _monthDate = date;
                });
                _pagerController.jumpToItem(date);
              }
            )
          )
      ],
    );
}
