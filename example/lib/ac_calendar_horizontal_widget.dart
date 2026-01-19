import 'package:example/ac_calendar_horizontal_header.dart';
import 'package:example/ac_calendar_month_widget.dart';
import 'package:example/ac_calendar_repository.dart';
import 'package:example/ac_calendar_view.dart';
import 'package:example/ac_calendar_week.dart';
import 'package:flutter/material.dart';

class ACCalendarHorizontalWidget extends StatefulWidget {
  const ACCalendarHorizontalWidget({
    required this.minDate,
    required this.maxDate,
    required this.weekStart,
    super.key,
  });

  final DateTime minDate;
  final DateTime maxDate;
  final int weekStart;

  factory ACCalendarHorizontalWidget.defaultRange() {
    final now = DateTime.now();

    return ACCalendarHorizontalWidget(
      minDate: DateTime(now.year - 1, 1, 1),
      maxDate: DateTime(now.year, 12, 31),
      weekStart: DateTime.monday,
    );
  }

  @override
  State<ACCalendarHorizontalWidget> createState() => _ACCalendarHorizontalWidgetState();
}

class _ACCalendarHorizontalWidgetState extends State<ACCalendarHorizontalWidget> {
  final _calendarController = ACCalendarViewController<DateTime>();
  final _calendarRepository = ACCalendarRepository();
  var _monthDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12,
      children: [
        ACCalendarHorizontalHeader(
          monthDate: _monthDate,
          onPrevious: () => _calendarController.animateToPrevious(),
          onNext: () => _calendarController.animateToNext(),
        ),
        
        ACCalendarWeekWidget(
          weekStart: widget.weekStart,
        ),

        Expanded(
          child: ACCalendarView<DateTime>(
            controller: _calendarController,
            initialItem: _calendarRepository.startOfMonth(DateTime.now()),
            windowSize: 5,
            onBefore: (date) => _calendarRepository.addMonths(date, -1),
            onAfter: (date) => _calendarRepository.addMonths(date, 1),
            onPageChanged: (date) => setState(() {
              _monthDate = date;
            }),
            itemBuilder: (context, date) =>
              ACCalendarMonthWidget(
                monthDate: date
              )
          ),
        ),
      ],
    );
  }
}
