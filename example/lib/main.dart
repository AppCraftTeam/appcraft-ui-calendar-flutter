import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'domain/domain.dart';
import 'presentation/presentation.dart';

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
        Locale('en'),
      ],
      locale: const Locale('ru'),
      title: 'ACUICalendar Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ACCalendarCard(
                  range: range,
                  // selectController: ACCalendarMultiSelectController(
                  //   onChanged: (selected) {
                  //     print('!!! $selected');
                  //   },
                  // ),
                  selectController: ACCalendarSingleSelectController(
                    onChanged: (selected) {
                      print('!!! $selected');
                    },
                  ),
                ),

                ElevatedButton(
                  onPressed: () => ACBottomSheet.show(
                    context: context,
                    child: Container(
                      height: 400,
                      color: Colors.red,
                    )
                  ),
                  child: const Text('Show bottom sheet'),
                )
              ]
            ),
          )
        ),
      )
    );
  }
}
