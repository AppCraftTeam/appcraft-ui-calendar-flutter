import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'main.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SchedulerBinding.instance.addTimingsCallback((List<FrameTiming> timings) {
    for (final timing in timings) {
      final buildMs = timing.buildDuration.inMicroseconds / 1000;
      final rasterMs = timing.rasterDuration.inMicroseconds / 1000;
      final totalMs = timing.totalSpan.inMicroseconds / 1000;
      Timeline.instantSync(
        'Frame: build=${buildMs.toStringAsFixed(1)}ms '
        'raster=${rasterMs.toStringAsFixed(1)}ms '
        'total=${totalMs.toStringAsFixed(1)}ms',
      );
      // coverage:ignore-start
      if (totalMs > 16.7) {
        debugPrint(
          '\u26a0 Slow frame: build=${buildMs.toStringAsFixed(1)}ms '
          'raster=${rasterMs.toStringAsFixed(1)}ms '
          'total=${totalMs.toStringAsFixed(1)}ms',
        );
      }
      // coverage:ignore-end
    }
  });

  runApp(const PerfApp());
}

/// Обёртка над основным приложением с включённым performance overlay.
///
/// Запуск: `flutter run -t lib/main_perf.dart`
class PerfApp extends StatelessWidget {
  const PerfApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      showPerformanceOverlay: true,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ru'), Locale('en')],
      locale: const Locale('ru'),
      title: 'ACUICalendar Perf',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const DemoMenuPage(),
    );
  }
}
