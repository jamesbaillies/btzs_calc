class DOFCalculator {
  final double near;
  final double far;
  final double dof;
  final double? aperture; // only used in Focus mode

  DOFCalculator({
    required this.near,
    required this.far,
    required this.dof,
    this.aperture,
  });

  static DOFCalculator fromDistance({
    required double focalLength,
    required double subjectDistance,
    required double aperture,
    required double circleOfConfusion,
  }) {
    final f = focalLength;
    final d = subjectDistance;
    final N = aperture;
    final c = circleOfConfusion;

    final near = (d * f * f) / (f * f + N * c * (d - f));
    final far = (d * f * f) / (f * f - N * c * (d - f));
    final dof = far.isInfinite ? double.infinity : far - near;

    return DOFCalculator(near: near, far: far, dof: dof);
  }

  static DOFCalculator requiredAperture({
    required double focalLength,
    required double subjectDistance,
    required double desiredDOF,
    required double circleOfConfusion,
  }) {
    final f = focalLength;
    final d = subjectDistance;
    final dof = desiredDOF;
    final c = circleOfConfusion;

    // Approximate aperture required
    final N = (f * f * dof) / (2 * c * d * (d - f));

    // Recompute actual DOF based on this aperture
    return fromDistance(
      focalLength: f,
      subjectDistance: d,
      aperture: N,
      circleOfConfusion: c,
    )..aperture;
  }

  static DOFCalculator fromNearFar({
    required double focalLength,
    required double near,
    required double far,
    required double circleOfConfusion,
  }) {
    final f = focalLength;
    final c = circleOfConfusion;

    final d = 2 * near * far / (near + far);
    final N = (f * f * (far - near)) / (c * (near + far) * (d - f));

    return fromDistance(
      focalLength: f,
      subjectDistance: d,
      aperture: N,
      circleOfConfusion: c,
    );
  }
}
