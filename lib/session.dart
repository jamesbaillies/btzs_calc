import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'; // for debugPrint


enum DOFMode { none, check, distance, focus }

class Session extends ChangeNotifier {
  // --- Fields ---
  String exposureTitle = '';
  int iso = 100;
  double aperture = 8.0;
  double focalLength = 210.0;
  List<String> filmStocks = ['HP5+', 'Tri-X', 'FP4+', 'T-Max 100'];
  String filmStock = 'HP5+';
  String filmHolder = '';
  int selectedMin = 0;
  int selectedSec = 1;
  int selectedFraction = 0;
  double flareFactor = 0.2;
  double paperES = 1.25;
  double sbr = 7.0;
  double averageG = 0.56;
  double effectiveFilmSpeed = 160.0;
  String idealExposureString = '1/4 sec at f/16';
  String filterName = 'None';
  String bellowsMode = 'None';
  double magnification = 0.0;
  double bellowsFactor = 1.0;
  String exposureAdjustment = '0';
  String circleOfConfusionLabel = '0.025mm';
  double focusSpread = 18.0;
  int incidentEV = 10;
  double highEV = 13.0;
  double lowEV = 7.0;
  int lowZone = 3;
  int highZone = 7;
  String meteringNotes = '';
  String meteringMode = 'Incident';
  String selectedFilter = 'None';
  String factorsDescription = 'Standard exposure with no additional factors.';
  List<double> apertureValues = [4, 5.6, 8, 11, 16, 22, 32, 45, 64];
  double subjectDistance = 5.0;
  double nearDistance = 4.0;
  double farDistance = 6.0;
  double focusTravel = 12.0;
  double circleOfConfusion = 0.025;
  double hyperfocalDistance = 6.5;
  DOFMode dofMode = DOFMode.none;
  bool useApertureMode = true;
  double contrast = 0.9;
  Map<String, dynamic> loadedFilmCurves = {};
  String developerInfo = 'D-76 1+1';
  double developmentTime = 8.5;

  // --- Computed ---
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

  String get exposureAdjustmentLabel =>
      exposureAdjustment.startsWith('-') || exposureAdjustment == '0'
          ? exposureAdjustment
          : '+$exposureAdjustment';

  // --- JSON ---
  Map<String, dynamic> toJson() => {
    'exposureTitle': exposureTitle,
    'filmHolder': filmHolder,
    'filmStock': filmStock,
    'focalLength': focalLength,
    'developerInfo': developerInfo,
    'developmentTime': developmentTime,
  };

  static Session fromJson(Map<String, dynamic> json) {
    try {
      return Session()
        ..exposureTitle = json['exposureTitle'] as String? ?? ''
        ..filmHolder = json['filmHolder'] as String? ?? ''
        ..filmStock = json['filmStock'] as String? ?? 'HP5+'
        ..focalLength = _parseDouble(json['focalLength'], fallback: 210.0)
        ..developerInfo = json['developerInfo'] as String? ?? 'D-76 1+1'
        ..developmentTime = _parseDouble(json['developmentTime'], fallback: 8.0);
    } catch (e) {
      debugPrint('Error loading session: $e');
      return Session();
    }
  }

  static double _parseDouble(dynamic val, {required double fallback}) {
    if (val is num) return val.toDouble();
    if (val is String) return double.tryParse(val) ?? fallback;
    return fallback;
  }

  void update(VoidCallback fn) {
    fn();
    notifyListeners();
  }
}
