import 'package:flutter/widgets.dart';

/// Применяет увеличенный [FontWeight] к [style], если в системе
/// включён режим жирного текста ([MediaQuery.boldTextOf]).
///
/// Маппинг весов при boldText == true:
/// w400 -> w700, w500 -> w700, w600 -> w800,
/// w700 -> w900, w800 -> w900, w900 -> w900.
///
/// Если `fontWeight` равен null, используется w400 (дефолт Flutter).
TextStyle applyBoldText(TextStyle style, BuildContext context) {
  if (!MediaQuery.boldTextOf(context)) {
    return style;
  }

  final current = style.fontWeight ?? FontWeight.w400;
  final FontWeight bold;

  if (current.value <= FontWeight.w500.value) {
    bold = FontWeight.w700;
  } else if (current == FontWeight.w600) {
    bold = FontWeight.w800;
  } else {
    bold = FontWeight.w900;
  }

  return style.copyWith(fontWeight: bold);
}
