import 'package:flutter/cupertino.dart';
import 'session.dart';
import 'dart:math';

class DOFCalculatorPage extends StatefulWidget {
   DOFCalculatorPage({super.key});

  @override
  State<DOFCalculatorPage> createState() => _DOFCalculatorPageState();
}

class _DOFCalculatorPageState extends State<DOFCalculatorPage> {
  final session = Session(); // 👈 this is critical
  double calculateNearLimit(double f, double d, double c) {
    final numerator = d * f * f;
    final denominator = f * f + c * (d - f);
    return numerator / denominator;
  }

  double calculateFarLimit(double f, double d, double c) {
    final numerator = d * f * f;
    final denominator = f * f - c * (d - f);
    if (denominator <= 0) return double.infinity;
    return numerator / denominator;
  }

  double calculateDOF(double near, double far) {
    if (far == double.infinity) return double.infinity;
    return far - near;
  }

  @override
  Widget build(BuildContext context) {
    final f = session.focalLength.toDouble();
    final d = session.subjectDistance.toDouble();
    final c = session.circleOfConfusion;

    final near = calculateNearLimit(f, d, c);
    final far = calculateFarLimit(f, d, c);
    final dof = calculateDOF(near, far);

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('DOF Calculator')),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('Focal Length (mm)'),
            CupertinoSlider(
              min: 90,
              max: 600,
              value: f,
              onChanged: (val) => setState(() => session.focalLength = val.toDouble()),
            ),
            Text('${session.focalLength} mm'),
            const SizedBox(height: 24),

            const Text('Subject Distance (mm)'),
            CupertinoSlider(
              min: 100,
              max: 10000,
              value: d,
              onChanged: (val) => setState(() => session.subjectDistance = val),
            ),
            Text('${session.subjectDistance.toStringAsFixed(0)} mm'),
            const SizedBox(height: 24),

            const Text('Circle of Confusion (mm)'),
            CupertinoSlider(
              min: 0.01,
              max: 0.1,
              value: c,
              onChanged: (val) => setState(() => session.circleOfConfusion = val),
            ),
            Text(session.circleOfConfusion.toStringAsFixed(2)),
            const SizedBox(height: 32),

            const Text('Depth of Field'),
            Text('Near limit: ${near.toStringAsFixed(1)} mm'),
            Text('Far limit: ${far == double.infinity ? "∞" : far.toStringAsFixed(1)} mm'),
            Text('Total DOF: ${dof == double.infinity ? "∞" : dof.toStringAsFixed(1)} mm'),
          ],
        ),
      ),
    );
  }
}
