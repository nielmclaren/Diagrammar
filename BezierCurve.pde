
class BezierCurve {
  ArrayList<LineSegment> controls;

  BezierCurve() {
    controls = new ArrayList<LineSegment>();
  }

  void draw(PGraphics g) {
    LineSegment line0, line1;
    for (int i = 0; i < controls.size() - 1; i++) {
      line0 = controls.get(i);
      line1 = controls.get(i + 1);

      if (i == 0) {
        g.bezier(
          line0.p0.x, line0.p0.y, line0.p1.x, line0.p1.y,
          line1.p0.x, line1.p0.y, line1.p1.x, line1.p1.y);
      }
      else {
        g.bezier(
          line0.p1.x, line0.p1.y, 2 * line0.p1.x - line0.p0.x, 2 * line0.p1.y - line0.p0.y,
          line1.p0.x, line1.p0.y, line1.p1.x, line1.p1.y);
      }
    }
  }

  int numSegments() {
    return controls.size() - 1;
  }

  void addControl(LineSegment control) {
    controls.add(control);
    recalculateStuff();
  }

  void drawControls(PGraphics g) {
    LineSegment line;
    for (int i = 0; i < controls.size(); i++) {
      line = controls.get(i);
      g.line(line.p0.x, line.p0.y, line.p1.x, line.p1.y);

      if (i > 0 && i < controls.size() - 1) {
        g.line(line.p1.x, line.p1.y, 2 * line.p1.x - line.p0.x, 2 * line.p1.y - line.p0.y);
      }
    }
  }

  PVector getPointOnCurve(float t) {
    if (controls.size() < 2) return null;

    // FIXME: Naïve implementation. Should be based on lengths of curves.
    int len = controls.size() - 1;
    int index = floor(t * len);
    float u = (t * len - index);
    LineSegment line0 = controls.get(index);
    LineSegment line1 = controls.get(index + 1);
    if (index == 0) {
      return new PVector(
        bezierInterpolation(line0.p0.x, line0.p1.x, line1.p0.x, line1.p1.x, u),
        bezierInterpolation(line0.p0.y, line0.p1.y, line1.p0.y, line1.p1.y, u));
    }
    else {
      return new PVector(
        bezierInterpolation(line0.p1.x, 2 * line0.p1.x - line0.p0.x, line1.p0.x, line1.p1.x, u),
        bezierInterpolation(line0.p1.y, 2 * line0.p1.y - line0.p0.y, line1.p0.y, line1.p1.y, u));
    }
  }

  /**
   * @see http://stackoverflow.com/a/4060392
   * @author michal@michalbencur.com
   */
  private float bezierInterpolation(float a, float b, float c, float d, float t) {
    float t2 = t * t;
    float t3 = t2 * t;
    return a + (-a * 3 + t * (3 * a - a * t)) * t
    + (3 * b + t * (-6 * b + b * 3 * t)) * t
    + (c * 3 - c * 3 * t) * t2
    + d * t3;
  }

  private PVector getPointOnCurveNaive(float t) {
    if (controls.size() < 2) return null;

    int len = controls.size() - 1;
    int index = floor(t * len);
    float u = (t * len - index);
    LineSegment line0 = controls.get(index);
    LineSegment line1 = controls.get(index + 1);
    if (index == 0) {
      return new PVector(
        bezierInterpolation(line0.p0.x, line0.p1.x, line1.p0.x, line1.p1.x, u),
        bezierInterpolation(line0.p0.y, line0.p1.y, line1.p0.y, line1.p1.y, u));
    }
    else {
      return new PVector(
        bezierInterpolation(line0.p1.x, 2 * line0.p1.x - line0.p0.x, line1.p0.x, line1.p1.x, u),
        bezierInterpolation(line0.p1.y, 2 * line0.p1.y - line0.p0.y, line1.p0.y, line1.p1.y, u));
    }
  }
  
  private void recalculateStuff() {
  }
}
