import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'session.dart';

class MeteringPage extends StatefulWidget {
  const MeteringPage({Key? key}) : super(key: key);

  @override
  State<MeteringPage> createState() => _MeteringPageState();
}

class _MeteringPageState extends State<MeteringPage> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Metering')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text('Metering Mode', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            CupertinoSegmentedControl<String>(
              children: const {
                'Lo': Text('Lo'),
                'Hi': Text('Hi'),
              },
              groupValue: ['Lo', 'Hi'].contains(session.meteringMode)
                  ? session.meteringMode
                  : 'Lo',
              onValueChanged: (mode) {
                setState(() => session.meteringMode = mode);
              },
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const Text('Lo EV'),
                    SizedBox(
                      height: 150,
                      width: 80,
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                          initialItem: session.lowEV.toInt(),
                        ),
                        itemExtent: 40,
                        onSelectedItemChanged: (v) =>
                            setState(() => session.lowEV = v.toDouble()),
                        children: List.generate(21, (i) => Text('$i')),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text('Lo Zone'),
                    SizedBox(
                      height: 150,
                      width: 80,
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                          initialItem: session.lowZone.toInt(),
                        ),
                        itemExtent: 40,
                        onSelectedItemChanged: (v) =>
                            setState(() => session.lowZone = v.toDouble()),
                        children: List.generate(11, (i) => Text('$i')),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const Text('Hi EV'),
                    SizedBox(
                      height: 150,
                      width: 80,
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                          initialItem: session.highEV.toInt(),
                        ),
                        itemExtent: 40,
                        onSelectedItemChanged: (v) =>
                            setState(() => session.highEV = v.toDouble()),
                        children: List.generate(21, (i) => Text('$i')),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text('Hi Zone'),
                    SizedBox(
                      height: 150,
                      width: 80,
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                          initialItem: session.highZone.toInt(),
                        ),
                        itemExtent: 40,
                        onSelectedItemChanged: (v) =>
                            setState(() => session.highZone = v.toDouble()),
                        children: List.generate(11, (i) => Text('$i')),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
