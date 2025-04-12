import 'package:flutter/cupertino.dart';
import 'package:btzs_calc/session.dart';
import 'package:btzs_calc/pages/exposure_summary_page.dart';

class ExposurePage extends StatelessWidget {
  final Session session;

  const ExposurePage({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context).textTheme;
    final filmCurve = session.filmStock.isNotEmpty
        ? session.loadedFilmCurves[session.filmStock]
        : null;

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Exposure'),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Exposure Settings',
              style: theme.navTitleTextStyle.merge(
                const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            _buildInfoTile('Mode',
                session.useApertureMode ? 'Aperture Priority' : 'Shutter Priority', theme),
            _buildInfoTile('Aperture', 'f/${session.aperture}', theme),
            _buildInfoTile('Shutter', session.shutterTimeString, theme),
            _buildInfoTile('Ideal Exposure', session.idealExposureString, theme),
            const SizedBox(height: 40),
            CupertinoButton.filled(
              child: Text('View Summary', style: theme.actionTextStyle),
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => ExposureSummaryPage(
                      session: session,
                      filmCurve: filmCurve,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value, CupertinoTextThemeData theme) {
    return CupertinoFormRow(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      prefix: Text(label, style: theme.textStyle),
      child: Text(value, textAlign: TextAlign.right, style: theme.textStyle),
    );
  }
}
