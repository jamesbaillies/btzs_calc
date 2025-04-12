import 'package:flutter/cupertino.dart';
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

  final List<double> evValues = List.generate(171, (i) => i / 10.0);
  final List<int> zoneValues = List.generate(11, (i) => i);

  Session get session => widget.session;

  @override
  void initState() {
    super.initState();
    loEvController = FixedExtentScrollController(
      initialItem: evValues.indexWhere((e) => e == session.lowEV.toDouble()),
    );
    hiEvController = FixedExtentScrollController(
      initialItem: evValues.indexWhere((e) => e == session.highEV.toDouble()),
    );
  }

  @override
  void dispose() {
    loEvController.dispose();
    hiEvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = CupertinoTheme.of(context).textTheme.textStyle;

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text("Metering")),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            CupertinoSlidingSegmentedControl<String>(
              groupValue: session.meteringMode,
              children: {
                'Incident': Text('Incident', style: textStyle),
                'Zone': Text('Zone', style: textStyle),
              },
              onValueChanged: (value) {
                if (value != null) {
                  setState(() => session.meteringMode = value);
                }
              },
            ),
            const SizedBox(height: 24),

            if (session.meteringMode == 'Incident') ...[
              buildEvPicker('Lo EV', session.lowEV, loEvController, (v) {
                setState(() => session.lowEV = evValues[v]);
              }, textStyle),
              const SizedBox(height: 12),
              buildEvPicker('Hi EV', session.highEV, hiEvController, (v) {
                setState(() => session.highEV = evValues[v]);
              }, textStyle),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'SBR: ${session.sbr.toStringAsFixed(1)}   G: ${session.contrast.toStringAsFixed(2)}   EFS: ${session.effectiveFilmSpeed.toStringAsFixed(0)}',
                  style: textStyle,
                ),
              ),
            ] else ...[
              buildZonePicker('Low Zone', session.lowZone, (v) {
                setState(() => session.lowZone = v);
              }, textStyle),
              const SizedBox(height: 12),
              buildZonePicker('High Zone', session.highZone, (v) {
                setState(() => session.highZone = v);
              }, textStyle),
            ],

            const SizedBox(height: 24),
            CupertinoTextField(
              placeholder: 'Metering Notes',
              controller: TextEditingController(text: session.meteringNotes),
              onChanged: (val) => session.meteringNotes = val,
            )
          ],
        ),
      ),
    );
  }

  Widget buildEvPicker(String label, double value, FixedExtentScrollController controller,
      ValueChanged<int> onChanged, TextStyle textStyle) {
    return Column(
      children: [
        Text(label, style: textStyle),
        SizedBox(
          height: 100,
          child: CupertinoPicker(
            scrollController: controller,
            itemExtent: 32.0,
            onSelectedItemChanged: onChanged,
            children: evValues.map((e) => Text(e.toStringAsFixed(1), style: textStyle)).toList(),
          ),
        ),
      ],
    );
  }

  Widget buildZonePicker(String label, int value, ValueChanged<int> onChanged, TextStyle textStyle) {
    return Column(
      children: [
        Text(label, style: textStyle),
        SizedBox(
          height: 100,
          child: CupertinoPicker(
            itemExtent: 32.0,
            onSelectedItemChanged: onChanged,
            children: zoneValues.map((z) => Text('Zone $z', style: textStyle)).toList(),
          ),
        ),
      ],
    );
  }
}
