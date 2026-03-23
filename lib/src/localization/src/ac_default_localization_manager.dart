import 'ac_localization.dart';
import 'ac_localization_en.dart';
import 'ac_localization_manager.dart';
import 'ac_localization_ru.dart';

/// Реализация [ACLocalizationManager] по умолчанию.
///
/// Содержит встроенные локализации для русского и английского языков.
/// При отсутствии подходящей локализации возвращает [fallback].
class ACDefaultLocalizationManager extends ACLocalizationManager {
  /// Создаёт менеджер локализации с набором [localizations] и [fallback].
  const ACDefaultLocalizationManager({
    this.localizations = const {
      'ru': ACLocalizationRu(),
      'en': ACLocalizationEn(),
    },
    this.fallback = const ACLocalizationRu(),
  });

  /// Карта доступных локализаций, ключ — код языка.
  final Map<String, ACLocalization> localizations;

  /// Локализация по умолчанию, используемая при отсутствии совпадения.
  final ACLocalization fallback;

  @override
  ACLocalization localization(String? localeName) {
    if (localeName == null) return fallback;
    return localizations[localeName] ??
        localizations[localeName.split('-').first] ??
        fallback;
  }
}
