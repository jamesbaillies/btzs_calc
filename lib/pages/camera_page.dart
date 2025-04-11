// camera_page.dart (starting structure for functional update)

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.session.exposureTitle);
    holderController = TextEditingController(text: widget.session.filmHolder);
    focalLengthController = TextEditingController(text: widget.session.focalLength.toString());
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
              onChanged: (val) => setState(() => widget.session.exposureTitle = val),
            ),
            const SizedBox(height: 12),
            CupertinoTextField(
              controller: holderController,
              placeholder: 'Holder Number',
              onChanged: (val) => setState(() => widget.session.filmHolder = val),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                // TODO: open modal to pick film stock from widget.session.filmStocks
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
                    const Text('Film', style: TextStyle(fontSize: 16)),
                    Text(widget.session.filmStock ?? 'Select', style: const TextStyle(color: CupertinoColors.activeBlue)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            CupertinoTextField(
              controller: focalLengthController,
              placeholder: 'Focal Length (mm)',
              keyboardType: TextInputType.number,
              onChanged: (val) {
                final parsed = double.tryParse(val);
                if (parsed != null) {
                  setState(() => widget.session.focalLength = parsed);
                }
              },
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Flare Factor'),
                CupertinoPicker(
                  itemExtent: 32,
                  scrollController: FixedExtentScrollController(initialItem: (widget.session.flareFactor * 100).toInt()),
                  onSelectedItemChanged: (val) {
                    setState(() => widget.session.flareFactor = val / 100);
                  },
                  children: List.generate(101, (i) => Text((i / 100).toStringAsFixed(2))),
                )
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Paper ES'),
                CupertinoPicker(
                  itemExtent: 32,
                  scrollController: FixedExtentScrollController(initialItem: (widget.session.paperES * 100).toInt()),
                  onSelectedItemChanged: (val) {
                    setState(() => widget.session.paperES = val / 100);
                  },
                  children: List.generate(401, (i) => Text((i / 100).toStringAsFixed(2))),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
