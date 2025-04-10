import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:btzs_calc/session.dart';
import 'package:btzs_calc/utils/dof_calculator.dart';

class DOFCalculatorPage extends StatefulWidget {
  const DOFCalculatorPage({super.key});

  @override
  State<DOFCalculatorPage> createState() => _DOFCalculatorPageState();
}

class _DOFCalculatorPageState extends State<DOFCalculatorPage> {
  final session = Session();
  int selectedMode = 0; // 0: None, 1: Check, 2: Distance, 3: Focus

  int apertureIndex = 10; // default f/22
  double subjectDistance = 1000;
  double nearDistance = 500;
  double farDistance = 2000;
  double railTravel = 0.0;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text("DOF")),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            CupertinoSegmentedControl<int>(
              children: const {
                0: Text("None"),
                1: Text("Check"),
                2: Text("Distance"),
                3: Text("Focus"),
              },
              groupValue: selectedMode,
              onValueChanged: (val) => setState(() => selectedMode = val),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: _buildContentForMode(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentForMode() {
    if (session.focalLength == 0) {
      return _warningBox("Focal Length has not been selected");
    }

    switch (selectedMode) {
      case 1:
        return _checkMode();
      case 2:
        return _distanceMode();
      case 3:
        return _focusMode();
      default:
        return const Center(child: Text("Select a mode to begin."));
    }
  }

  Widget _checkMode() {
    return Column(
      children: [
        const Text("Aperture"),
        CupertinoPicker(
          itemExtent: 32,
          scrollController: FixedExtentScrollController(initialItem: apertureIndex),
          onSelectedItemChanged: (i) => setState(() => apertureIndex = i),
          children: session.apertureValues.map((f) => Text("f/\$f")).toList(),
        ),
        const SizedBox(height: 16),
        const Text("Distance (m)"),
        CupertinoSlider(
          min: 0.1,
          max: 50.0,
          divisions: 500,
          value: subjectDistance,
          onChanged: (val) => setState(() => subjectDistance = val),
        ),
        Text("${subjectDistance.toStringAsFixed(1)} m"),
      ],
    );
  }

  Widget _distanceMode() {
    return Column(
      children: [
        const Text("Near Distance (m)"),
        CupertinoSlider(
          min: 0.1,
          max: 50.0,
          divisions: 500,
          value: nearDistance,
          onChanged: (val) => setState(() => nearDistance = val),
        ),
        Text("${nearDistance.toStringAsFixed(1)} m"),
        const SizedBox(height: 16),
        const Text("Far Distance (m)"),
        CupertinoSlider(
          min: 0.1,
          max: 50.0,
          divisions: 500,
          value: farDistance,
          onChanged: (val) => setState(() => farDistance = val),
        ),
        Text("${farDistance.toStringAsFixed(1)} m"),
      ],
    );
  }

  Widget _focusMode() {
    return Column(
      children: [
        const Text("Rail Travel (mm)"),
        CupertinoSlider(
          min: 0.0,
          max: 100.0,
          divisions: 200,
          value: railTravel,
          onChanged: (val) => setState(() => railTravel = val),
        ),
        Text("${railTravel.toStringAsFixed(1)} mm"),
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Measurement of focus rail travel between near and far subject planes",
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _warningBox(String message) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: CupertinoColors.systemGrey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
