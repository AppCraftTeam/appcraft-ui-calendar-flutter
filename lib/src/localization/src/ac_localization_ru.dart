import 'ac_localization.dart';

/// Русская локализация календаря.
class ACLocalizationRu extends ACLocalization {
  /// Создаёт русскую локализацию.
  const ACLocalizationRu();

  @override
  String get time => 'Время';

  @override
  String get selectMonth => 'Выбрать месяц';

  @override
  String get done => 'Готово';
}
