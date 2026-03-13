import 'package:flutter/material.dart';

import '../../../../../../data/src/ac_calendar_repository.dart';
import '../../../../../../domain/domain.dart';
import '../../../../../../localization/localization.dart';
import '../../../../../presentation.dart';

/// Нижний лист (bottom sheet) с [ACPagesCalendarWidget].
///
/// Для отображения используйте статический метод [ACPagesCalendarSheet.show].
class ACPagesCalendarSheet extends StatelessWidget {
  const ACPagesCalendarSheet({
    required this.range,
    this.repository,
    this.locale,
    this.theme,
    this.selectController,
    this.initialMonth,
    this.spacing,
    this.timeWidget,
    this.scrollViewController,
    this.scrollViewDataSource,
    this.onDone,
    this.localizationManager,
    super.key,
  });

  final ACCalendarRepository? repository;
  final ACDateRange range;
  final String? locale;
  final ACCalendarThemeData? theme;
  final ACCalendarSelectController? selectController;
  final DateTime? initialMonth;
  final double? spacing;
  final PreferredSizeWidget? timeWidget;
  final ACScrollViewController<DateTime>? scrollViewController;
  final ACScrollViewDataSource<DateTime>? scrollViewDataSource;
  final VoidCallback? onDone;
  final ACLocalizationManager? localizationManager;

  /// Открывает bottom sheet с [ACPagesCalendarWidget].
  static Future<void> show(
    BuildContext context, {
    required ACDateRange range,
    ACCalendarRepository? repository,
    String? locale,
    ACCalendarThemeData? theme,
    ACCalendarSelectController? selectController,
    DateTime? initialMonth,
    double? spacing,
    PreferredSizeWidget? timeWidget,
    ACScrollViewController<DateTime>? scrollViewController,
    ACScrollViewDataSource<DateTime>? scrollViewDataSource,
    VoidCallback? onDone,
    ACLocalizationManager? localizationManager,
  }) =>
      ACBottomSheet.show(
        context,
        isScrollControlled: true,
        builder: (context) => ACPagesCalendarSheet(
          range: range,
          repository: repository,
          locale: locale,
          theme: theme,
          selectController: selectController,
          initialMonth: initialMonth,
          spacing: spacing,
          timeWidget: timeWidget,
          scrollViewController: scrollViewController,
          scrollViewDataSource: scrollViewDataSource,
          onDone: onDone,
          localizationManager: localizationManager,
        ),
      );

  void _onDone(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
    onDone?.call();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    final localization =
        (localizationManager ?? const ACDefaultLocalizationManager())
            .localization(
      locale ?? Localizations.maybeLocaleOf(context)?.toLanguageTag(),
    );

    return SizedBox(
      height: kToolbarHeight + 800 + bottomPadding,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(localization.selectMonth),
          titleTextStyle: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Color(0xFF000000),
          ),
          actions: [
            TextButton(
              onPressed: () => _onDone(context),
              child: Text(localization.done),
            ),
          ],
        ),
        body: SafeArea(
          child: ACPagesCalendarWidget(
            range: range,
            repository: repository,
            locale: locale,
            theme: theme,
            selectController: selectController,
            initialMonth: initialMonth,
            spacing: spacing,
            timeWidget: timeWidget,
            scrollViewController: scrollViewController,
            scrollViewDataSource: scrollViewDataSource,
          ),
        ),
      ),
    );
  }
}
