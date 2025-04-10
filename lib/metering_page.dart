import 'package:flutter/cupertino.dart';
import 'session.dart';

class MeteringPage extends StatefulWidget {
  const MeteringPage({super.key});

  @override
  State<MeteringPage> createState() => _MeteringPageState();
}

class _MeteringPageState extends State<MeteringPage> {
  Widget buildPicker({
    required int value,
    required int min,
    required int max,
    required void Function(int) onChanged,
  }) {
    return CupertinoPicker(
      scrollController: FixedExtentScrollController(initialItem: value),
      itemExtent: 36,
      onSelectedItemChanged: onChanged,
      children: List.generate(max - min + 1, (i) => Center(child: Text((min + i).toString()))),
      useMagnifier: true,
      magnification: 1.2,
      diameterRatio: 1.2,
      squeeze: 1.1,
      looping: false,
      selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(),
    );
  }

  Widget buildMeteringRow(String label1, int value1, void Function(int) onChanged1,
      String label2, int value2, void Function(int) onChanged2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Text(label1),
            SizedBox(
              height: 150,
              width: 80,
              child: buildPicker(value: value1, min: 0, max: 20, onChanged: onChanged1),
            ),
          ],
        ),
        Column(
          children: [
            Text(label2),
            SizedBox(
              height: 150,
              width: 80,
              child: buildPicker(value: value2, min: 0, max: 10, onChanged: onChanged2),
            ),
          ],
        ),
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
              onValueChanged: (mode) => setState(() => session.meteringMode = mode),
            ),
            const SizedBox(height: 24),
            buildMeteringRow(
              'Lo EV',
              session.lowEV.toInt(),
                  (v) => setState(() => session.lowEV = v.toDouble()),
              'Lo Zone',
              session.lowZone.toInt(),
                  (v) => setState(() => session.lowZone = v.toDouble()),
            ),
            const SizedBox(height: 24),
            buildMeteringRow(
              'Hi EV',
              session.highEV.toInt(),
                  (v) => setState(() => session.highEV = v.toDouble()),
              'Hi Zone',
              session.highZone.toInt(),
                  (v) => setState(() => session.highZone = v.toDouble()),
            ),
          ],
        ),
      ),
    );
  }
}
