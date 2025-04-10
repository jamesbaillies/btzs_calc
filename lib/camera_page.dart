import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'session.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final session = Session();
  final titleController = TextEditingController();
  final filmHolderController = TextEditingController();
  final focalLengthController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.text = session.exposureTitle;
    filmHolderController.text = session.filmHolder;
    focalLengthController.text = session.focalLength.toString();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Camera Setup'),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              const Text('Exposure Title', style: TextStyle(color: Colors.white)),
              CupertinoTextField(
                controller: titleController,
                onChanged: (val) => setState(() => session.exposureTitle = val),
              ),
              const SizedBox(height: 16),

              const Text('Film Holder', style: TextStyle(color: Colors.white)),
              CupertinoTextField(
                controller: filmHolderController,
                onChanged: (val) => setState(() => session.filmHolder = val),
              ),
              const SizedBox(height: 16),

              const Text('Film Stock', style: TextStyle(color: Colors.white)),
              CupertinoButton(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                onPressed: () => _showFilmStockPicker(context),
                child: Text(session.filmStock, style: const TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 16),

              const Text('Focal Length (mm)', style: TextStyle(color: Colors.white)),
              Row(
                children: [
                  Expanded(
                    child: CupertinoTextField(
                      controller: focalLengthController,
                      keyboardType: TextInputType.number,
                      onSubmitted: (val) {
                        final parsed = double.tryParse(val);
                        if (parsed != null) {
                          setState(() {
                            session.focalLength = parsed;
                            if (!session.savedFocalLengths.contains(parsed.toInt())) {
                              session.savedFocalLengths.add(parsed.toInt());
                            }
                          });
                        }
                      },
                    ),
                  ),
                  CupertinoButton(
                    child: const Text('▼'),
                    onPressed: () => _showFocalLengthPicker(context),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilmStockPicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => SizedBox(
        height: 250,
        child: CupertinoPicker(
          itemExtent: 32.0,
          scrollController: FixedExtentScrollController(
            initialItem: session.filmStocks.indexOf(session.filmStock),
          ),
          onSelectedItemChanged: (index) => setState(() {
            session.filmStock = session.filmStocks[index];
          }),
          children: session.filmStocks.map((stock) => Text(stock)).toList(),
        ),
      ),
    );
  }

  void _showFocalLengthPicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => SizedBox(
        height: 250,
        child: CupertinoPicker(
          itemExtent: 32.0,
          scrollController: FixedExtentScrollController(
            initialItem: session.savedFocalLengths.indexOf(session.focalLength.toInt()),
          ),
          onSelectedItemChanged: (index) => setState(() {
            session.focalLength = session.savedFocalLengths[index].toDouble();
            focalLengthController.text = session.focalLength.toString();
          }),
          children: session.savedFocalLengths.map((f) => Text('$f mm')).toList(),
        ),
      ),
    );
  }
}
