// session.dart

class SessionData {
  static final SessionData _instance = SessionData._internal();
  factory SessionData() => _instance;
  SessionData._internal();

  // Camera page
  String cameraModel = '4x5 View';
  String filmHolder = 'Fidelity Elite';
  String filmStock = 'FP4+';
  double flareFactor = 0.3;
  double paperES = 1.2;

  // Exposure page
  bool useApertureMode = true;
  int selectedApertureIndex = 6;
  int selectedMin = 0;
  int selectedSec = 0;
  int selectedFraction = 5;

  // Metering page
  double lowEV = 7.0;
  double lowZone = 3.0;
  double highEV = 12.0;
  double highZone = 8.0;
  String meteringNotes = '';
  String meteringMode = 'Zone';
  String selectedFilter = 'None';
  String bellowsMode = 'None';
  String exposureAdjustment = 'None';

  // DOF page
  int focalLength = 210;
  double subjectDistance = 2000;
  double circleOfConfusion = 0.03;
  bool favorDOF = false;

  // Curves and development times
  final List<Map<String, dynamic>> curves = [
    {"label": "N-1", "DR": 0.9, "devTime": 5.5},
    {"label": "N",   "DR": 1.1, "devTime": 7.0},
    {"label": "N+1", "DR": 1.3, "devTime": 9.0},
  ];

  int selectedCurveIndex = 1; // default to "N"
}

final session = SessionData();
