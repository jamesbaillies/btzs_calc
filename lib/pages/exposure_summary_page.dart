import 'package:flutter/cupertino.dart';
import 'package:btzs_calc/session.dart';
import 'package:btzs_calc/utils/curve_loader.dart';

class ExposureSummaryPage extends StatelessWidget {
  final Session session;
  final FilmCurve? filmCurve;

  const ExposureSummaryPage({super.key, required this.session, this.filmCurve});

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context).textTheme;

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Summary')),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionTitle('Camera', theme),
            _buildInfoTile('Title', session.exposureTitle, theme),
            _buildInfoTile('Holder', session.filmHolder, theme),
            _buildInfoTile('Film', session.filmStock, theme),
            _buildInfoTile('Lens', '${session.focalLength.toInt()}mm', theme),
            _buildInfoTile('Flare Factor', session.flareFactor.toStringAsFixed(2), theme),
            _buildInfoTile('Paper ES', session.paperES.toStringAsFixed(2), theme),

            _buildSectionTitle('Metering', theme),
            _buildInfoTile('Method', session.meteringMode, theme),
            _buildInfoTile('Low EV', session.lowEV.toStringAsFixed(1), theme),
            _buildInfoTile('High EV', session.highEV.toStringAsFixed(1), theme),
            _buildInfoTile('SBR', session.sbr.toStringAsFixed(1), theme),
            _buildInfoTile('Average G', session.averageG.toStringAsFixed(2), theme),
            _buildInfoTile('EFS', session.effectiveFilmSpeed.toStringAsFixed(0), theme),

            _buildSectionTitle('Factors', theme),
            _buildInfoTile('Filter', session.filterName, theme),
            _buildInfoTile('Bellows Method', session.bellowsMode, theme),
            _buildInfoTile('Subject Magnification', session.magnification.toStringAsFixed(2), theme),
            _buildInfoTile('Bellows Factor', session.bellowsFactor.toStringAsFixed(2), theme),
            _buildInfoTile('Exposure Adjustment', session.exposureAdjustmentLabel, theme),

            _buildSectionTitle('Depth of Field', theme),
            _buildInfoTile('DOF Mode', _formatDOFMode(session.dofMode), theme),
            _buildInfoTile('CoC', session.circleOfConfusionLabel, theme),
            _buildInfoTile('Focus Spread', session.focusSpread.toStringAsFixed(1), theme),

            _buildSectionTitle('Exposure', theme),
            _buildInfoTile('Exposure Mode', session.useApertureMode ? 'Aperture' : 'Speed', theme),
            _buildInfoTile('Aperture Set', 'f/${session.aperture}', theme),
            _buildInfoTile('Exposure', session.shutterTimeString, theme),
            _buildInfoTile('Ideal Exposure', session.idealExposureString, theme),

            _buildSectionTitle('Development', theme),
            _buildInfoTile('Info', filmCurve?.developerInfo ?? '—', theme),
            _buildInfoTile('Time', filmCurve?.developmentTime.toString() ?? '—', theme),

            const SizedBox(height: 40),
            CupertinoButton.filled(
              child: Text("Back to Start", style: theme.actionTextStyle),
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

  Widget _buildSectionTitle(String title, CupertinoTextThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: theme.navTitleTextStyle.merge(
          const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
