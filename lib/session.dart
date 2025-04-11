
import 'package:flutter/material.dart';

class Session extends ChangeNotifier {
  // Camera Page
  String exposureTitle = '';
  String filmHolder = '';
  String filmStock = '';
  List<String> filmStocks = ['HP5+', 'Tri-X', 'Portra 400'];

  double focalLength = 210.0;
  List<double> savedFocalLengths = [90.0, 150.0, 210.0, 300.0, 360.0];

  // DOF Page
  String dofMode = 'None';
  bool favorDOF = false;
  double focusTravel = 0.0;
  double nearDistance = 1.0;
  double farDistance = 1.0;
  double subjectDistance = 1.0;
  double circleOfConfusion = 0.05;

  int aperture = 8;
  List<int> apertureValues = [4, 5, 5, 8, 11, 16, 22, 32, 45, 64, 90];
  set apertureValue(int value) {
    aperture = value;
    notifyListeners();
  }

  // Metering Page
  String meteringMode = 'Incident';
  String meteringNotes = '';

  double incidentLoEV = 0.0;
  double incidentHiEV = 0.0;

  double lowEV = 0.0;
  double highEV = 0.0;
  int lowZone = 2;
  int highZone = 8;

  // Exposure Page
  bool useApertureMode = true;
  int selectedApertureIndex = 4;

  int selectedMin = 0;
  int selectedSec = 0;
  int selectedFraction = 3;

  List<int> shutterFractions = [1, 2, 4, 8, 15, 30, 60, 125, 250, 500];

  void reset() {
    exposureTitle = '';
    filmHolder = '';
    filmStock = '';
    focalLength = 210.0;
    meteringNotes = '';
    notifyListeners();
  }
}
