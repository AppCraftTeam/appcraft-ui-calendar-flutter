import 'package:flutter/material.dart';

import '../../../../../presentation.dart';

/// Виджет ввода диапазона времени.
///
/// Отображает два [ACTimeInputWidget] (начало и конец) с разделителем между ними.
/// Если [controller] не передан, создаёт внутренний контроллер автоматически.
class ACTimeRangeInputWidget extends StatefulWidget {
  /// Создаёт виджет ввода диапазона времени.
  const ACTimeRangeInputWidget({
    this.controller,
    this.theme,
    this.separator = '–',
    this.spacing = 8,
    super.key,
  });

  /// Контроллер диапазона. Если `null`, создаётся внутренний.
  final ACTimeRangeInputController? controller;

  /// Тема оформления. Если не задана, берётся из [ACCalendarTheme].
  final ACTimeInputThemeData? theme;

  /// Разделитель между полями начала и конца.
  final String separator;

  /// Горизонтальный отступ вокруг разделителя.
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
    final theme = widget.theme ?? ACCalendarTheme.of(context).timeInputTheme;

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
