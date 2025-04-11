import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:btzs_calc/session.dart';

class MeteringPage extends StatefulWidget {
  const MeteringPage({Key? key}) : super(key: key);

  @override
  State<MeteringPage> createState() => _MeteringPageState();
}

class _MeteringPageState extends State<MeteringPage> {
  final session = Session();

  final Map<int, Widget> segmentOptions = const <int, Widget>{
    0: Text('Incident'),
    1: Text('Zone'),
  };

  int selectedSegment = 0;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Metering'),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            CupertinoSegmentedControl<int>(
              children: segmentOptions,
              groupValue: selectedSegment,
              onValueChanged: (int value) {
                setState(() {
                  selectedSegment = value;
                });
              },
            ),
            const SizedBox(height: 32),
            if (selectedSegment == 0) ...[
              Text('EV: ${session.incidentEV}'),
              CupertinoPicker(
                itemExtent: 40,
                scrollController: FixedExtentScrollController(
                    initialItem: session.incidentEV),
                onSelectedItemChanged: (v) =>
                    setState(() => session.incidentEV = v),
                children:
                List.generate(21, (i) => Text('${i - 5} EV')), // -5 to +15
              ),
            ] else if (selectedSegment == 1) ...[
              Text('Zone Reading: Not implemented yet'),
            ],
          ],
        ),
      ),
    );
  }
}
