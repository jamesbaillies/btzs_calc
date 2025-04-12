import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:btzs_calc/session.dart';

class DOFPage extends StatefulWidget {
  final Session session;

  const DOFPage({super.key, required this.session});

  @override
  State<DOFPage> createState() => _DOFPageState();
}

class _DOFPageState extends State<DOFPage> {
  Session get session => widget.session;

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
    final textStyle = CupertinoTheme.of(context).textTheme.textStyle;
    final f = session.focalLength;
    final N = session.aperture;
    final d = session.subjectDistance;
    final c = 0.03;

    final H = calculateHyperfocal(f, N, c) / 1000;
    final near = calculateNearLimit(H, d);
    final far = calculateFarLimit(H, d);

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('DOF Calculator'),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionHeader('Aperture', textStyle),
            SizedBox(
              height: 100,
              child: CupertinoPicker(
                itemExtent: 32,
                scrollController: FixedExtentScrollController(
                  initialItem: session.apertureValues.indexOf(session.aperture),
                ),
                onSelectedItemChanged: (index) =>
                    setState(() => session.aperture = session.apertureValues[index]),
                children: session.apertureValues
                    .map((f) => Text('f/$f', style: textStyle))
                    .toList(),
              ),
            ),

            const SizedBox(height: 24),
            _buildSectionHeader('Subject Distance (m)', textStyle),
            SizedBox(
              height: 100,
              child: CupertinoPicker(
                itemExtent: 32,
                scrollController: FixedExtentScrollController(
                  initialItem: session.subjectDistance.round() - 1,
                ),
                onSelectedItemChanged: (index) =>
                    setState(() => session.subjectDistance = (index + 1).toDouble()),
                children: List.generate(
                  100,
                      (i) => Text('${i + 1} m', style: textStyle),
                ),
              ),
            ),

            const SizedBox(height: 32),
            Text(
              'Calculated Feedback',
              style: textStyle.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text('Hyperfocal Distance: ${H.toStringAsFixed(2)} m', style: textStyle),
            Text('Near Focus Limit: ${near.toStringAsFixed(2)} m', style: textStyle),
            Text('Far Focus Limit: ${far > 9999 ? "∞" : far.toStringAsFixed(2)} m', style: textStyle),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, TextStyle style) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(title, style: style),
    );
  }
}
