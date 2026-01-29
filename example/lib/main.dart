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
        child: ACVerticalCalendarWidget(
          range: range,
          initialMonth: DateTime.now(),
        )
        
        
      //   Padding(
      //     padding: const EdgeInsets.all(16),
      //     child: Column(
      //       spacing: 8,
      //       children: [
      //         ACCalendarCard(
      //           range: range,
      //           selectController: ACCalendarMultiSelectController(
      //             // onChanged: (selected) {
      //             //   print('!!! $selected');
      //             // },
      //           ),
      //           // selectController: ACCalendarSingleSelectController(
      //           //   onChanged: (selected) {
      //           //     print('!!! $selected');
      //           //   },
      //           // ),
      //           // selectController: ACCalendarRangeSelectController(
      //             // onChanged: (selected) {
      //             //   print('!!! $selected');
      //             // },
      //           // ),
      //         ),
  
      //         ElevatedButton(
      //           onPressed: () => ACCalendarHorizontalSheet.show(
      //             context,
      //             range: range
      //           ),
      //           child: const Text('Show bottom sheet'),
      //         )
      //       ]
      //     ),
      //   )
      ),
    );
  }
}
