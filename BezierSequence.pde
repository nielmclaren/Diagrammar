
class BezierSequence {
  // FIXME: Allow line segments as controls, too. Need to make getPointOn interface.
  BezierSegment seedLine0, seedLine1;
  BezierSegment controlLine0, controlLine1;

  int numSegments;

  BezierSequence(
      int _numSegments,
      BezierSegment _seedLine0,
      BezierSegment _seedLine1,
      BezierSegment _controlLine0,
      BezierSegment _controlLine1) {
    numSegments = _numSegments;
    seedLine0 = _seedLine0;
    seedLine1 = _seedLine1;
    controlLine0 = _controlLine0;
    controlLine1 = _controlLine1;
  }

  void draw(PGraphics g) {
    float t;
    PVector m0, m1, cm0, cm1;
    for (int i = 0; i < numSegments; i++) {
      t = (float)i / (numSegments - 1);
      m0 = seedLine0.getPointOnCurve(t);
      m1 = seedLine1.getPointOnCurve(t);

      cm0 = controlLine0.getPointOnCurve(t);
      cm1 = controlLine1.getPointOnCurve(t);

      bezier(m0.x, m0.y, cm0.x, cm0.y,
        cm1.x, cm1.y, m1.x, m1.y);
    }
  }

  void drawControls(PGraphics g) {
    seedLine0.draw(g);
    seedLine1.draw(g);

    seedLine0.drawControl(g);
    seedLine1.drawControl(g);

    controlLine0.draw(g);
    controlLine1.draw(g);

    controlLine0.drawControl(g);
    controlLine1.drawControl(g);
  }
}
