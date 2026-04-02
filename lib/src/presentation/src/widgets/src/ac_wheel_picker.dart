import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../utils/src/accessibility_utils.dart';
import '../../theme/src/ac_calendar_theme_data.dart';
import '../../theme/src/ac_wheel_picker_theme_data.dart';

/// Колёсный пикер (wheel picker) для выбора элемента из списка.
///
/// Отображает элементы в виде прокручиваемого колеса
/// с эффектом масштабирования для неактивных позиций.
class ACWheelPicker<T> extends StatefulWidget {
  /// Создаёт колёсный пикер.
  const ACWheelPicker({
    this.items = const [],
    this.onSelectedItemChanged,
    this.textForItem,
    this.initialItem,
    this.itemExtent = 36.0,
    this.theme,
    super.key,
  });

  /// Список элементов для отображения в колесе.
  final List<T> items;

  /// Вызывается при смене выбранного элемента.
  final void Function(T item)? onSelectedItemChanged;

  /// Преобразует элемент в строку для отображения.
  /// Если не задан, используется toString() элемента.
  final String Function(T item)? textForItem;

  /// Элемент, выбранный при инициализации.
  /// Если не найден в [items], используется первый элемент.
  final T? initialItem;

  /// Высота одного элемента колеса в пикселях.
  final double itemExtent;

  /// Тема колёсного пикера. Если не задана, берётся из [ACCalendarThemeData].
  final ACWheelPickerThemeData? theme;

  @override
  State<ACWheelPicker<T>> createState() => _ACWheelPickerState<T>();
}

class _ACWheelPickerState<T> extends State<ACWheelPicker<T>> {
  late FixedExtentScrollController _controller;

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    if (widget.initialItem != null) {
      _selectedIndex = widget.items.indexOf(widget.initialItem as T);
      if (_selectedIndex == -1) _selectedIndex = 0;
    }

    _controller = FixedExtentScrollController(initialItem: _selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    final theme =
        widget.theme ?? ACCalendarThemeExtension.of(context).wheelPickerTheme;
    final textScaler = MediaQuery.textScalerOf(context);
    final scaledExtent = textScaler.scale(widget.itemExtent);
    final effectiveExtent = math.max(scaledExtent, 48.0);

    return ListWheelScrollView.useDelegate(
      controller: _controller,
      itemExtent: effectiveExtent,
      onSelectedItemChanged: (index) {
        setState(() {
          _selectedIndex = index;
        });
        widget.onSelectedItemChanged?.call(widget.items[index]);
      },
      physics: const FixedExtentScrollPhysics(),
      diameterRatio: 1.5,
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: widget.items.length,
        builder: (context, index) {
          final distance = (index - _selectedIndex).abs();

          // Уменьшение размера на 14% за каждую позицию от центра
          final scale = (1.0 - (distance * .14)).clamp(.3, 1.0);

          final item = widget.items[index];
          final text = widget.textForItem?.call(item) ?? item.toString();

          final textColor = _selectedIndex == index
              ? theme.selectedItemTextColor
              : theme.itemTextColor;

          final itemStyle = applyBoldText(
            theme.itemTextStyle.copyWith(color: textColor),
            context,
          );

          return GestureDetector(
            onTap: () => _controller.animateToItem(index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut),
            child: Center(
                child: Transform.scale(
              scale: scale,
              child: Text(text, textAlign: TextAlign.center, style: itemStyle),
            )),
          );
        },
      ),
    );
  }
}
