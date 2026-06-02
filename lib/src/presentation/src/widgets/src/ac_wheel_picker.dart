import 'package:flutter/material.dart';

import '../../theme/src/ac_calendar_theme_data.dart';
import '../../theme/src/ac_wheel_picker_theme_data.dart';

/// Wheel picker for selecting an item from a list.
///
/// Displays items as a scrollable wheel
/// with a scaling effect for inactive positions.
class ACWheelPicker<T> extends StatefulWidget {
  /// Creates a wheel picker.
  const ACWheelPicker({
    this.items = const [],
    this.onSelectedItemChanged,
    this.textForItem,
    this.initialItem,
    this.itemExtent = 36.0,
    this.theme,
    super.key,
  });

  /// List of items to display in the wheel.
  final List<T> items;

  /// Called when the selected item changes.
  final void Function(T item)? onSelectedItemChanged;

  /// Converts an item to a string for display.
  /// If not set, the item's toString() is used.
  final String Function(T item)? textForItem;

  /// Item selected on initialization.
  /// If not found in [items], the first item is used.
  final T? initialItem;

  /// Height of a single wheel item in pixels.
  final double itemExtent;

  /// Wheel picker theme. If not set, taken from [ACCalendarThemeData].
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

    return ListWheelScrollView.useDelegate(
      controller: _controller,
      itemExtent: widget.itemExtent,
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

          // Reduce size by 14% for each position away from the center
          final scale = (1.0 - (distance * .14)).clamp(.3, 1.0);

          final item = widget.items[index];
          final text = widget.textForItem?.call(item) ?? item.toString();

          final textColor = _selectedIndex == index
              ? theme.selectedItemTextColor
              : theme.itemTextColor;

          return GestureDetector(
            onTap: () => _controller.animateToItem(index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut),
            child: Center(
                child: Transform.scale(
              scale: scale,
              child: Text(text,
                  textAlign: TextAlign.center,
                  style: theme.itemTextStyle.copyWith(color: textColor)),
            )),
          );
        },
      ),
    );
  }
}
