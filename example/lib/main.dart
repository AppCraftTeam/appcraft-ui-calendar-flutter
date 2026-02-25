import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'domain/domain.dart';
import 'presentation/presentation.dart';
// TODO: Clear
// TODO: Create demo
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    

    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // showPerformanceOverlay: true,
      supportedLocales: const [
        Locale('ru'),
        Locale('en'),
      ],
      locale: const Locale('ru'),
      title: 'ACUICalendar Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(
          seedColor: Colors.deepPurple
        ),
      ),
      home: const MainPage()
    );
  }
}

final class MainPage extends StatelessWidget {
  const MainPage({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    final range = ACDateRange(
      min: DateTime(now.year - 1, 1, 1),
      max: DateTime(now.year, 12, 31),
    );

    return Scaffold(
      body: SafeArea(
        child: 

        ACVerticalCalendarWidget(range: range)
        // ACPagesCalendarWidget(range: range,)
      ),
    );
  }
}