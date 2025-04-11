
import 'package:flutter/material.dart';

class Session extends ChangeNotifier {
  // Camera Page
  String exposureTitle = '';
  String filmHolder = '';
  String filmStock = '';
  List<String> filmStocks = ['HP5', 'Tri-X', 'FP4'];
  double focalLength = 150;
  List<int> savedFocalLengths = [90, 150, 210, 300];

  // Metering Page
  int lowEV = 5;
  int lowZone = 2;
  int highEV = 12;
  int highZone = 8;
  int incidentEV = 10;
  String meteringMode = 'Lo'; // or 'Hi'

  // DOF Page
  String dofMode = 'None'; // None, Check, Distance, Focus
  bool favorDOF = true; // true = favor DOF, false = favor exposure
  int aperture = 8;
  List<int> apertureValues = [4, 5, 5, 8, 11, 16, 22, 32, 45];
  double subjectDistance = 1;
  double nearDistance = 1;
  double farDistance = 1;
  double focusTravel = 0;

  // Exposure Page
  bool _useApertureMode = true;
  int selectedApertureIndex = 4;
  int selectedMin = 0;
  int selectedSec = 1;
  int selectedFraction = 0;

  List<String> shutterFractions = ['1', '2', '4', '8', '15', '30', '60', '125', '250', '500'];

  bool get useApertureMode => _useApertureMode;
  set useApertureMode(bool value) {
    _useApertureMode = value;
    notifyListeners();
  }

  int get aperture => _aperture;
  set aperture(int value) {
    _aperture = value;
    notifyListeners();
  }

  int _aperture = 8;
}
