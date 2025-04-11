import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'session.dart';

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
            const SizedBox(height: 24),
            CupertinoSegmentedControl<String>(
              children: const {
                'Incident': Text('Incident'),
                'Zone': Text('Zone'),
              },
              groupValue: session.meteringMode,
              onValueChanged: (String mode) {
                setState(() {
                  session.meteringMode = mode;
                });
              },
            ),
            const SizedBox(height: 24),
            if (session.meteringMode == 'Zone') ...[
              const Text('Low EV'),
              CupertinoPicker(
                itemExtent: 32,
                scrollController: FixedExtentScrollController(
                  initialItem: session.lowEV,
                ),
                onSelectedItemChanged: (v) =>
                    setState(() => session.lowEV = v),
                children: List.generate(21, (index) => Text('${index - 5} EV')),
              ),
              const Text('Low Zone'),
              CupertinoPicker(
                itemExtent: 32,
                scrollController: FixedExtentScrollController(
                  initialItem: session.lowZone,
                ),
                onSelectedItemChanged: (v) =>
                    setState(() => session.lowZone = v),
                children: List.generate(11, (index) => Text('Zone $index')),
              ),
              const Text('High EV'),
              CupertinoPicker(
                itemExtent: 32,
                scrollController: FixedExtentScrollController(
                  initialItem: session.highEV,
                ),
                onSelectedItemChanged: (v) =>
                    setState(() => session.highEV = v),
                children: List.generate(21, (index) => Text('${index - 5} EV')),
              ),
              const Text('High Zone'),
              CupertinoPicker(
                itemExtent: 32,
                scrollController: FixedExtentScrollController(
                  initialItem: session.highZone,
                ),
                onSelectedItemChanged: (v) =>
                    setState(() => session.highZone = v),
                children: List.generate(11, (index) => Text('Zone $index')),
              ),
            ] else ...[
              const Text('Incident Reading'),
              CupertinoPicker(
                itemExtent: 32,
                scrollController: FixedExtentScrollController(
                  initialItem: session.incidentEV,
                ),
                onSelectedItemChanged: (v) =>
                    setState(() => session.incidentEV = v),
                children: List.generate(21, (index) => Text('${index - 5} EV')),
              ),
            ]
          ],
        ),
      ),
    );
  }
}