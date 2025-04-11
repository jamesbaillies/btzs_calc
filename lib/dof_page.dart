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

  double calculateRequiredAperture(double f, double d, double c) {
    final numerator = d * c;
    final denominator = f - d;
    return (numerator / denominator).abs();
  }

  double calculateFocusBasedDOF(double railTravel, double focalLength, double coc) {
    final extension = railTravel / 2;
    final H = (focalLength * focalLength) / (coc);
    return (2 * extension * H) / (H - extension);
  }

  @override
  Widget build(BuildContext context) {
    double result = 0;
    final f = session.focalLength.toDouble();
    final coc = session.circleOfConfusion;

    switch (session.dofMode) {
      case 'Check':
        result = calculateRequiredAperture(f, session.subjectDistance.toDouble(), coc);
        break;
      case 'Distance':
        final near = session.nearDistance * 1000;
        final far = session.farDistance * 1000;
        final H = (f * f) / (coc);
        result = (2 * near * far) / (H * (near + far - 2 * f));
        break;
      case 'Focus':
        result = calculateFocusBasedDOF(session.focusTravel, f, coc);
        break;
    }

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('DOF Calculator')),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            CupertinoSegmentedControl<String>(
              groupValue: session.dofMode,
              children: const {
                'None': Text('None'),
                'Check': Text('Check'),
                'Distance': Text('Distance'),
                'Focus': Text('Focus'),
              },
              onValueChanged: (value) => setState(() => session.dofMode = value),
            ),
            const SizedBox(height: 24),

            if (session.dofMode == 'None')
              Column(
                children: [
                  const Text('Favor DOF'),
                  CupertinoSwitch(
                    value: session.favorDOF,
                    onChanged: (val) => setState(() => session.favorDOF = val),
                  )
                ],
              ),

            if (session.dofMode == 'Check')
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    const Text('Aperture'),
                    SizedBox(
                      height: 100,
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                          initialItem: session.apertureValues.indexOf(session.aperture),
                        ),
                        itemExtent: 32,
                        onSelectedItemChanged: (index) => setState(() => session.aperture = session.apertureValues[index]),
                        children: session.apertureValues.map((f) => Text("f/\$f")).toList(),
                      ),
                    ),
                    const Text('Distance to Subject (m)'),
                    SizedBox(
                      height: 100,
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                          initialItem: session.subjectDistance.toInt() - 1,
                        ),
                        itemExtent: 32,
                        onSelectedItemChanged: (index) => setState(() => session.subjectDistance = (index + 1).toDouble()),
                        children: List.generate(100, (i) => Text('${i + 1} m')),
                      ),
                    )
                  ],
                ),
              ),

            if (session.dofMode == 'Distance')
              Expanded(
                child: Column(
                  children: [
                    const Text('Near Distance (m)'),
                    SizedBox(
                      height: 100,
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                          initialItem: session.nearDistance.toInt() - 1,
                        ),
                        itemExtent: 32,
                        onSelectedItemChanged: (index) => setState(() => session.nearDistance = index + 1),
                        children: List.generate(100, (i) => Text('${i + 1} m')),
                      ),
                    ),
                    const Text('Far Distance (m)'),
                    SizedBox(
                      height: 100,
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                          initialItem: session.farDistance.toInt() - 1,
                        ),
                        itemExtent: 32,
                        onSelectedItemChanged: (index) => setState(() => session.farDistance = index + 1),
                        children: List.generate(100, (i) => Text('${i + 1} m')),
                      ),
                    ),
                  ],
                ),
              ),

            if (session.dofMode == 'Focus')
              Column(
                children: [
                  const Text('Focus Rail Travel (mm)'),
                  SizedBox(
                    height: 100,
                    child: CupertinoPicker(
                      scrollController: FixedExtentScrollController(
                        initialItem: session.focusTravel.toInt(),
                      ),
                      itemExtent: 32,
                      onSelectedItemChanged: (index) => setState(() => session.focusTravel = index.toDouble()),
                      children: List.generate(200, (i) => Text('${i} mm')),
                    ),
                  )
                ],
              ),

            const SizedBox(height: 24),
            const Text('Calculated Result:'),
            Text(result.isNaN ? "--" : result.toStringAsFixed(2),
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
          ],
        ),
      ),
    );
  }
}