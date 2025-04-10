import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(const BTZSCalcApp());

class BTZSCalcApp extends StatelessWidget {
  const BTZSCalcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    CameraPage(),
    MeteringPage(),
    FactorsPage(),
    DOFCalculatorPage(),
    ExposurePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.camera), label: 'Camera'),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.lock), label: 'Metering'),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.add_circled), label: 'Factors'),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.photo), label: 'DOF'),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.timer), label: 'Exposure'),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
      tabBuilder: (context, index) => _pages[index],
    );
  }
}

class CameraPage extends StatelessWidget {
  const CameraPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text('Camera')),
      child: Center(child: Text('Camera Page')),
    );
  }
}

class MeteringPage extends StatefulWidget {
  const MeteringPage({super.key});
  @override
  State<MeteringPage> createState() => _MeteringPageState();
}

class _MeteringPageState extends State<MeteringPage> {
  final notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    notesController.text = session.meteringNotes;
  }

  void updateMeteringMode(String mode) {
    setState(() => session.meteringMode = mode);
  }

  Widget buildEvZoneSelector(String label, bool isLow) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                const Text('EV'),
                CupertinoPicker(
                  scrollController: FixedExtentScrollController(
                      initialItem: isLow ? session.lowEV : session.highEV),
                  itemExtent: 36,
                  onSelectedItemChanged: (val) {
                    setState(() {
                      if (isLow) session.lowEV = val;
                      else session.highEV = val;
                    });
                  },
                  children: List.generate(21, (i) => Center(child: Text(i.toString()))),
                ),
              ],
            ),
            Column(
              children: [
                const Text('Zone'),
                CupertinoPicker(
                  scrollController: FixedExtentScrollController(
                      initialItem: isLow ? session.lowZone : session.highZone),
                  itemExtent: 36,
                  onSelectedItemChanged: (val) {
                    setState(() {
                      if (isLow) session.lowZone = val;
                      else session.highZone = val;
                    });
                  },
                  children: List.generate(11, (i) => Center(child: Text(i.toString()))),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final fallbackMode = session.meteringMode.isEmpty ? 'Incident' : session.meteringMode;
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Metering')),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('Metering Mode'),
            CupertinoSegmentedControl<String>(
              children: const {
                'Incident': Padding(padding: EdgeInsets.all(8), child: Text('Incident')),
                'Zone': Padding(padding: EdgeInsets.all(8), child: Text('Zone')),
              },
              groupValue: fallbackMode,
              onValueChanged: updateMeteringMode,
            ),
            const SizedBox(height: 24),
            buildEvZoneSelector('Low EV → Zone', true),
            const SizedBox(height: 24),
            buildEvZoneSelector('High EV → Zone', false),
            const SizedBox(height: 24),
            const Text('Notes'),
            CupertinoTextField(
              controller: notesController,
              maxLines: 3,
              onChanged: (val) => session.meteringNotes = val,
              placeholder: 'Metering details or special conditions...',
            ),
          ],
        ),
      ),
    );
  }
}

class FactorsPage extends StatelessWidget {
  const FactorsPage({super.key});
  @override
  Widget build(BuildContext context) => const CupertinoPageScaffold(
    navigationBar: CupertinoNavigationBar(middle: Text('Factors')),
    child: Center(child: Text('Factors Page')),
  );
}

class DOFCalculatorPage extends StatelessWidget {
  const DOFCalculatorPage({super.key});
  @override
  Widget build(BuildContext context) => const CupertinoPageScaffold(
    navigationBar: CupertinoNavigationBar(middle: Text('DOF Calculator')),
    child: Center(child: Text('DOF Calculator Page')),
  );
}

class ExposurePage extends StatelessWidget {
  const ExposurePage({super.key});
  @override
  Widget build(BuildContext context) => const CupertinoPageScaffold(
    navigationBar: CupertinoNavigationBar(middle: Text('Exposure')),
    child: Center(child: Text('Exposure Page')),
  );
}

class SessionData {
  static final SessionData _instance = SessionData._internal();
  factory SessionData() => _instance;
  SessionData._internal();

  // Camera page
  String cameraModel = '4x5 View';
  String filmHolder = 'Fidelity Elite';
  String filmStock = 'FP4+';
  double flareFactor = 0.3;
  double paperES = 1.2;

  // Exposure page
  bool useApertureMode = true;
  int selectedApertureIndex = 6;
  int selectedMin = 0;
  int selectedSec = 0;
  int selectedFraction = 5;

  // Metering
  int lowEV = 7;
  int lowZone = 3;
  int highEV = 12;
  int highZone = 8;
  String meteringNotes = '';
  String meteringMode = 'Incident';
  String selectedFilter = 'None';
  String bellowsMode = 'None';
  String exposureAdjustment = 'None';

  // DOF
  int focalLength = 210;
  double subjectDistance = 2000;
  double circleOfConfusion = 0.03;
  bool favorDOF = false;

  // Curves
  final List<Map<String, dynamic>> curves = [
    {"label": "N-1", "DR": 0.9, "devTime": 5.5},
    {"label": "N",   "DR": 1.1, "devTime": 7.0},
    {"label": "N+1", "DR": 1.3, "devTime": 9.0},
  ];
}

final session = SessionData();
