import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:btzs_calc/session.dart';
import 'dart:math';

class DOFPage extends StatefulWidget {
  const DOFPage({super.key});

  @override
  State<DOFPage> createState() => _DOFPageState();
}

class _DOFPageState extends State<DOFPage> {
  final session = Session();

  double log2(num x) => (x > 0) ? log(x) / log(2) : 0;

  double calculateHyperfocal(double f, double N, double c) {
    return (f * f) / (N * c);
  }

  double calculateNearLimit(double H, double d) {
    return (H * d) / (H + (d - 1));
  }

  double calculateFarLimit(double H, double d) {
    return (H * d) / (H - (d - 1));
  }

  @override
  Widget build(BuildContext context) {
    final f = session.focalLength; // in mm
    final N = session.aperture;
    final d = session.subjectDistance; // in meters
    final c = 0.03; // circle of confusion in mm

    final H = calculateHyperfocal(f, N, c) / 1000; // in meters
    final near = calculateNearLimit(H, d);
    final far = calculateFarLimit(H, d);

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('DOF Calculator')),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('Aperture'),
            CupertinoPicker(
              itemExtent: 32,
              scrollController: FixedExtentScrollController(initialItem: session.apertureValues.indexOf(session.aperture)),
              onSelectedItemChanged: (index) => setState(() => session.aperture = session.apertureValues[index]),
              children: session.apertureValues.map((f) => Text('f/$f')).toList(),
            ),

            const SizedBox(height: 24),
            const Text('Subject Distance (m)'),
            CupertinoPicker(
              itemExtent: 32,
              scrollController: FixedExtentScrollController(initialItem: session.subjectDistance.round() - 1),
              onSelectedItemChanged: (index) => setState(() => session.subjectDistance = (index + 1).toDouble()),
              children: List.generate(100, (i) => Text('${i + 1} m')),
            ),

            const SizedBox(height: 32),
            const Text('Calculated Feedback', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text('Hyperfocal Distance: ${H.toStringAsFixed(2)} m'),
            Text('Near Focus Limit: ${near.toStringAsFixed(2)} m'),
            Text('Far Focus Limit: ${far > 9999 ? "∞" : far.toStringAsFixed(2)} m'),
          ],
        ),
      ),
    );
  }
}
