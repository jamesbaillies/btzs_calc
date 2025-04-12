import 'package:flutter/cupertino.dart';
import 'package:btzs_calc/session.dart';
import 'package:btzs_calc/pages/exposure_page.dart';

class ExposureListPage extends StatefulWidget {
  const ExposureListPage({super.key});

  @override
  State<ExposureListPage> createState() => _ExposureListPageState();
}

class _ExposureListPageState extends State<ExposureListPage> {
  final List<Session> exposures = [];

  void _addNewExposure() {
    final newSession = Session();
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (_) => ExposurePage(session: newSession),
      ),
    ).then((_) {
      setState(() => exposures.add(newSession));
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);

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
            ? Center(
          child: Text(
            'No exposures yet',
            style: theme.textTheme.textStyle.copyWith(
              color: CupertinoColors.systemGrey,
            ),
          ),
        )
            : ListView.builder(
          itemCount: exposures.length,
          itemBuilder: (context, index) {
            final session = exposures[index];
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => ExposurePage(session: session),
                      ),
                    );
                  },
                  child: Container(
                    color: CupertinoColors.systemGrey6,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                session.exposureTitle.isEmpty
                                    ? 'Untitled Exposure'
                                    : session.exposureTitle,
                                style: theme.textTheme.textStyle.copyWith(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Film: ${session.filmStock}  •  Lens: ${session.focalLength.toInt()}mm',
                                style: theme.textTheme.textStyle.copyWith(
                                  fontSize: 14,
                                  color:
                                  CupertinoColors.secondaryLabel,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(CupertinoIcons.forward, size: 20),
                      ],
                    ),
                  ),
                ),
                // Divider replacement
                Container(
                  height: 1,
                  color: CupertinoColors.systemGrey4,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
