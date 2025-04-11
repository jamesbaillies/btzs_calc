import 'package:flutter/material.dart';

class Session extends ChangeNotifier {
  // Camera Page
  String exposureTitle = '';
  String filmHolder = '';
  String filmStock = 'Ilford HP5';
  double focalLength = 150.0;
  List<String> filmStocks = ['Ilford HP5', 'Kodak Tri-X', 'FP4+', 'T-Max 100'];
  List<double> savedFocalLengths = [90.0, 150.0, 210.0, 300.0];

  // Metering Page
  String meteringMode = 'Lo';
  int lowEV = 6;
  int lowZone = 3;
  int highEV = 12;
  int highZone = 7;
  int incidentEV = 10;

  // DOF Page
  String dofMode = 'None';
  bool favorDOF = true;
  int aperture = 8;
  List<int> apertureValues = [4, 5, 5, 8, 11, 16, 22, 32, 45];
  double subjectDistance = 1.0;
  double nearDistance = 1.0;
  double farDistance = 2.0;
  double focusTravel = 5.0;

  double _circleOfConfusion = 0.03;
  double get circleOfConfusion => _circleOfConfusion;
  set circleOfConfusion(double value) {
    _circleOfConfusion = value;
    notifyListeners();
  }

  // Exposure Page
  bool _useApertureMode = true;
  int selectedApertureIndex = 4; // e.g., f/11
  int selectedMin = 0;
  int selectedSec = 1;
  int selectedFraction = 0;
  List<int> shutterFractions = [1, 2, 4, 8, 15, 30, 60, 125, 250, 500];

  bool get useApertureMode => _useApertureMode;
  set useApertureMode(bool value) {
    _useApertureMode = value;
    notifyListeners();
  }
}
