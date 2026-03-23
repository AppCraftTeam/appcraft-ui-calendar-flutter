import 'ac_localization.dart';

/// Английская локализация календаря.
class ACLocalizationEn extends ACLocalization {
  /// Создаёт английскую локализацию.
  const ACLocalizationEn();

  @override
  String get time => 'Time';

  @override
  String get calendar => 'Calendar';

  @override
  String get selectMonth => 'Select month';

  @override
  String get done => 'Done';
}
