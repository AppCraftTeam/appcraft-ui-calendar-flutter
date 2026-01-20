import 'package:example/presentation/src/ac_calendar_horizontal_header.dart';
import 'package:example/presentation/src/ac_calendar_month_picker.dart';
import 'package:example/presentation/src/ac_calendar_month_widget.dart';
import 'package:example/ac_calendar_repository.dart';
import 'package:example/ac_date_range.dart';
import 'package:example/ac_pager.dart';
import 'package:example/presentation/src/ac_calendar_week_widget.dart';
import 'package:flutter/material.dart';

class ACCalendarHorizontalWidget extends StatefulWidget {
  const ACCalendarHorizontalWidget({
    required this.range,
    this.weekStart = DateTime.monday,
    super.key,
  });

  final ACDateRange range;
  final int weekStart;

  @override
  State<ACCalendarHorizontalWidget> createState() => _ACCalendarHorizontalWidgetState();
}

class _ACCalendarHorizontalWidgetState extends State<ACCalendarHorizontalWidget> {
  final _pagerController = ACPagerController();
  final _calendarRepository = ACCalendarRepository();
  var _monthDate = DateTime.now();

  bool _monthPickerShow = false;

  @override
  Widget build(BuildContext context) =>
    Column(
      spacing: 12,
      children: [
        ACCalendarHorizontalHeader(
          monthPickerShow: _monthPickerShow,
          onMonthTap: () => setState(() {
            _monthPickerShow = !_monthPickerShow;
          }),
          monthDate: _monthDate,
          onPrevious: _monthDate.isBefore(widget.range.min) ?
            null :
            () => _pagerController.animateToPrevious(),
          onNext: _monthDate.isAfter(widget.range.max) ?
            null :
            () => _pagerController.animateToNext()
        ),
        
        if (!_monthPickerShow)
          ACCalendarWeekWidget(
            weekStart: widget.weekStart,
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
                ACCalendarMonthWidget(
                  monthDate: date
                )
            ),
          ),

        if (_monthPickerShow)
          Expanded(
            child: ACCalendarMonthPicker(
              range: widget.range,
              onDateChanged: (date) => _pagerController.jumpToItem(date)
            )
          )
      ],
    );
}
