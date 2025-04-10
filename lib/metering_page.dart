// metering_page.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'session.dart';

class MeteringPage extends StatefulWidget {
  const MeteringPage({super.key});

  @override
  State<MeteringPage> createState() => _MeteringPageState();
}

class _MeteringPageState extends State<MeteringPage> {
  final notesController = TextEditingController(text: session.meteringNotes);

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }

  Widget buildPicker({required double value, required double min, required double max, required void Function(double) onChanged}) {
    final items = List.generate(((max - min) * 10 + 1).toInt(), (i) => (min + i * 0.1).toStringAsFixed(1));
    final index = ((value - min) * 10).round();

    return CupertinoPicker(
      scrollController: FixedExtentScrollController(initialItem: index),
      itemExtent: 40,
      onSelectedItemChanged: (i) => onChanged(double.parse(items[i])),
      children: items.map((e) => Center(child: Text(e))).toList(),
      useMagnifier: true,
      magnification: 1.2,
    );
  }

  Widget buildMeteringRow(String label1, double value1, void Function(double) onChange1, String label2, double value2, void Function(double) onChange2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(children: [Text(label1), SizedBox(height: 150, width: 80, child: buildPicker(value: value1, min: 0, max: 20, onChanged: onChange1))]),
        Column(children: [Text(label2), SizedBox(height: 150, width: 80, child: buildPicker(value: value2, min: 0, max: 10, onChanged: onChange2))]),
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
            CupertinoSegmentedControl<String>(
              children: const {
                'Incident': Text('Incident'),
                'Zone': Text('Zone'),
              },
              groupValue: session.meteringMode,
              onValueChanged: (val) => setState(() => session.meteringMode = val),
            ),
            const SizedBox(height: 24),
            buildMeteringRow('Lo EV', session.lowEV, (v) => setState(() => session.lowEV = v), 'Lo Zone', session.lowZone, (v) => setState(() => session.lowZone = v)),
            const SizedBox(height: 16),
            buildMeteringRow('Hi EV', session.highEV, (v) => setState(() => session.highEV = v), 'Hi Zone', session.highZone, (v) => setState(() => session.highZone = v)),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: CupertinoColors.systemGrey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                session.filmStock.isEmpty ? 'Film has not been selected' : 'Film: ${session.filmStock}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 24),
            CupertinoTextField(
              controller: notesController,
              placeholder: 'Metering Notes',
              onChanged: (val) => session.meteringNotes = val,
            )
          ],
        ),
      ),
    );
  }
}
