import 'ac_localization.dart';
import 'ac_localization_en.dart';
import 'ac_localization_ru.dart';

class ACLocalizationManager {
  /// Приватный конструктор, чтобы предотвратить создание внешних экземпляров.
  ACLocalizationManager._();

  /// Статический единственный экземпляр класса.
  static final instance = ACLocalizationManager._();

  /// Словарь локализаций, где ключ — код языка, значение — объект локализации.
  final Map<String, ACLocalization> localizations = {
    'ru': const ACLocalizationRu(),
    'en': const ACLocalizationEn(),
  };

  /// Возвращает локализацию для [localeName].
  ///
  /// Порядок поиска:
  /// 1. Точное совпадение (`'en-US'`)
  /// 2. Только код языка (`'en'`)
  /// 3. Русский по умолчанию
  ACLocalization localization(String? localeName) {
    if (localeName == null) return const ACLocalizationRu();
    return localizations[localeName]
        ?? localizations[localeName.split('-').first]
        ?? const ACLocalizationRu();
  }
}
