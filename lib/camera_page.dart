import 'package:flutter/cupertino.dart';
import 'session.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final cameraModels = ['4x5 View', '8x10 Field', 'Custom'];
  final filmHolders = ['Fidelity Elite', 'Graflex', 'Custom'];
  final filmStocks = ['FP4+', 'HP5+', 'Tri-X', 'TMax 100', 'Custom'];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Camera Setup'),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('Camera Model'),
            CupertinoSegmentedControl<String>(
              children: {
                for (var model in cameraModels)
                  model: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(model),
                  ),
              },
              groupValue: session.cameraModel,
              onValueChanged: (value) =>
                  setState(() => session.cameraModel = value),
            ),
            const SizedBox(height: 24),
            const Text('Film Holder Type'),
            CupertinoSlidingSegmentedControl<String>(
              children: {
                for (var holder in filmHolders)
                  holder: Text(holder),
              },
              groupValue: session.filmHolder,
              onValueChanged: (value) =>
                  setState(() => session.filmHolder = value ?? ''),
            ),
            const SizedBox(height: 24),
            const Text('Film Stock'),
            CupertinoPicker(
              itemExtent: 32,
              scrollController: FixedExtentScrollController(
                initialItem:
                filmStocks.indexOf(session.filmStock),
              ),
              onSelectedItemChanged: (index) =>
                  setState(() => session.filmStock = filmStocks[index]),
              children: filmStocks
                  .map((stock) => Center(child: Text(stock)))
                  .toList(),
            ),
            const SizedBox(height: 24),
            const Text('Paper ES'),
            CupertinoSlider(
              value: session.paperES,
              min: 0.8,
              max: 1.5,
              divisions: 14,
              onChanged: (val) =>
                  setState(() => session.paperES = val),
            ),
            Text('Paper ES: ${session.paperES.toStringAsFixed(2)}'),
            const SizedBox(height: 24),
            const Text('Flare Factor'),
            CupertinoSlider(
              value: session.flareFactor,
              min: 0.0,
              max: 1.0,
              divisions: 20,
              onChanged: (val) =>
                  setState(() => session.flareFactor = val),
            ),
            Text('Flare: ${session.flareFactor.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }
}
