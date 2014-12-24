
class BezierSequence {
  // FIXME: Allow line segments as controls, too. Need to make getPointOn interface.
  BezierSegment seedLine0, seedLine1;
  BezierSegment controlLine0, controlLine1;
  float minTime0, maxTime0, minTime1, maxTime1;

  int numSegments;

  BezierSequence(
      int _numSegments,
      BezierSegment _seedLine0,
      BezierSegment _controlLine0,
      BezierSegment _controlLine1,
      BezierSegment _seedLine1) {
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
      BezierSegment _seedLine0,
      BezierSegment _controlLine0,
      BezierSegment _controlLine1,
      BezierSegment _seedLine1,
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
      BezierSegment _seedLine0,
      BezierSegment _controlLine0,
      BezierSegment _controlLine1,
      BezierSegment _seedLine1,
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
      m0 = seedLine0.getPointOnCurve(t0);
      m1 = seedLine1.getPointOnCurve(t1);

      cm0 = controlLine0.getPointOnCurve(t0);
      cm1 = controlLine1.getPointOnCurve(t1);

      bezier(m0.x, m0.y, cm0.x, cm0.y,
        cm1.x, cm1.y, m1.x, m1.y);
    }
  }

  void drawControls(PGraphics g) {
    seedLine0.draw(g);
    seedLine1.draw(g);

    seedLine0.drawControls(g);
    seedLine1.drawControls(g);

    controlLine0.draw(g);
    controlLine1.draw(g);

    controlLine0.drawControls(g);
    controlLine1.drawControls(g);
  }
}
