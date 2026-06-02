import 'package:flutter/material.dart';

import '../../../../theme/src/ac_calendar_theme_data.dart';
import '../../../../theme/src/ac_time_input_theme_data.dart';
import 'ac_time_input_widget.dart';
import 'ac_time_range_input_controller.dart';

/// Time range input widget.
///
/// Displays two [ACTimeInputWidget]s (start and end) with a separator between them.
/// If [controller] is not provided, an internal controller is created automatically.
class ACTimeRangeInputWidget extends StatefulWidget {
  /// Creates a time range input widget.
  const ACTimeRangeInputWidget({
    this.controller,
    this.theme,
    this.separator = '–',
    this.spacing = 8,
    super.key,
  });

  /// Range controller. If `null`, an internal one is created.
  final ACTimeRangeInputController? controller;

  /// Visual theme. If not set, taken from [ACCalendarThemeData].
  final ACTimeInputThemeData? theme;

  /// Separator between the start and end fields.
  final String separator;

  /// Horizontal padding around the separator.
  final double spacing;

  @override
  State<ACTimeRangeInputWidget> createState() => _ACTimeRangeInputWidgetState();
}

class _ACTimeRangeInputWidgetState extends State<ACTimeRangeInputWidget> {
  late ACTimeRangeInputController _controller;
  bool _ownsController = false;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  @override
  void didUpdateWidget(ACTimeRangeInputWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _disposeOwnedController();
      _initController();
    }
  }

  @override
  void dispose() {
    _disposeOwnedController();
    super.dispose();
  }

  void _initController() {
    if (widget.controller != null) {
      _controller = widget.controller!;
      _ownsController = false;
    } else {
      _controller = ACTimeRangeInputController();
      _ownsController = true;
    }
  }

  void _disposeOwnedController() {
    if (_ownsController) {
      _controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme =
        widget.theme ?? ACCalendarThemeExtension.of(context).timeInputTheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: ACTimeInputWidget(
            controller: _controller.minController,
            theme: theme,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: widget.spacing),
          child: Text(
            widget.separator,
            style: theme.textStyle.copyWith(color: theme.textColor),
          ),
        ),
        Expanded(
          child: ACTimeInputWidget(
            controller: _controller.maxController,
            theme: theme,
          ),
        ),
      ],
    );
  }
}
