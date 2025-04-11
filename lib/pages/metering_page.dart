import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:btzs_calc/session.dart';

class MeteringPage extends StatefulWidget {
  final Session session;

  const MeteringPage({super.key, required this.session});

  @override
  State<MeteringPage> createState() => _MeteringPageState();
}

class _MeteringPageState extends State<MeteringPage> {
  late FixedExtentScrollController loEvController;
  late FixedExtentScrollController hiEvController;

  final List<double> evValues = List.generate(171, (i) => (i / 10.0));
  final List<int> zoneValues = List.generate(11, (i) => i);

  @override
  void initState() {
    super.initState();
    loEvController = FixedExtentScrollController(initialItem: evValues.indexOf(widget.session.lowEV));
    hiEvController = FixedExtentScrollController(initialItem: evValues.indexOf(widget.session.highEV));
  }

  @override
  void dispose() {
    loEvController.dispose();
    hiEvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text("Metering")),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            CupertinoSlidingSegmentedControl<String>(
              groupValue: widget.session.meteringMode,
              children: const {
                'Incident': Text('Incident'),
                'Zone': Text('Zone'),
              },
              onValueChanged: (value) {
                if (value != null) {
                  setState(() => widget.session.meteringMode = value);
                }
              },
            ),
            const SizedBox(height: 24),

            if (widget.session.meteringMode == 'Incident') ...[
              buildEvPicker('Lo EV', widget.session.lowEV, loEvController, (v) {
                setState(() => widget.session.lowEV = evValues[v]);
              }),
              const SizedBox(height: 12),
              buildEvPicker('Hi EV', widget.session.highEV, hiEvController, (v) {
                setState(() => widget.session.highEV = evValues[v]);
              }),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'SBR: ${widget.session.sbr.toStringAsFixed(1)}   G: ${widget.session.contrast.toStringAsFixed(2)}   EFS: ${widget.session.effectiveFilmSpeed.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ] else ...[
              buildZonePicker('Low Zone', widget.session.lowZone, (v) {
                setState(() => widget.session.lowZone = v);
              }),
              const SizedBox(height: 12),
              buildZonePicker('High Zone', widget.session.highZone, (v) {
                setState(() => widget.session.highZone = v);
              }),
            ],

            const SizedBox(height: 24),
            CupertinoTextField(
              placeholder: 'Metering Notes',
              controller: TextEditingController(text: widget.session.meteringNotes),
              onChanged: (val) => widget.session.meteringNotes = val,
            )
          ],
        ),
      ),
    );
  }

  Widget buildEvPicker(String label, double value, FixedExtentScrollController controller, ValueChanged<int> onChanged) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        SizedBox(
          height: 100,
          child: CupertinoPicker(
            scrollController: controller,
            itemExtent: 32.0,
            onSelectedItemChanged: onChanged,
            children: evValues.map((e) => Text(e.toStringAsFixed(1))).toList(),
          ),
        ),
      ],
    );
  }

  Widget buildZonePicker(String label, int value, ValueChanged<int> onChanged) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        SizedBox(
          height: 100,
          child: CupertinoPicker(
            scrollController: FixedExtentScrollController(initialItem: value),
            itemExtent: 32.0,
            onSelectedItemChanged: onChanged,
            children: zoneValues.map((z) => Text('Zone $z')).toList(),
          ),
        ),
      ],
    );
  }
}
