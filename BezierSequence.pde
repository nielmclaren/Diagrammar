
class BezierSequence {
  float minTime0, maxTime0, minTime1, maxTime1;
  int numCurves;

  ArrayList<IVectorFunction> controls;

  BezierSequence(int _numCurves) {
    numCurves = _numCurves;

    controls = new ArrayList<IVectorFunction>();

    minTime0 = minTime1 = 0;
    maxTime0 = maxTime1 = 1;
  }

  BezierSequence(
      int _numCurves,
      float _minTime,
      float _maxTime) {
    numCurves = _numCurves;

    controls = new ArrayList<IVectorFunction>();

    minTime0 = minTime1 = _minTime;
    maxTime0 = maxTime1 = _maxTime;
  }

  BezierSequence(
      int _numCurves,
      float _minTime0,
      float _maxTime0,
      float _minTime1,
      float _maxTime1) {
    numCurves = _numCurves;

    controls = new ArrayList<IVectorFunction>();

    minTime0 = _minTime0;
    maxTime0 = _maxTime0;
    minTime1 = _minTime1;
    maxTime1 = _maxTime1;
  }

  void draw(PGraphics g) {
    float t0, t1;
    PVector m0, m1, cm0, cm1;
    for (int i = 0; i < numCurves; i++) {
      t0 = map((float)i / (numCurves - 1), 0, 1, minTime0, maxTime0);
      t1 = map((float)i / (numCurves - 1), 0, 1, minTime1, maxTime1);
      drawCurve(g, t0, t1);
    }
  }

  void drawControls(PGraphics g) {
    for (int i = 0; i < controls.size(); i++) {
      controls.get(i).draw(g);
    }
  }

  private void drawCurve(PGraphics g, float t0, float t1) {
    for (int i = 3; i < controls.size(); i += 2) {
      PVector m0 = controls.get(i-3).getPoint(t0);
      PVector c0 = controls.get(i-2).getPoint(t0);
      PVector c1 = controls.get(i-1).getPoint(t1);
      PVector m1 = controls.get(i).getPoint(t1);

      if (i == 3) {
        g.bezier(
          m0.x, m0.y, c0.x, c0.y,
          c1.x, c1.y, m1.x, m1.y);
      }
      else {
        g.bezier(
          c0.x, c0.y, 2 * c0.x - m0.x, 2 * c0.y - m0.y,
          c1.x, c1.y, m1.x, m1.y);
      }
    }
  }

  void addControl(IVectorFunction control) {
    controls.add(control);
  }

  BezierCurve getCurve(int index) {
    float t0, t1;
    t0 = map((float)index / (numCurves - 1), 0, 1, minTime0, maxTime0);
    t1 = map((float)index / (numCurves - 1), 0, 1, minTime1, maxTime1);

    BezierCurve c = new BezierCurve();
    for (int i = 1; i < controls.size(); i += 2) {
      c.addControl(new LineSegment(
        controls.get(i - 1).getPoint(t0),
        controls.get(i).getPoint(t1)));
    }

    return c;
  }

  int getNumCurves() {
    return controls.size() - 1;
  }
}
