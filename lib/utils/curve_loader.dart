// mock_curve_loader.dart

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;


class CurveLoader {
  Future<List<double>> loadCurve(String curveName) async {
    try {
      final String data = await rootBundle.loadString('assets/curves/$curveName.json');
      final List<dynamic> jsonResult = json.decode(data);
      return jsonResult.map((e) => (e as num).toDouble()).toList();
    } catch (e) {
      return [];
    }
  }
}

class FilmCurve {
  final String name;
  final List<double> exposureStops; // e.g. [-4.0, -3.5, ..., +4.0]
  final List<double> densities;     // e.g. [0.12, 0.17, ..., 1.25]
  final String developerInfo;
  final double developmentTime;


  FilmCurve({required this.name, required this.exposureStops, required this.densities,required this.developerInfo,
    required this.developmentTime,});

  factory FilmCurve.fromJson(String name, Map<String, dynamic> json) {
    final stops = List<double>.from(json['exposureStops']);
    final densities = List<double>.from(json['densities']);
    return FilmCurve(
      name: name,
      exposureStops: stops,
      densities: densities,
      developerInfo: 'D-76 1+1', // placeholder value
      developmentTime: 8.5,      // placeholder value
    );

  }



  double interpolate(double stop) {
    if (stop <= exposureStops.first) return densities.first;
    if (stop >= exposureStops.last) return densities.last;

    for (int i = 0; i < exposureStops.length - 1; i++) {
      double s0 = exposureStops[i];
      double s1 = exposureStops[i + 1];
      double d0 = densities[i];
      double d1 = densities[i + 1];

      if (stop >= s0 && stop <= s1) {
        double t = (stop - s0) / (s1 - s0);
        return d0 + t * (d1 - d0);
      }
    }

    return densities.last; // fallback
  }
}

Future<FilmCurve> loadFilmCurve(String filmName) async {
  final jsonString = await rootBundle.loadString('assets/curves/$filmName.json');
  final Map<String, dynamic> data = json.decode(jsonString);
  return FilmCurve.fromJson(filmName, data);
}
