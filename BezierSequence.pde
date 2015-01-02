
class BezierSequence {
  int numCurves;

  ArrayList<IVectorFunction> controls;
  ArrayList<BezierCurve> curves;

  BezierSequence(int _numCurves) {
    numCurves = _numCurves;

    controls = new ArrayList<IVectorFunction>();
    curves = new ArrayList<BezierCurve>();
  }

  void draw(PGraphics g) {
    float ct;
    for (int i = 0; i < numCurves; i++) {
      curves.get(i).draw(g);
    }
  }

  void draw(PGraphics g, float t0, float t1) {
    float ct;
    for (int i = 0; i < numCurves; i++) {
      curves.get(i).draw(g, t0, t1);
    }
  }

  void drawControls(PGraphics g) {
    for (int i = 0; i < controls.size(); i++) {
      controls.get(i).draw(g);
    }
  }

  void addControl(IVectorFunction control) {
    controls.add(control);
    recalculate();
  }

  BezierCurve getCurve(int index) {
    return curves.get(index);
  }

  int getNumCurves() {
    return numCurves;
  }

  private void recalculate() {
    curves = new ArrayList<BezierCurve>();
    for (int i = 0; i < numCurves; i++) {
      BezierCurve bc = new BezierCurve();
      float t = (float)i / (numCurves - 1);
      for (int j = 1; j < controls.size(); j += 2) {
        PVector p0 = controls.get(j-1).getPoint(t);
        PVector p1 = controls.get(j).getPoint(t);

        bc.addControl(new LineSegment(p0, p1));
      }
      curves.add(bc);
    }
  }
}
