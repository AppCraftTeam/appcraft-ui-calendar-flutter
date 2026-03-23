import 'ac_localization.dart';

/// Абстрактный менеджер локализации календаря.
///
/// Предоставляет метод для получения [ACLocalization] по имени локали.
abstract class ACLocalizationManager {
  /// Создаёт экземпляр менеджера локализации.
  const ACLocalizationManager();

  /// Возвращает локализацию для указанного [localeName].
  ACLocalization localization(String? localeName);
}
