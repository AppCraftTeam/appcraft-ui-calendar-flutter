import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../theme/src/ac_calendar_theme_data.dart';
import '../../../../theme/src/ac_time_input_theme_data.dart';
import 'ac_time_input_controller.dart';

/// Time input widget with the `HH:MM` mask.
///
/// Accepts digits only. Automatically inserts a colon after the hours.
/// Character-by-character validation: hours 00–23, minutes 00–59.
///
/// Use [ACTimeInputController] to manage the value.
/// If no controller is provided, the widget works standalone.
class ACTimeInputWidget extends StatefulWidget {
  /// Creates a time input widget.
  const ACTimeInputWidget({
    this.controller,
    this.theme,
    this.decoration,
    this.hintText = '00:00',
    super.key,
  });

  /// Controller for managing the time value.
  final ACTimeInputController? controller;

  /// Visual theme. If not set, taken from [ACCalendarThemeData].
  final ACTimeInputThemeData? theme;

  /// Additional decoration for the [TextField].
  final InputDecoration? decoration;

  /// Hint text shown when the field is empty.
  final String hintText;

  @override
  State<ACTimeInputWidget> createState() => _ACTimeInputWidgetState();
}

class _ACTimeInputWidgetState extends State<ACTimeInputWidget> {
  late final TextEditingController _textController;
  late final FocusNode _focusNode;
  bool _updatingFromController = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _textController = TextEditingController(
      text: _formatTime(widget.controller?.time),
    );
    widget.controller?.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(ACTimeInputWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_onControllerChanged);
      widget.controller?.addListener(_onControllerChanged);
      _textController.text = _formatTime(widget.controller?.time);
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onControllerChanged);
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /// Synchronizes the text field on external controller changes.
  void _onControllerChanged() {
    if (_updatingFromController) return;
    final formatted = _formatTime(widget.controller?.time);
    if (_textController.text != formatted) {
      _textController.text = formatted;
      _textController.selection = TextSelection.collapsed(
        offset: formatted.length,
      );
    }
  }

  /// Formats [TimeOfDay] into an `HH:MM` string.
  String _formatTime(TimeOfDay? time) {
    if (time == null) return '';
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  /// Parses a string into [TimeOfDay]. Returns `null` if the input is incomplete or invalid.
  TimeOfDay? _parseTime(String text) {
    final digits = text.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 4) return null;
    final hour = int.parse(digits.substring(0, 2));
    final minute = int.parse(digits.substring(2, 4));
    if (hour > 23 || minute > 59) return null;
    return TimeOfDay(hour: hour, minute: minute);
  }

  /// Updates the controller when the user changes the text.
  void _onChanged(String text) {
    if (widget.controller == null) return;
    final time = _parseTime(text);
    _updatingFromController = true;
    widget.controller!.time = time;
    _updatingFromController = false;
  }

  @override
  Widget build(BuildContext context) {
    final theme =
        widget.theme ?? ACCalendarThemeExtension.of(context).timeInputTheme;

    final effectiveDecoration =
        (widget.decoration ?? const InputDecoration()).copyWith(
      hintText: widget.hintText,
      hintStyle: theme.textStyle.copyWith(color: theme.hintColor),
      border: InputBorder.none,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      isDense: true,
      isCollapsed: true,
    );

    return Container(
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: _textController,
        focusNode: _focusNode,
        keyboardType: TextInputType.number,
        textAlignVertical: TextAlignVertical.center,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          _TimeInputFormatter(),
        ],
        style: theme.textStyle.copyWith(color: theme.textColor),
        cursorColor: theme.cursorColor,
        decoration: effectiveDecoration,
        onChanged: _onChanged,
        onTapOutside: (_) => _focusNode.unfocus(),
      ),
    );
  }
}

/// Time input formatter with character-by-character validation.
///
/// Automatically inserts a colon after two hour digits.
/// Restricts input: first hour digit 0–2, second 0–3 (when first = 2),
/// first minute digit 0–5, second 0–9.
class _TimeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    final buffer = StringBuffer();
    var cursorOffset = 0;

    for (var i = 0; i < digits.length && i < 4; i++) {
      final digit = int.parse(digits[i]);

      switch (i) {
        case 0:
          if (digit > 2) continue;
        case 1:
          final firstHourDigit = int.parse(buffer.toString()[0]);
          if (firstHourDigit == 2 && digit > 3) continue;
        case 2:
          if (digit > 5) continue;
        case 3:
          break;
      }

      if (i == 2) {
        buffer.write(':');
      }
      buffer.write(digits[i]);
    }

    final text = buffer.toString();
    cursorOffset = text.length;

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: cursorOffset),
    );
  }
}
