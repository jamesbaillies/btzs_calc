import 'package:flutter/cupertino.dart';
import 'package:btzs_calc/session.dart';
import 'package:btzs_calc/pages/exposure_summary_page.dart';
import 'package:btzs_calc/utils/curve_loader.dart';

class ExposurePage extends StatelessWidget {
  final Session session;

  const ExposurePage({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
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
            const Text('Exposure Settings',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _buildInfoTile('Mode', session.useApertureMode ? 'Aperture Priority' : 'Shutter Priority'),
            _buildInfoTile('Aperture', 'f/${session.aperture}'),
            _buildInfoTile('Shutter', session.shutterTimeString),
            _buildInfoTile('Ideal Exposure', session.idealExposureString),
            const SizedBox(height: 40),
            CupertinoButton.filled(
              child: const Text('View Summary'),
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

  Widget _buildInfoTile(String label, String value) {
    return CupertinoFormRow(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      prefix: Text(label),
      child: Text(value, textAlign: TextAlign.right),
    );
  }
}