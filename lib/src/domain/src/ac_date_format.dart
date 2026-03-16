import 'package:intl/intl.dart';

/// Набор предустановленных форматов дат на основе [DateFormat].
///
/// Предоставляет именованные конструкторы для часто используемых
/// форматов отображения дат в календаре.
class ACDateFormat extends DateFormat {
  /// Сокращённое название дня недели (например, «Пн», «Вт»).
  ///
  /// Паттерн: `EEE`.
  ACDateFormat.weekday([String? locale]) : super('EEE', locale);

  /// Полное название месяца и год (например, «Февраль 2026»).
  ///
  /// Паттерн: `LLLL yyyy`.
  ACDateFormat.monthYear([String? locale]) : super('LLLL yyyy', locale);

  /// Полное название месяца (например, «Февраль»).
  ///
  /// Паттерн: `LLLL`.
  ACDateFormat.month([String? locale]) : super('LLLL', locale);
}
