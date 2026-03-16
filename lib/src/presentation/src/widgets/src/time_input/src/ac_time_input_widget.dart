import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../presentation.dart';

/// Виджет ввода времени с маской `HH:MM`.
///
/// Принимает только цифры. Автоматически вставляет двоеточие после часов.
/// Валидация посимвольная: часы 00–23, минуты 00–59.
///
/// Для управления значением используйте [ACTimeInputController].
/// Если контроллер не передан, виджет работает автономно.
class ACTimeInputWidget extends StatefulWidget {
  /// Создаёт виджет ввода времени.
  const ACTimeInputWidget({
    this.controller,
    this.theme,
    this.decoration,
    this.hintText = '00:00',
    super.key,
  });

  /// Контроллер для управления значением времени.
  final ACTimeInputController? controller;

  /// Тема оформления. Если не задана, берётся из [ACCalendarTheme].
  final ACTimeInputThemeData? theme;

  /// Дополнительная декорация для [TextField].
  final InputDecoration? decoration;

  /// Текст-подсказка, отображаемый при пустом поле.
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

  /// Синхронизирует текстовое поле при внешнем изменении контроллера.
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

  /// Форматирует [TimeOfDay] в строку `HH:MM`.
  String _formatTime(TimeOfDay? time) {
    if (time == null) return '';
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  /// Парсит строку в [TimeOfDay]. Возвращает `null`, если ввод неполный или невалидный.
  TimeOfDay? _parseTime(String text) {
    final digits = text.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 4) return null;
    final hour = int.parse(digits.substring(0, 2));
    final minute = int.parse(digits.substring(2, 4));
    if (hour > 23 || minute > 59) return null;
    return TimeOfDay(hour: hour, minute: minute);
  }

  /// Обновляет контроллер при изменении текста пользователем.
  void _onChanged(String text) {
    if (widget.controller == null) return;
    final time = _parseTime(text);
    _updatingFromController = true;
    widget.controller!.time = time;
    _updatingFromController = false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme ?? ACCalendarTheme.of(context).timeInputTheme;

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

/// Форматтер ввода времени с посимвольной валидацией.
///
/// Автоматически вставляет двоеточие после двух цифр часов.
/// Ограничивает ввод: первая цифра часов 0–2, вторая 0–3 (при первой = 2),
/// первая цифра минут 0–5, вторая 0–9.
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
