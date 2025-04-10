import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'session.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Camera')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text('Camera Type'),
            const SizedBox(height: 8),
            CupertinoSegmentedControl<String>(
              children: const {
                'Field': Text('Field'),
                'Studio': Text('Studio'),
              },
              groupValue: ['Field', 'Studio'].contains(session.cameraModel)
                  ? session.cameraModel
                  : 'Field',
              onValueChanged: (value) {
                setState(() {
                  session.cameraModel = value;
                });
              },
            ),
            const SizedBox(height: 24),
            const Text('Film Holder Type'),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: session.filmHolder,
              items: ['Standard', 'Grafmatic', 'Other']
                  .map((type) => DropdownMenuItem(
                value: type,
                child: Text(type),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  session.filmHolder = value ?? '';
                });
              },
            ),
            const SizedBox(height: 24),
            const Text('Film Stock'),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: session.filmStock,
              items: session.filmStocks
                  .map((stock) => DropdownMenuItem(
                value: stock,
                child: Text(stock),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  session.filmStock = value ?? '';
                });
              },
            ),
            const SizedBox(height: 24),
            const Text('Paper Exposure Scale (ES)'),
            Slider(
              value: session.paperES,
              min: 0.5,
              max: 2.5,
              divisions: 20,
              label: session.paperES.toStringAsFixed(2),
              onChanged: (val) => setState(() => session.paperES = val),
            ),
            Text('Paper ES: ${session.paperES.toStringAsFixed(2)}'),
            const SizedBox(height: 24),
            const Text('Flare Factor'),
            Slider(
              value: session.flareFactor,
              min: 0.0,
              max: 1.0,
              divisions: 20,
              label: session.flareFactor.toStringAsFixed(2),
              onChanged: (val) => setState(() => session.flareFactor = val),
            ),
            Text('Flare: ${session.flareFactor.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }
}