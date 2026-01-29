import 'package:flutter/material.dart';

import '../../../../../../domain/domain.dart';
import '../../../../../presentation.dart';

class ACCalendarCard extends StatelessWidget {
  const ACCalendarCard({
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
  Widget build(BuildContext context) =>
    Container(
      decoration: BoxDecoration(
        // TODO: Add to theme
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(16)
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 16
      ),
      child: ACCalendarHorizontalWidget(
        range: range,
        weekStart: weekStart,
        locale: locale,
        theme: theme,
        selectController: selectController,
      ),
    );
}