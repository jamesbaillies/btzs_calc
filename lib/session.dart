import 'package:flutter/material.dart';
import 'dart:math';

class Session {
  // Exposure & Camera Info
  String exposureTitle = '';
  String filmHolder = '';
  String filmStock = 'HP5+';
  List<String> filmStocks = ['HP5+', 'FP4+', 'Portra 400', 'Ektar', 'Tri-X'];
  double paperES = 1.05;
  double flareFactor = 0.25;
  String cameraModel = '4x5';

  // Metering
  String meteringMode = 'Lo';
  int lowEV = 7;
  int highEV = 14;
  int lowZone = 2;
  int highZone = 8;

  // Focal Lengths
  double focalLength = 210;
  List<int> savedFocalLengths = [90, 150, 210, 300, 360];

  // DOF
  double subjectDistance = 1500; // mm
  double circleOfConfusion = 0.03;

  // Exposure
  bool useApertureMode = true;
  int selectedApertureIndex = 6;
  int selectedMin = 0;
  int selectedSec = 0;
  int selectedFraction = 6;

  List<double> apertureValues = [1.4, 2, 2.8, 4, 5.6, 8, 11, 16, 22, 32, 45, 64];
  List<int> shutterFractions = [2, 4, 8, 15, 30, 60, 125, 250, 500];

  double get selectedAperture => apertureValues[selectedApertureIndex];

  double get totalShutterSeconds {
    double sec = selectedMin * 60 + selectedSec.toDouble();
    if (selectedFraction < shutterFractions.length) {
      sec += 1 / shutterFractions[selectedFraction];
    }
    return sec;
  }

  double calculateEV() {
    final N = selectedAperture;
    final t = totalShutterSeconds;
    return log(N * N / t) / ln2;
  }
}