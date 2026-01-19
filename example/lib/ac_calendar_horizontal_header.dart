import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ACCalendarHorizontalHeader extends StatelessWidget {
  const ACCalendarHorizontalHeader({
    required this.monthDate,
    this.onPrevious,
    this.onNext,
    super.key
  });

  final DateTime monthDate;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          Text(
            DateFormat('MMMM yyyy').format(monthDate),
            style: TextStyle(
              fontSize: 17,
              height: 17/22,
              fontWeight: FontWeight.w600,
              color: Color(0XFF000000)
            ),
          ),

          IconButton(
            onPressed: onPrevious,
            icon: Icon(
              Icons.arrow_back_ios_rounded
            ),
            iconSize: 24,
          ),

          IconButton(
            onPressed: onNext,
            icon: Icon(
              Icons.arrow_forward_ios_rounded
            ),
            iconSize: 24,
          ),
        ],
      ),
    );
  }

}