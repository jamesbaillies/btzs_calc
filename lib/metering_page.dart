import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:btzs_calc/session.dart';

class MeteringPage extends StatefulWidget {
  const MeteringPage({super.key});

  @override
  State<MeteringPage> createState() => _MeteringPageState();
}

class _MeteringPageState extends State<MeteringPage> {
  final session = Session();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Metering')),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),

            // Toggle between Incident and Zone modes
            CupertinoSegmentedControl<String>(
              children: const {
                'Incident': Text('Incident'),
                'Zone': Text('Zone'),
              },
              groupValue: session.meteringMode,
              onValueChanged: (mode) => setState(() => session.meteringMode = mode),
            ),

            const SizedBox(height: 32),
            const Text('Low EV', style: TextStyle(color: Colors.white)),
            CupertinoPicker(
              magnification: 1.2,
              useMagnifier: true,
              itemExtent: 40,
              scrollController: FixedExtentScrollController(initialItem: session.lowEV.toInt()),
              onSelectedItemChanged: (v) => setState(() => session.lowEV = v.toDouble()),
              children: List<Widget>.generate(25, (i) => Text('EV $i', style: const TextStyle(color: Colors.white))),
            ),

            const Text('Low Zone', style: TextStyle(color: Colors.white)),
            CupertinoPicker(
              magnification: 1.2,
              useMagnifier: true,
              itemExtent: 40,
              scrollController: FixedExtentScrollController(initialItem: session.lowZone.toInt()),
              onSelectedItemChanged: (v) => setState(() => session.lowZone = v.toDouble()),
              children: List<Widget>.generate(12, (i) => Text('Zone $i', style: const TextStyle(color: Colors.white))),
            ),

            const Text('High EV', style: TextStyle(color: Colors.white)),
            CupertinoPicker(
              magnification: 1.2,
              useMagnifier: true,
              itemExtent: 40,
              scrollController: FixedExtentScrollController(initialItem: session.highEV.toInt()),
              onSelectedItemChanged: (v) => setState(() => session.highEV = v.toDouble()),
              children: List<Widget>.generate(25, (i) => Text('EV $i', style: const TextStyle(color: Colors.white))),
            ),

            const Text('High Zone', style: TextStyle(color: Colors.white)),
            CupertinoPicker(
              magnification: 1.2,
              useMagnifier: true,
              itemExtent: 40,
              scrollController: FixedExtentScrollController(initialItem: session.highZone.toInt()),
              onSelectedItemChanged: (v) => setState(() => session.highZone = v.toDouble()),
              children: List<Widget>.generate(12, (i) => Text('Zone $i', style: const TextStyle(color: Colors.white))),
            ),
          ],
        ),
      ),
    );
  }
}
