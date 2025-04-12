import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:btzs_calc/session.dart';
import 'package:btzs_calc/pages/exposure_page.dart';

class ExposureListPage extends StatefulWidget {
  const ExposureListPage({super.key});

  @override
  State<ExposureListPage> createState() => _ExposureListPageState();
}

class _ExposureListPageState extends State<ExposureListPage> {
  final List<Session> exposures = [];

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('exposures') ?? [];

    setState(() {
      exposures.clear();
      exposures.addAll(saved.map((jsonStr) {
        final map = json.decode(jsonStr);
        return Session.fromJson(map);
      }));
    });
  }

  Future<void> _saveSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final list = exposures.map((s) => json.encode(s.toJson())).toList();
    await prefs.setStringList('exposures', list);
  }

  void _addNewExposure() async {
    try {
      final newSession = Session();
      await Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (_) => ExposurePage(session: newSession),
        ),
      );
      setState(() {
        exposures.add(newSession);
        _saveSessions();
      });
    } catch (e, stackTrace) {
      print('Navigation error: $e');
      print(stackTrace);
      if (context.mounted) {
        showCupertinoDialog(
          context: context,
          builder: (ctx) => CupertinoAlertDialog(
            title: const Text('Error'),
            content: Text('$e'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(ctx),
              )
            ],
          ),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('BTZS Exposures'),
        trailing: GestureDetector(
          onTap: _addNewExposure,
          child: const Icon(CupertinoIcons.add),
        ),
      ),
      child: SafeArea(
        child: exposures.isEmpty
            ? const Center(
          child: Text(
            'No exposures yet',
            style: TextStyle(
              color: CupertinoColors.systemGrey,
              fontSize: 16,
            ),
          ),
        )
            : ListView.separated(
          itemCount: exposures.length,
          separatorBuilder: (_, __) => const SizedBox(
            height: 1,
            child: ColoredBox(color: CupertinoColors.systemGrey4),
          ),
          itemBuilder: (context, index) {
            final session = exposures[index];
            final title = session.exposureTitle.isNotEmpty
                ? session.exposureTitle
                : 'Untitled Exposure';
            final lens = session.focalLength.toInt();
            final film =
            session.filmStock.isNotEmpty ? session.filmStock : '—';

            return CupertinoListTile(
              title: Text(title),
              subtitle: Text('Film: $film • Lens: ${lens}mm'),
              trailing: const CupertinoListTileChevron(),
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (_) => ExposurePage(session: session),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
