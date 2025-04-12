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
  late TextEditingController notesController;

  final List<double> evValues = List.generate(171, (i) => i / 10.0);
  final List<int> zoneValues = List.generate(11, (i) => i);

  Session get session => widget.session;

  @override
  void initState() {
    super.initState();
    loEvController = FixedExtentScrollController(
      initialItem: evValues.indexWhere((e) => e == session.lowEV),
    );
    hiEvController = FixedExtentScrollController(
      initialItem: evValues.indexWhere((e) => e == session.highEV),
    );
    notesController = TextEditingController(text: session.meteringNotes);
  }

  @override
  void dispose() {
    loEvController.dispose();
    hiEvController.dispose();
    notesController.dispose();
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
              _buildEvPicker('Lo EV', session.lowEV, loEvController, (v) {
                setState(() => session.lowEV = evValues[v]);
              }, textStyle),
              const SizedBox(height: 12),
              _buildEvPicker('Hi EV', session.highEV, hiEvController, (v) {
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
              _buildZonePicker('Low Zone', session.lowZone, (v) {
                setState(() => session.lowZone = v);
              }, textStyle),
              const SizedBox(height: 12),
              _buildZonePicker('High Zone', session.highZone, (v) {
                setState(() => session.highZone = v);
              }, textStyle),
            ],

            const SizedBox(height: 24),
            Text('Metering Notes', style: textStyle),
            const SizedBox(height: 8),
            CupertinoTextField(
              placeholder: 'e.g. backlit subject, extra stop added',
              controller: notesController,
              onChanged: (val) => session.meteringNotes = val,
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEvPicker(String label, double value,
      FixedExtentScrollController controller,
      ValueChanged<int> onChanged, TextStyle textStyle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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

  Widget _buildZonePicker(String label, int value,
      ValueChanged<int> onChanged, TextStyle textStyle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
