import 'package:flutter/material.dart';

import '../../../../domain/domain.dart';
import '../../../presentation.dart';

class ACCalendarHorizontalSheet extends StatelessWidget {
  const ACCalendarHorizontalSheet({
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

  static Future<void> show(
    BuildContext context,
    {
      required ACDateRange range,
      int? weekStart,
      String? locale,
      ACCalendarThemeData? theme,
      ACCalendarSelectController? selectController,
      // TODO: Add to theme
      Color? backgroundColor
    }
  ) => showModalBottomSheet<void>(
      context: context,
      isScrollControlled: false,
      isDismissible: true,
      enableDrag: true,
      useSafeArea: true,
      backgroundColor: backgroundColor,
      builder: (context) => ACCalendarHorizontalSheet(
        range: range,
        weekStart: weekStart,
        locale: locale,
        theme: theme,
        selectController: selectController,
      )
    );

  @override
  Widget build(BuildContext context) =>
    Padding(
      padding: const EdgeInsets.all(16),
      child: ACCalendarHorizontalWidget(
        range: range,
        weekStart: weekStart,
        locale: locale,
        theme: theme,
        selectController: selectController,
      ),
    );
}