import 'package:flutter/material.dart';

class Session extends ChangeNotifier {
  // Camera Page
  String exposureTitle = '';
  String filmHolder = '';
  List<String> filmStocks = ['HP5+', 'Tri-X', 'FP4', 'Delta 100'];
  String filmStock = 'HP5+';
  double focalLength = 150.0;
  List<int> savedFocalLengths = [90, 150, 210, 300];

  // Metering Page
  int meteringMode = 0; // 0 = Incident, 1 = Zone
  int incidentEV = 10;
  int lowEV = 5;
  int lowZone = 2;
  int highEV = 15;
  int highZone = 8;

  // DOF Page
  String dofMode = 'None'; // None, Check, Distance, Focus
  bool favorDOF = true;
  double focusNear = 1000.0;
  double focusFar = 2000.0;
  double nearDistance = 1.0; // in meters
  double farDistance = 2.0; // in meters
  double focusTravel = 5.0; // in mm
  double subjectDistance = 1.0;
  double circleOfConfusion = 0.03;

  // Aperture
  List<int> apertureValues = [4, 5, 5, 6, 7, 8, 9, 11, 13, 14, 16, 18, 20, 22, 25, 28, 32, 36, 40, 45];
  int _aperture = 8;
  int get aperture => _aperture;
  set aperture(int value) {
    _aperture = value;
    notifyListeners();
  }

  // Exposure Page
  bool _useApertureMode = true;
  bool get useApertureMode => _useApertureMode;
  set useApertureMode(bool value) {
    _useApertureMode = value;
    notifyListeners();
  }

  int selectedApertureIndex = 5; // default: f/8
  int selectedMin = 0;
  int selectedSec = 1;
  int selectedFraction = 0;

  List<int> shutterFractions = [1, 2, 4, 8, 15, 30, 60, 125, 250, 500, 1000];
}
