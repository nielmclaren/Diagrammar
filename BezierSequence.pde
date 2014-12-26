
class BezierSequence {
  float minTime0, maxTime0, minTime1, maxTime1;
  int numSegments;

  ArrayList<IVectorFunction> controls;

  BezierSequence(int _numSegments) {
    numSegments = _numSegments;

    controls = new ArrayList<IVectorFunction>();

    minTime0 = minTime1 = 0;
    maxTime0 = maxTime1 = 1;
  }

  BezierSequence(
      int _numSegments,
      float _minTime,
      float _maxTime) {
    numSegments = _numSegments;

    controls = new ArrayList<IVectorFunction>();

    minTime0 = minTime1 = _minTime;
    maxTime0 = maxTime1 = _maxTime;
  }

  BezierSequence(
      int _numSegments,
      float _minTime0,
      float _maxTime0,
      float _minTime1,
      float _maxTime1) {
    numSegments = _numSegments;

    controls = new ArrayList<IVectorFunction>();

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
      drawSegment(t0, t1);
    }
  }

  private void drawSegment(float t0, float t1) {
    for (int i = 3; i < controls.size(); i += 4) {
      PVector m0 = controls.get(i-3).getPoint(t0);
      PVector m1 = controls.get(i-2).getPoint(t1);

      PVector cm0 = controls.get(i-1).getPoint(t0);
      PVector cm1 = controls.get(i).getPoint(t1);

      bezier(m0.x, m0.y, cm0.x, cm0.y,
        cm1.x, cm1.y, m1.x, m1.y);
    }
  }

  void addControl(IVectorFunction control) {
    controls.add(control);
  }

  BezierCurve getBezierCurve(int index) {
    float t0, t1;
    t0 = map((float)index / (numSegments - 1), 0, 1, minTime0, maxTime0);
    t1 = map((float)index / (numSegments - 1), 0, 1, minTime1, maxTime1);

    BezierCurve c = new BezierCurve();
    for (int i = 1; i < controls.size(); i += 2) {
      c.addControl(new LineSegment(controls.get(i - 1).getPoint(t0), controls.get(i).getPoint(t1)));
    }

    return c;
  }
}
