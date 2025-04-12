import 'package:flutter/cupertino.dart';
import 'package:btzs_calc/session.dart';

class CameraPage extends StatefulWidget {
  final Session session;

  const CameraPage({super.key, required this.session});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late TextEditingController titleController;
  late TextEditingController holderController;
  late TextEditingController focalLengthController;

  Session get session => widget.session;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: session.exposureTitle);
    holderController = TextEditingController(text: session.filmHolder);
    focalLengthController = TextEditingController(text: session.focalLength.toString());
  }

  @override
  void dispose() {
    titleController.dispose();
    holderController.dispose();
    focalLengthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = CupertinoTheme.of(context).textTheme.textStyle;

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Camera'),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            CupertinoTextField(
              controller: titleController,
              placeholder: 'Title',
              style: textStyle,
              onChanged: (val) => setState(() => session.exposureTitle = val),
            ),
            const SizedBox(height: 12),
            CupertinoTextField(
              controller: holderController,
              placeholder: 'Holder Number',
              style: textStyle,
              onChanged: (val) => setState(() => session.filmHolder = val),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                // TODO: implement film stock selector
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey6,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Film', style: textStyle),
                    Text(session.filmStock, style: textStyle.copyWith(color: CupertinoColors.activeBlue)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            CupertinoTextField(
              controller: focalLengthController,
              placeholder: 'Focal Length (mm)',
              keyboardType: TextInputType.number,
              style: textStyle,
              onChanged: (val) {
                final parsed = double.tryParse(val);
                if (parsed != null) {
                  setState(() => session.focalLength = parsed);
                }
              },
            ),
            const SizedBox(height: 24),
            _buildPickerRow(
              label: 'Flare Factor',
              value: session.flareFactor,
              onChanged: (val) => setState(() => session.flareFactor = val),
              divisions: 100,
            ),
            const SizedBox(height: 24),
            _buildPickerRow(
              label: 'Paper ES',
              value: session.paperES,
              onChanged: (val) => setState(() => session.paperES = val),
              divisions: 400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPickerRow({
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
    required int divisions,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        CupertinoPicker(
          itemExtent: 32,
          scrollController: FixedExtentScrollController(initialItem: (value * 100).toInt()),
          onSelectedItemChanged: (val) => onChanged(val / 100),
          children: List.generate(divisions + 1, (i) => Text((i / 100).toStringAsFixed(2))),
        ),
      ],
    );
  }
}
