// lib/session.dart

import 'package:flutter/material.dart';
import 'dart:math';

class Session {
  // Exposure settings
  bool useApertureMode = true;
  int selectedApertureIndex = 6; // f/8
  int selectedMin = 0;
  int selectedSec = 0;
  int selectedFraction = 0;

  // DOF settings
  double focalLength = 150.0; // mm
  double subjectDistance = 1000.0; // mm
  double circleOfConfusion = 0.03; // mm

  // Metering settings
  String meteringMode = 'Lo';
  double lowEV = 5.0;
  double highEV = 10.0;
  double lowZone = 3.0;
  double highZone = 7.0;


  // Camera settings
  String cameraModel = 'Field';
  String filmHolder = 'Standard';
  String filmStock = 'FP4+';
  double paperES = 1.0;
  double flareFactor = 0.2;

  List<String> get filmStocks => ['FP4+', 'HP5+', 'Tri-X', 'Delta 100'];

  // UI options
  final List<double> apertureValues = [1.4, 2, 2.8, 4, 5.6, 8, 11, 16, 22, 32, 45];
  final List<int> shutterSeconds = List.generate(61, (i) => i); // 0–60 seconds
  final List<int> shutterFractions = [8000, 4000, 2000, 1000, 500, 250, 125, 60, 30, 15, 8, 4, 2];

  double get selectedAperture => apertureValues[selectedApertureIndex];

  double get totalShutterSeconds {
    double sec = selectedSec.toDouble();
    double frac = selectedFraction < shutterFractions.length
        ? 1 / shutterFractions[selectedFraction]
        : 0.0;
    return selectedMin * 60 + sec + frac;
  }

  double calculateEV() {
    final N = selectedAperture;
    final t = totalShutterSeconds;
    if (t <= 0.0) return 0.0;
    return (log(N * N / t) / ln2);
  }
}

final session = Session();
