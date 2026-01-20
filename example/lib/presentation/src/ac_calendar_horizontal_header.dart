import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ACCalendarHorizontalHeader extends StatelessWidget {
  const ACCalendarHorizontalHeader({
    required this.monthDate,
    this.monthPickerShow = false,
    this.onPrevious,
    this.onNext,
    this.onMonthTap,
    super.key
  });

  final DateTime monthDate;
  final bool monthPickerShow;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;
  final void Function()? onMonthTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          GestureDetector(
            onTap: onMonthTap,
            child: Text(
              DateFormat('MMMM yyyy').format(monthDate),
              style: TextStyle(
                fontSize: 17,
                height: 17/22,
                fontWeight: FontWeight.w600,
                color: Color(0XFF000000)
              ),
            ),
          ),

          Spacer(),

          if (!monthPickerShow)...[
            SizedBox.square(
              dimension: 24,
              child: IconButton(
                onPressed: onPrevious,
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                ),
                iconSize: 17,
                padding: const EdgeInsets.all(3)
              ),
            ),

            const SizedBox(width: 12),

            SizedBox.square(
              dimension: 24,
              child: IconButton(
                onPressed: onNext,
                icon: Icon(
                  Icons.arrow_forward_ios_rounded,
                ),
                iconSize: 17,
                padding: const EdgeInsets.all(3)
              ),
            ),
          ]
        ],
      ),
    );
  }

}