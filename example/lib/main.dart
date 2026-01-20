import 'package:example/presentation/src/ac_calendar_horizontal_widget.dart';
import 'package:example/ac_date_range.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    final range = ACDateRange(
      min: DateTime(now.year - 1, 1, 1),
      max: DateTime(now.year, 12, 31),
    );

    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ru'),
      ],
      locale: Locale('ru'),
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        body: SafeArea(
          child: ACCalendarHorizontalWidget(
            range: range
          )
        ),
      )
    );
  }
}
