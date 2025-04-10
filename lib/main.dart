import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ExposureAssistantApp());
}

class ExposureAssistantApp extends StatelessWidget {
  const ExposureAssistantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(brightness: Brightness.dark),
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

  static final List<Widget> _pages = <Widget>[
    const CameraPage(),
    const MeteringPage(),
    const DOFCalculatorPage(),
    const ExposurePage(),
    const FactorsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.camera), label: 'Camera'),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.lightbulb), label: 'Metering'),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.square_on_square), label: 'DOF'),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.timer), label: 'Exposure'),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.slider_horizontal_3), label: 'Factors'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      tabBuilder: (context, index) => CupertinoTabView(
        builder: (context) => _pages[index],
      ),
    );
  }
}

class CameraPage extends StatelessWidget {
  const CameraPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Camera Setup')),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('Camera Model'),
            CupertinoTextField(
              placeholder: 'e.g. 4x5 View',
              onChanged: (val) => session.cameraModel = val,
            ),
            const SizedBox(height: 16),
            const Text('Film Holder'),
            CupertinoTextField(
              placeholder: 'e.g. Fidelity Elite',
              onChanged: (val) => session.filmHolder = val,
            ),
            const SizedBox(height: 16),
            const Text('Film Stock'),
            CupertinoTextField(
              placeholder: 'e.g. FP4+',
              onChanged: (val) => session.filmStock = val,
            ),
            const SizedBox(height: 16),
            const Text('Flare Factor'),
            CupertinoTextField(
              placeholder: 'e.g. 0.3',
              keyboardType: TextInputType.number,
              onChanged: (val) => session.flareFactor = double.tryParse(val) ?? 0.3,
            ),
            const SizedBox(height: 16),
            const Text('Paper ES'),
            CupertinoTextField(
              placeholder: 'e.g. 1.2',
              keyboardType: TextInputType.number,
              onChanged: (val) => session.paperES = double.tryParse(val) ?? 1.2,
            ),
          ],
        ),
      ),
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
                  useMagnifier: true,
                  magnification: 1.2,
                  diameterRatio: 1.2,
                  squeeze: 1.1,
                  looping: false,
                  selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(),
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
                  useMagnifier: true,
                  magnification: 1.2,
                  diameterRatio: 1.2,
                  squeeze: 1.1,
                  looping: false,
                  selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(),
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
              groupValue: session.meteringMode,
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

  // Metering
  int lowEV = 7;
  int lowZone = 3;
  int highEV = 12;
  int highZone = 8;
  String meteringNotes = '';
  String meteringMode = '';

  // Placeholder for DOF and Exposure
  int focalLength = 210;
  double subjectDistance = 2000;
  double circleOfConfusion = 0.03;
  bool favorDOF = false;

  bool useApertureMode = true;
  int selectedApertureIndex = 6;
  int selectedMin = 0;
  int selectedSec = 0;
  int selectedFraction = 5;

  String selectedFilter = 'None';
  String bellowsMode = 'None';
  String exposureAdjustment = 'None';

  final List<Map<String, dynamic>> curves = [
    {"label": "N-1", "DR": 0.9, "devTime": 5.5},
    {"label": "N",   "DR": 1.1, "devTime": 7.0},
    {"label": "N+1", "DR": 1.3, "devTime": 9.0},
  ];
}
class DOFCalculatorPage extends StatelessWidget {
  const DOFCalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text('DOF Calculator')),
      child: Center(child: Text('DOF Calculator Page')),
    );
  }
}

class ExposurePage extends StatelessWidget {
  const ExposurePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text('Exposure')),
      child: Center(child: Text('Exposure Page')),
    );
  }
}

class FactorsPage extends StatelessWidget {
  const FactorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text('Factors')),
      child: Center(child: Text('Factors Page')),
    );
  }
}
final session = SessionData();
