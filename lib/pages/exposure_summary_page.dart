import 'package:flutter/cupertino.dart';
import 'package:btzs_calc/session.dart';
import 'package:btzs_calc/utils/curve_loader.dart';

class ExposureSummaryPage extends StatelessWidget {
  final Session session;
  final FilmCurve? filmCurve;

  const ExposureSummaryPage({super.key, required this.session, this.filmCurve});

  @override
  Widget build(BuildContext context) {
    final textTheme = CupertinoTheme.of(context).textTheme;

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Summary')),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionTitle(context, 'Camera'),
            _buildInfoTile('Title', session.exposureTitle),
            _buildInfoTile('Holder', session.filmHolder),
            _buildInfoTile('Film', session.filmStock),
            _buildInfoTile('Lens', '${session.focalLength.toInt()}mm'),
            _buildInfoTile('Flare Factor', session.flareFactor.toStringAsFixed(2)),
            _buildInfoTile('Paper ES', session.paperES.toStringAsFixed(2)),

            _buildSectionTitle(context, 'Metering'),
            _buildInfoTile('Method', session.meteringMode),
            _buildInfoTile('Low EV', session.lowEV.toStringAsFixed(1)),
            _buildInfoTile('High EV', session.highEV.toStringAsFixed(1)),
            _buildInfoTile('SBR', session.sbr.toStringAsFixed(1)),
            _buildInfoTile('Average G', session.averageG.toStringAsFixed(2)),
            _buildInfoTile('EFS', session.effectiveFilmSpeed.toStringAsFixed(0)),

            _buildSectionTitle(context, 'Factors'),
            _buildInfoTile('Filter', session.filterName),
            _buildInfoTile('Bellows Method', session.bellowsMode),
            _buildInfoTile('Subject Magnification', session.magnification.toStringAsFixed(2)),
            _buildInfoTile('Bellows Factor', session.bellowsFactor.toStringAsFixed(2)),
            _buildInfoTile('Exposure Adjustment', session.exposureAdjustmentLabel),

            _buildSectionTitle(context, 'Depth of Field'),
            _buildInfoTile('DOF Mode', _formatDOFMode(session.dofMode)),
            _buildInfoTile('CoC', session.circleOfConfusionLabel),
            _buildInfoTile('Focus Spread', session.focusSpread.toStringAsFixed(1)),

            _buildSectionTitle(context, 'Exposure'),
            _buildInfoTile('Exposure Mode', session.useApertureMode ? 'Aperture' : 'Speed'),
            _buildInfoTile('Aperture Set', 'f/${session.aperture}'),
            _buildInfoTile('Exposure', session.shutterTimeString),
            _buildInfoTile('Ideal Exposure', session.idealExposureString),

            _buildSectionTitle(context, 'Development'),
            _buildInfoTile('Info', filmCurve?.developerInfo ?? '—'),
            _buildInfoTile('Time', filmCurve?.developmentTime.toString() ?? '—'),

            const SizedBox(height: 40),
            CupertinoButton.filled(
              child: const Text("Back to Start"),
              onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDOFMode(DOFMode mode) {
    switch (mode) {
      case DOFMode.none:
        return 'None';
      case DOFMode.check:
        return 'Check';
      case DOFMode.distance:
        return 'Distance';
      case DOFMode.focus:
        return 'Focus';
    }
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: DefaultTextStyle.of(context).style.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.bold,
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
