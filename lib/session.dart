import 'package:flutter/foundation.dart';

enum DOFMode { none, check, distance, focus }

class Session extends ChangeNotifier {
  // Basic Exposure Info
  String exposureTitle = '';
  int iso = 100;
  double aperture = 8.0;
  double focalLength = 210.0;

  // Film Stock
  List<String> filmStocks = ['HP5+', 'Tri-X', 'FP4+', 'T-Max 100'];
  String filmStock = 'HP5+';

  // Shutter Info
  int selectedMin = 0;
  int selectedSec = 1;
  int selectedFraction = 0;
  String get shutterTimeString {
    if (selectedMin > 0) {
      return "$selectedMin:${selectedSec.toString().padLeft(2, '0')} min";
    } else if (selectedSec > 0) {
      return "$selectedSec sec";
    } else if (selectedFraction > 0) {
      return "1/${[1, 2, 4, 8, 15, 30, 60, 125, 250, 500][selectedFraction]} sec";
    } else {
      return "1 sec";
    }
  }

  // Exposure Calculations
  double flareFactor = 0.2;
  double paperES = 1.25;
  double sbr = 7.0;
  double averageG = 0.56;
  double effectiveFilmSpeed = 160.0;
  String idealExposureString = '1/4 sec at f/16';

  // Filter / Bellows Info
  String filterName = 'None';
  String bellowsMode = 'None';
  double magnification = 0.0;
  double bellowsFactor = 1.0;
  int exposureAdjustment = 0;
  String get exposureAdjustmentLabel =>
      exposureAdjustment > 0 ? '+$exposureAdjustment' : '$exposureAdjustment';

  // Focus Info
  String circleOfConfusionLabel = '0.025mm';
  double focusSpread = 18.0;

  // Metering Info
  int incidentEV = 10;
  int highEV = 13;
  int lowEV = 7;
  int lowZone = 3;
  int highZone = 7;
  String meteringNotes = '';
  String meteringMode = 'Incident';

  // Factors Page
  String selectedFilter = 'None';
  String factorsDescription = 'Standard exposure with no additional factors.';

  // DOF Page
  List<int> apertureValues = [4, 5, 5.6.toInt(), 8, 11, 16, 22, 32, 45, 64];
  double subjectDistance = 5.0;
  double nearDistance = 4.0;
  double farDistance = 6.0;
  double focusTravel = 12.0;
  double circleOfConfusion = 0.025;
  double hyperfocalDistance = 6.5;
  DOFMode dofMode = DOFMode.none;

  // Notify helper
  void update(VoidCallback fn) {
    fn();
    notifyListeners();
  }
}
