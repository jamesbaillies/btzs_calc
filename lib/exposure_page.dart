import 'package:flutter/cupertino.dart';
import 'session.dart';

class ExposurePage extends StatefulWidget {
  const ExposurePage({super.key});

  @override
  State<ExposurePage> createState() => _ExposurePageState();
}

class _ExposurePageState extends State<ExposurePage> {
  bool useApertureMode = session.useApertureMode;

  final List<String> apertureValues = [
    'f/2.8', 'f/4', 'f/5.6', 'f/8', 'f/11', 'f/16', 'f/22', 'f/32', 'f/45'
  ];

  final List<String> timeFractions = [
    '1/1000', '1/500', '1/250', '1/125', '1/60', '1/30', '1/15', '1/8', '1/4', '1/2', '1'
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Exposure')),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Mode'),
              CupertinoSlidingSegmentedControl<bool>(
                groupValue: useApertureMode,
                children: const {
                  true: Text('Aperture'),
                  false: Text('Speed'),
                },
                onValueChanged: (val) {
                  if (val != null) {
                    setState(() => useApertureMode = val);
                    session.useApertureMode = val;
                  }
                },
              ),
              const SizedBox(height: 24),
              if (useApertureMode)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Select Aperture'),
                    CupertinoPicker(
                      itemExtent: 36,
                      scrollController: FixedExtentScrollController(
                          initialItem: session.selectedApertureIndex),
                      onSelectedItemChanged: (index) {
                        setState(() => session.selectedApertureIndex = index);
                      },
                      children: apertureValues
                          .map((aperture) => Center(child: Text(aperture)))
                          .toList(),
                      useMagnifier: true,
                      magnification: 1.2,
                    ),
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Set Exposure Time'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildPicker(
                          label: 'Min',
                          itemCount: 6,
                          initialItem: session.selectedMin,
                          onChanged: (i) => setState(() => session.selectedMin = i),
                        ),
                        _buildPicker(
                          label: 'Sec',
                          itemCount: 60,
                          initialItem: session.selectedSec,
                          onChanged: (i) => setState(() => session.selectedSec = i),
                        ),
                        _buildPicker(
                          label: 'Frac',
                          items: timeFractions,
                          initialItem: session.selectedFraction,
                          onChanged: (i) => setState(() => session.selectedFraction = i),
                        ),
                      ],
                    ),
                  ],
                ),
              const SizedBox(height: 24),
              const Text('Note: Film not selected (example validation)'),
              const SizedBox(height: 24),
              CupertinoButton.filled(
                child: const Text('Done'),
                onPressed: () {
                  // Possibly save to storage here
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPicker({
    required String label,
    int itemCount = 0,
    List<String>? items,
    required int initialItem,
    required void Function(int) onChanged,
  }) {
    final List<Widget> children = items != null
        ? items.map((e) => Center(child: Text(e))).toList()
        : List.generate(itemCount, (i) => Center(child: Text(i.toString())));

    return Column(
      children: [
        Text(label),
        SizedBox(
          width: 60,
          height: 120,
          child: CupertinoPicker(
            itemExtent: 36,
            scrollController: FixedExtentScrollController(initialItem: initialItem),
            onSelectedItemChanged: onChanged,
            children: children,
            useMagnifier: true,
            magnification: 1.2,
          ),
        ),
      ],
    );
  }
}
