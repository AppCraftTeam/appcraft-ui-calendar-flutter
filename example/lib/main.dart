import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
      supportedLocales: const [Locale('ru'), Locale('en')],
      locale: const Locale('ru'),
      title: 'ACUICalendar Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const DemoMenuPage(),
    );
  }
}

enum _SelectMode { single, range, multi }

ACDateRange _defaultRange() {
  final now = DateTime.now();
  return ACDateRange(
    min: DateTime(now.year - 1, 1, 1),
    max: DateTime(now.year, 12, 31),
  );
}

ACCalendarSelectController _createController(_SelectMode mode) {
  return switch (mode) {
    _SelectMode.single => ACCalendarSingleSelectController(),
    _SelectMode.range => ACCalendarRangeSelectController(),
    _SelectMode.multi => ACCalendarMultiSelectController(),
  };
}

class DemoMenuPage extends StatelessWidget {
  const DemoMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ACUICalendar Demo')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _SectionHeader(title: 'ACCalendarScreen'),
          const SizedBox(height: 8),
          _DemoCard(
            icon: Icons.calendar_month,
            title: 'Single Select',
            description: 'Select a single date',
            onTap: () => _openScreen(context, _SelectMode.single),
          ),
          const SizedBox(height: 8),
          _DemoCard(
            icon: Icons.calendar_month,
            title: 'Range Select',
            description: 'Select a date range',
            onTap: () => _openScreen(context, _SelectMode.range),
          ),
          const SizedBox(height: 8),
          _DemoCard(
            icon: Icons.calendar_month,
            title: 'Multi Select',
            description: 'Select multiple dates',
            onTap: () => _openScreen(context, _SelectMode.multi),
          ),
          const SizedBox(height: 24),
          const _SectionHeader(title: 'ACCalendarCard'),
          const SizedBox(height: 8),
          _DemoCard(
            icon: Icons.credit_card,
            title: 'Single Select',
            description: 'Select a single date',
            onTap: () => _openCard(context, _SelectMode.single),
          ),
          const SizedBox(height: 8),
          _DemoCard(
            icon: Icons.credit_card,
            title: 'Range Select',
            description: 'Select a date range',
            onTap: () => _openCard(context, _SelectMode.range),
          ),
          const SizedBox(height: 8),
          _DemoCard(
            icon: Icons.credit_card,
            title: 'Multi Select',
            description: 'Select multiple dates',
            onTap: () => _openCard(context, _SelectMode.multi),
          ),
          const SizedBox(height: 24),
          const _SectionHeader(title: 'ACPagesCalendarSheet'),
          const SizedBox(height: 8),
          _DemoCard(
            icon: Icons.calendar_today,
            title: 'Single Select',
            description: 'Select a single date in a bottom sheet',
            onTap: () => _openSheet(context, _SelectMode.single),
          ),
          const SizedBox(height: 8),
          _DemoCard(
            icon: Icons.calendar_today,
            title: 'Range Select',
            description: 'Select a date range in a bottom sheet',
            onTap: () => _openSheet(context, _SelectMode.range),
          ),
          const SizedBox(height: 8),
          _DemoCard(
            icon: Icons.calendar_today,
            title: 'Multi Select',
            description: 'Select multiple dates in a bottom sheet',
            onTap: () => _openSheet(context, _SelectMode.multi),
          ),
        ],
      ),
    );
  }

  void _openScreen(BuildContext context, _SelectMode mode) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => _CalendarScreenDemo(mode: mode)),
    );
  }

  void _openCard(BuildContext context, _SelectMode mode) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => _CalendarCardDemo(mode: mode)),
    );
  }

  void _openSheet(BuildContext context, _SelectMode mode) {
    final controller = _createController(mode);
    ACPagesCalendarSheet.show(
      context,
      range: _defaultRange(),
      selectController: controller,
      onDone: controller.dispose,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _DemoCard extends StatelessWidget {
  const _DemoCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class _CalendarScreenDemo extends StatefulWidget {
  const _CalendarScreenDemo({required this.mode});

  final _SelectMode mode;

  @override
  State<_CalendarScreenDemo> createState() => _CalendarScreenDemoState();
}

class _CalendarScreenDemoState extends State<_CalendarScreenDemo> {
  late final ACCalendarSelectController _selectController;

  @override
  void initState() {
    super.initState();
    _selectController = _createController(widget.mode);
  }

  @override
  void dispose() {
    _selectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ACCalendarScreen(
        range: _defaultRange(),
        selectController: _selectController,
        timeWidget: ACTitledTimeWidget.range(),
        scrollViewPadding: const EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 16,
        ),
      ),
    );
  }
}

class _CalendarCardDemo extends StatefulWidget {
  const _CalendarCardDemo({required this.mode});

  final _SelectMode mode;

  @override
  State<_CalendarCardDemo> createState() => _CalendarCardDemoState();
}

class _CalendarCardDemoState extends State<_CalendarCardDemo> {
  late final ACCalendarSelectController _selectController;

  @override
  void initState() {
    super.initState();
    _selectController = _createController(widget.mode);
  }

  @override
  void dispose() {
    _selectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ACCalendarCard')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ACPagesCalendarCard(
            range: _defaultRange(),
            selectController: _selectController,
            timeWidget: ACTitledTimeWidget.range(),
          ),
        ],
      ),
    );
  }
}
