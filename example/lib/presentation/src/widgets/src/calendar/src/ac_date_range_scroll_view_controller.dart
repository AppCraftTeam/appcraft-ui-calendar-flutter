import '../../../../../../data/src/ac_calendar_repository.dart';
import '../../../../../../domain/src/ac_date_range.dart';
import '../../../../../presentation.dart';

/// Контроллер прокрутки с ограничением по диапазону дат [ACDateRange].
///
/// Расширяет [ACDefaultScrollViewController] для навигации по месяцам:
/// вычисляет [onBefore] и [onAfter] на основе переданного диапазона,
/// не позволяя выйти за его границы.
class ACDateRangeScrollViewController extends ACDefaultScrollViewController<DateTime> {
  ACDateRangeScrollViewController({
    required ACDateRange range,
    required DateTime initialMonth,
    required super.itemExtentBuilder,
    super.onVisibleItemChanged,
  }) : super(
    initialItem: initialMonth,
    onBefore: (monthDate) {
      final previous = _repository.addMonths(monthDate, -1);
      if (previous.isBefore(range.min)) return null;
      return previous;
    },
    onAfter: (monthDate) {
      final next = _repository.addMonths(monthDate, 1);
      if (next.isAfter(range.max)) return null;
      return next;
    },
  );

  static const _repository = ACCalendarRepository();
}
