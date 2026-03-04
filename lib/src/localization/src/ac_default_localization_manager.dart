import 'ac_localization.dart';
import 'ac_localization_en.dart';
import 'ac_localization_manager.dart';
import 'ac_localization_ru.dart';

class ACDefaultLocalizationManager extends ACLocalizationManager {
  const ACDefaultLocalizationManager({
    this.localizations = const {
      'ru': ACLocalizationRu(),
      'en': ACLocalizationEn(),
    },
    this.fallback = const ACLocalizationRu(),
  });

  final Map<String, ACLocalization> localizations;
  final ACLocalization fallback;

  @override
  ACLocalization localization(String? localeName) {
    if (localeName == null) return fallback;
    return localizations[localeName]
        ?? localizations[localeName.split('-').first]
        ?? fallback;
  }
}
