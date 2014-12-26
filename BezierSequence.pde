
class BezierSequence {
  IVectorFunction seedLine0, seedLine1;
  IVectorFunction controlLine0, controlLine1;
  float minTime0, maxTime0, minTime1, maxTime1;

  int numSegments;

  BezierSequence(
      int _numSegments,
      IVectorFunction _seedLine0,
      IVectorFunction _controlLine0,
      IVectorFunction _controlLine1,
      IVectorFunction _seedLine1) {
    numSegments = _numSegments;
    seedLine0 = _seedLine0;
    seedLine1 = _seedLine1;
    controlLine0 = _controlLine0;
    controlLine1 = _controlLine1;

    minTime0 = minTime1 = 0;
    maxTime0 = maxTime1 = 1;
  }

  BezierSequence(
      int _numSegments,
      IVectorFunction _seedLine0,
      IVectorFunction _controlLine0,
      IVectorFunction _controlLine1,
      IVectorFunction _seedLine1,
      float _minTime,
      float _maxTime) {
    numSegments = _numSegments;
    seedLine0 = _seedLine0;
    seedLine1 = _seedLine1;
    controlLine0 = _controlLine0;
    controlLine1 = _controlLine1;

    minTime0 = minTime1 = _minTime;
    maxTime0 = maxTime1 = _maxTime;
  }

  BezierSequence(
      int _numSegments,
      IVectorFunction _seedLine0,
      IVectorFunction _controlLine0,
      IVectorFunction _controlLine1,
      IVectorFunction _seedLine1,
      float _minTime0,
      float _maxTime0,
      float _minTime1,
      float _maxTime1) {
    numSegments = _numSegments;
    seedLine0 = _seedLine0;
    seedLine1 = _seedLine1;
    controlLine0 = _controlLine0;
    controlLine1 = _controlLine1;

    minTime0 = _minTime0;
    maxTime0 = _maxTime0;
    minTime1 = _minTime1;
    maxTime1 = _maxTime1;
  }

  void draw(PGraphics g) {
    float t0, t1;
    PVector m0, m1, cm0, cm1;
    for (int i = 0; i < numSegments; i++) {
      t0 = map((float)i / (numSegments - 1), 0, 1, minTime0, maxTime0);
      t1 = map((float)i / (numSegments - 1), 0, 1, minTime1, maxTime1);
      m0 = seedLine0.getPoint(t0);
      m1 = seedLine1.getPoint(t1);

      cm0 = controlLine0.getPoint(t0);
      cm1 = controlLine1.getPoint(t1);

      bezier(m0.x, m0.y, cm0.x, cm0.y,
        cm1.x, cm1.y, m1.x, m1.y);
    }
  }

  BezierSegment getBezierSegment(int i) {
    float t0, t1;
    PVector m0, m1, cm0, cm1;
    t0 = map((float)i / (numSegments - 1), 0, 1, minTime0, maxTime0);
    t1 = map((float)i / (numSegments - 1), 0, 1, minTime1, maxTime1);

    m0 = seedLine0.getPoint(t0);
    m1 = seedLine1.getPoint(t1);

    cm0 = controlLine0.getPoint(t0);
    cm1 = controlLine1.getPoint(t1);

    return new BezierSegment(
        m0.x, m0.y, cm0.x, cm0.y,
        cm1.x, cm1.y, m1.x, m1.y);
  }
}
