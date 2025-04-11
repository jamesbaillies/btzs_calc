import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:btzs_calc/session.dart';

class MeteringPage extends StatefulWidget {
  @override
  _MeteringPageState createState() => _MeteringPageState();
}

class _MeteringPageState extends State<MeteringPage> {
  final session = Session();
  final List<double> evValues = List.generate(201, (index) => index / 10); // 0.0 to 20.0

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Text("Cancel", style: TextStyle(color: CupertinoColors.activeBlue)),
        ),
        middle: const Text("Metering"),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            CupertinoSegmentedControl<String>(
              groupValue: session.meteringMode,
              children: const {
                'Incident': Text('Incident'),
                'Zone': Text('Zone'),
              },
              onValueChanged: (value) => setState(() => session.meteringMode = value),
            ),
            const SizedBox(height: 16),
            if (session.meteringMode == 'Incident') _buildIncidentUI(),
            if (session.meteringMode == 'Zone') _buildZoneUI(),
            const SizedBox(height: 24),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: CupertinoColors.inactiveGray),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                session.filmStock.isEmpty ? 'Film has not been selected' : 'Film: ${session.filmStock}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CupertinoTextField(
                placeholder: 'Metering Notes',
                controller: TextEditingController(text: session.meteringNotes),
                onChanged: (val) => session.meteringNotes = val,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncidentUI() {
    return Column(
      children: [
        const Text("Lo EV"),
        SizedBox(
          height: 120,
          child: CupertinoPicker(
            itemExtent: 32,
            scrollController: FixedExtentScrollController(initialItem: evValues.indexOf(session.incidentLoEV)),
            onSelectedItemChanged: (v) => setState(() => session.incidentLoEV = evValues[v]),
            children: evValues.map((e) => Text(e.toStringAsFixed(1))).toList(),
          ),
        ),
        const Text("Hi EV"),
        SizedBox(
          height: 120,
          child: CupertinoPicker(
            itemExtent: 32,
            scrollController: FixedExtentScrollController(initialItem: evValues.indexOf(session.incidentHiEV)),
            onSelectedItemChanged: (v) => setState(() => session.incidentHiEV = evValues[v]),
            children: evValues.map((e) => Text(e.toStringAsFixed(1))).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildZoneUI() {
    return Column(
      children: [
        const Text("Lo EV"),
        SizedBox(
          height: 100,
          child: CupertinoPicker(
            itemExtent: 32,
            scrollController: FixedExtentScrollController(initialItem: evValues.indexOf(session.lowEV)),
            onSelectedItemChanged: (v) => setState(() => session.lowEV = evValues[v]),
            children: evValues.map((e) => Text(e.toStringAsFixed(1))).toList(),
          ),
        ),
        const Text("Hi EV"),
        SizedBox(
          height: 100,
          child: CupertinoPicker(
            itemExtent: 32,
            scrollController: FixedExtentScrollController(initialItem: evValues.indexOf(session.highEV)),
            onSelectedItemChanged: (v) => setState(() => session.highEV = evValues[v]),
            children: evValues.map((e) => Text(e.toStringAsFixed(1))).toList(),
          ),
        ),
        const Text("Lo Zone"),
        SizedBox(
          height: 100,
          child: CupertinoPicker(
            itemExtent: 32,
            scrollController: FixedExtentScrollController(initialItem: session.lowZone),
            onSelectedItemChanged: (v) => setState(() => session.lowZone = v),
            children: List.generate(11, (i) => Text('Zone $i')),
          ),
        ),
        const Text("Hi Zone"),
        SizedBox(
          height: 100,
          child: CupertinoPicker(
            itemExtent: 32,
            scrollController: FixedExtentScrollController(initialItem: session.highZone),
            onSelectedItemChanged: (v) => setState(() => session.highZone = v),
            children: List.generate(11, (i) => Text('Zone $i')),
          ),
        ),
      ],
    );
  }
}
