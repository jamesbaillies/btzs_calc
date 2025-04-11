import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'session.dart';

class DOFPage extends StatefulWidget {
  const DOFPage({super.key});

  @override
  State<DOFPage> createState() => _DOFPageState();
}

class _DOFPageState extends State<DOFPage> {
  final session = Session();

  @override
  Widget build(BuildContext context) {
    double result = 0;
    final f = session.focalLength;
    final coc = session.circleOfConfusion;

    switch (session.dofMode) {
      case 'Check':
        result = calculateRequiredAperture(f, session.subjectDistance, coc);
        break;
      case 'Distance':
        final near = session.nearDistance * 1000; // meters to mm
        final far = session.farDistance * 1000;
        result = calculateDistanceBasedDOF(near, far, f, coc);
        break;
      case 'Focus':
        result = calculateFocusBasedDOF(session.focusTravel, f, coc);
        break;
    }

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Depth of Field'),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CupertinoSlidingSegmentedControl<String>(
                children: const {
                  'None': Text('None'),
                  'Check': Text('Check'),
                  'Distance': Text('Distance'),
                  'Focus': Text('Focus'),
                },
                groupValue: session.dofMode,
                onValueChanged: (value) => setState(() => session.dofMode = value!),
              ),
              const SizedBox(height: 16),

              if (session.dofMode == 'None')
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Favor DOF'),
                    CupertinoSwitch(
                      value: session.favorDOF,
                      onChanged: (val) => setState(() => session.favorDOF = val),
                    ),
                  ],
                ),

              if (session.dofMode == 'Check') ...[
                const SizedBox(height: 16),
                const Text('Aperture (f/stop)'),
                CupertinoPicker(
                  itemExtent: 32.0,
                  scrollController: FixedExtentScrollController(
                    initialItem: session.apertureValues.indexOf(session.aperture),
                  ),
                  onSelectedItemChanged: (index) => setState(() => session.aperture = session.apertureValues[index]),
                  children: session.apertureValues.map((f) => Text('f/$f')).toList(),
                ),

                const SizedBox(height: 16),
                const Text('Subject Distance (meters)'),
                CupertinoPicker(
                  itemExtent: 32.0,
                  scrollController: FixedExtentScrollController(
                    initialItem: session.subjectDistance.toInt() - 1,
                  ),
                  onSelectedItemChanged: (index) => setState(() => session.subjectDistance = (index + 1).toDouble()),
                  children: List.generate(100, (index) => Text('${index + 1} m')),
                ),
              ],

              if (session.dofMode == 'Distance') ...[
                const SizedBox(height: 16),
                const Text('Near Focus Distance (meters)'),
                CupertinoPicker(
                  itemExtent: 32.0,
                  scrollController: FixedExtentScrollController(
                    initialItem: session.nearDistance.toInt() - 1,
                  ),
                  onSelectedItemChanged: (index) => setState(() => session.nearDistance = (index + 1).toDouble()),
                  children: List.generate(100, (index) => Text('${index + 1} m')),
                ),
                const SizedBox(height: 16),
                const Text('Far Focus Distance (meters)'),
                CupertinoPicker(
                  itemExtent: 32.0,
                  scrollController: FixedExtentScrollController(
                    initialItem: session.farDistance.toInt() - 1,
                  ),
                  onSelectedItemChanged: (index) => setState(() => session.farDistance = (index + 1).toDouble()),
                  children: List.generate(100, (index) => Text('${index + 1} m')),
                ),
              ],

              if (session.dofMode == 'Focus') ...[
                const SizedBox(height: 16),
                const Text(
                  'Measurement of focus rail travel between\nnear and far subject planes',
                  textAlign: TextAlign.center,
                ),
                CupertinoPicker(
                  itemExtent: 32.0,
                  onSelectedItemChanged: (index) => setState(() => session.focusTravel = index.toDouble()),
                  children: List.generate(100, (index) => Text('${index} mm')),
                ),
              ],

              const SizedBox(height: 32),
              const Text('Calculated Result:'),
              Text('${result.toStringAsFixed(2)}'),
            ],
          ),
        ),
      ),
    );
  }

  double calculateRequiredAperture(double focalLength, double distance, double coc) {
    final H = (distance - focalLength) * coc;
    final N = (focalLength * focalLength) / H;
    return N;
  }

  double calculateDistanceBasedDOF(double near, double far, double focalLength, double coc) {
    final H = 2 * (near * far) / (far - near);
    final N = (focalLength * focalLength) / (H * coc);
    return N;
  }

  double calculateFocusBasedDOF(double travel, double focalLength, double coc) {
    final H = travel * 2;
    final N = (focalLength * focalLength) / (H * coc);
    return N;
  }
}