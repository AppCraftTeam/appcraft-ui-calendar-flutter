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
      min: DateTime(now.year - 100, 1, 1),
      max: DateTime(now.year, 12, 31),
    );

    return Scaffold(
      body: SafeArea(
        child: 
        
        // ACScrollView(
        //   controller: DefaultScrollViewController(
        //     initialItem: 0,
        //     onBefore: (item) => item > - 20 ? item - 1 : null,
        //     onAfter: (item) => item < 20 ? item + 1 : null,
        //     itemExtentBuilder: (item) => MediaQuery.of(context).size.width,
        //     onVisibleItemChanged: (item) {
        //       print('!!! $item');
        //     },
        //   ),
        //   physics: const BouncingScrollPhysics(),
        //   scrollDirection: Axis.vertical,
        //   itemBuilder: (context, item) => Container(
        //     padding: const EdgeInsets.all(4),
        //     height: MediaQuery.of(context).size.width,
        //     child: Container(
        //       color: Colors.red.withValues(alpha: .2),
        //       child: Center(
        //         child: Text(item.toString()),
        //       ),
        //     ),
        //   ),
        //   )
        
        
        ACCalendarWidget(
          range: range,
          layout: const ACCalendarVerticalLayout()
        )
        
        // ACVerticalCalendarWidget(
        //   range: range,
        //   initialMonth: DateTime.now(),
        // )
        
        
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

class TTT extends FixedExtentScrollController {

  void rrr() {
    final c = FixedExtentScrollController();
    // c.selectedItem
  }
}