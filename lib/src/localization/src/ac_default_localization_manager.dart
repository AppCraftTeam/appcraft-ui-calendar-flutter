import 'ac_localization.dart';
import 'ac_localization_en.dart';
import 'ac_localization_manager.dart';
import 'ac_localization_ru.dart';

/// Default [ACLocalizationManager] implementation.
///
/// Contains built-in localizations for Russian and English languages.
/// Returns [fallback] when no suitable localization is found.
class ACDefaultLocalizationManager extends ACLocalizationManager {
  /// Creates a localization manager with the [localizations] set and [fallback].
  const ACDefaultLocalizationManager({
    this.localizations = const {
      'ru': ACLocalizationRu(),
      'en': ACLocalizationEn(),
    },
    this.fallback = const ACLocalizationRu(),
  });

  /// Map of available localizations, where the key is the language code.
  final Map<String, ACLocalization> localizations;

  /// Default localization used when no match is found.
  final ACLocalization fallback;

  @override
  ACLocalization localization(String? localeName) {
    if (localeName == null) return fallback;
    return localizations[localeName] ??
        localizations[localeName.split('-').first] ??
        fallback;
  }
}
