import 'package:flutter/material.dart';

class ACWheelPicker<T> extends StatefulWidget {
  const ACWheelPicker({
    required this.items,
    required this.onSelectedItemChanged,
    this.initialItem,
    this.itemExtent = 36.0,
    super.key,
  });

  final List<T> items;
  final void Function(T item) onSelectedItemChanged;
  final T? initialItem;
  final double itemExtent;

  @override
  State<ACWheelPicker<T>> createState() => _ACWheelPickerState<T>();
}

class _ACWheelPickerState<T> extends State<ACWheelPicker<T>> {
  late FixedExtentScrollController _controller;

  int _selectedIndex = 0;
  
  static const double _minOpacity = 0.5;

  @override
  void initState() {
    super.initState();

    if (widget.initialItem != null) {
      _selectedIndex = widget.items.indexOf(widget.initialItem as T);
      if (_selectedIndex == -1) _selectedIndex = 0;
    }

    _controller = FixedExtentScrollController(
      initialItem: _selectedIndex
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView.useDelegate(
      controller: _controller,
      itemExtent: widget.itemExtent,
      onSelectedItemChanged: (index) {
        setState(() {
          _selectedIndex = index;
        });
        widget.onSelectedItemChanged(widget.items[index]);
      },
      physics: const FixedExtentScrollPhysics(),
      diameterRatio: 1.5,
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: widget.items.length,
        builder: (context, index) {
          final distance = (index - _selectedIndex).abs();
          
          // Уменьшение размера на 14% за каждую позицию от центра
          final scale = (1.0 - (distance * 0.14)).clamp(0.3, 1.0);
          
          // Уменьшение прозрачности на 30% за каждую позицию от центра
          final opacity = (1.0 - (distance * 0.30)).clamp(_minOpacity, 1.0);
          
          return GestureDetector(
            onTap: () => _controller.animateToItem(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut
            ),
            child: Center(
              child: Opacity(
                opacity: opacity,
                child: Transform.scale(
                  scale: scale,
                  child: Text(
                    widget.items[index].toString(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}