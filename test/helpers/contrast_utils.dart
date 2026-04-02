import 'dart:math';

import 'package:flutter/material.dart';

/// Вычисляет относительную яркость цвета по WCAG 2.1.
///
/// Формула: L = 0.2126 * R + 0.7152 * G + 0.0722 * B,
/// где R, G, B — линеаризованные sRGB-компоненты.
double relativeLuminance(Color color) {
  double linearize(double channel) {
    return channel <= 0.04045
        ? channel / 12.92
        : pow((channel + 0.055) / 1.055, 2.4).toDouble();
  }

  final r = linearize(color.red / 255.0);
  final g = linearize(color.green / 255.0);
  final b = linearize(color.blue / 255.0);
  return 0.2126 * r + 0.7152 * g + 0.0722 * b;
}

/// Вычисляет коэффициент контрастности между [foreground] и [background]
/// по формуле WCAG 2.1: (L1 + 0.05) / (L2 + 0.05), где L1 >= L2.
double contrastRatio(Color foreground, Color background) {
  final l1 = relativeLuminance(foreground);
  final l2 = relativeLuminance(background);
  final lighter = l1 > l2 ? l1 : l2;
  final darker = l1 > l2 ? l2 : l1;
  return (lighter + 0.05) / (darker + 0.05);
}

/// Композитирует полупрозрачный [foreground] на непрозрачный [background].
///
/// Возвращает результирующий непрозрачный цвет.
Color compositeOnBackground(Color foreground, Color background) {
  final alpha = foreground.opacity;
  final r = (foreground.red * alpha + background.red * (1 - alpha)).round();
  final g = (foreground.green * alpha + background.green * (1 - alpha)).round();
  final b = (foreground.blue * alpha + background.blue * (1 - alpha)).round();
  return Color.fromARGB(255, r, g, b);
}
