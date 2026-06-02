import 'ac_localization.dart';

/// Russian calendar localization.
class ACLocalizationRu extends ACLocalization {
  /// Creates the Russian localization.
  const ACLocalizationRu();

  @override
  String get time => 'Время';

  @override
  String get calendar => 'Календарь';

  @override
  String get selectMonth => 'Выбрать месяц';

  @override
  String get done => 'Готово';
}
