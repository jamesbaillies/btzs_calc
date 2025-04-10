// lib/exposure_page.dart

import 'package:flutter/cupertino.dart';
import 'session.dart';

class ExposurePage extends StatefulWidget {
   ExposurePage({super.key});

  @override
  State<ExposurePage> createState() => _ExposurePageState();
}

class _ExposurePageState extends State<ExposurePage> {
  final session = Session();
  late bool useApertureMode;

  @override
  void initState() {
    super.initState();
    useApertureMode = session.useApertureMode;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Exposure')),
      child: SafeArea(
        child: Column(
          children: [
            CupertinoSlidingSegmentedControl<bool>(
              groupValue: useApertureMode,
              children: const {
                true: Text('Aperture'),
                false: Text('Shutter'),
              },
              onValueChanged: (val) {
                if (val != null) {
                  setState(() {
                    useApertureMode = val;
                    session.useApertureMode = val;
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            if (useApertureMode)
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 32,
                  scrollController: FixedExtentScrollController(
                      initialItem: session.selectedApertureIndex),
                  onSelectedItemChanged: (index) => setState(
                          () => session.selectedApertureIndex = index),
                  children:
                  session.apertureValues.map((f) => Text('f/$f')).toList(),
                ),
              )
            else
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: CupertinoPicker(
                        itemExtent: 32,
                        scrollController: FixedExtentScrollController(
                            initialItem: session.selectedMin),
                        onSelectedItemChanged: (i) =>
                            setState(() => session.selectedMin = i),
                        children: List.generate(10, (i) => Text('$i min')),
                      ),
                    ),
                    Expanded(
                      child: CupertinoPicker(
                        itemExtent: 32,
                        scrollController: FixedExtentScrollController(
                            initialItem: session.selectedSec),
                        onSelectedItemChanged: (i) =>
                            setState(() => session.selectedSec = i),
                        children: List.generate(60, (i) => Text('$i sec')),
                      ),
                    ),
                    Expanded(
                      child: CupertinoPicker(
                        itemExtent: 32,
                        scrollController: FixedExtentScrollController(
                            initialItem: session.selectedFraction),
                        onSelectedItemChanged: (i) =>
                            setState(() => session.selectedFraction = i),
                        children: List.generate(
                            session.shutterFractions.length,
                                (i) => Text('1/${session.shutterFractions[i]}')),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
