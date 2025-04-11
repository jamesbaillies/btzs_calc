import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:btzs_calc/session.dart';

class FactorsPage extends StatelessWidget {
  final Session session;

  const FactorsPage({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    const List<String> filters = [
      'None', 'ND 0.3', 'ND 0.6', 'ND 0.9', 'Red', 'Orange', 'Yellow'
    ];
    const List<String> bellowsOptions = ['None', 'Distance', 'Ext', 'Mag'];
    const List<String> exposureAdjustments = [
      '-1.0', '-2/3', '-1/3', '0', '+1/3', '+2/3', '+1.0'
    ];

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Factors'),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('Filter Used'),
            CupertinoSegmentedControl<String>(
              children: {
                for (var f in filters)
                  f: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(f),
                  )
              },
              groupValue: session.selectedFilter,
              onValueChanged: (val) => session.selectedFilter = val,
            ),
            const SizedBox(height: 24),

            const Text('Bellows Factor'),
            CupertinoSegmentedControl<String>(
              children: {
                for (var option in bellowsOptions)
                  option: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(option),
                  )
              },
              groupValue: session.bellowsMode,
              onValueChanged: (val) => session.bellowsMode = val,
            ),
            const SizedBox(height: 24),

            const Text('Description'),
            Text(
              session.factorsDescription,
              style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 24),

            const Text('Exposure Adjustment'),
            CupertinoSegmentedControl<String>(
              children: {
                for (var step in exposureAdjustments)
                  step: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Text(step),
                  )
              },
              groupValue: session.exposureAdjustment,
              onValueChanged: (val) => session.exposureAdjustment = val,
            ),
          ],
        ),
      ),
    );
  }
}
