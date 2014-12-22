
class BezierCurve {
  int POLYLINE_POINTS_PER_CONTROL = 100;

  ArrayList<LineSegment> controls;

  int numPolylinePoints;
  float polylineLength;
  float[] polylineTimes;
  float[] polylineLengths;


  BezierCurve() {
    controls = new ArrayList<LineSegment>();

    numPolylinePoints = 0;
    polylineLength = 0;
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

  BezierSegment getSegment(int i) {
    if (i < 0 || i + 1 >= controls.size()) return null;
    return new BezierSegment(controls.get(i), controls.get(i + 1));
  }

  void addControl(LineSegment control) {
    controls.add(control);
    recalculate();
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

  float getLength() {
    if (controls.size() < 2) return 0;

    // FIXME: Use uniform arc-distance points for better accuracy.
    return polylineLength;
  }

  PVector getPointOnCurve(float t) {
    if (controls.size() < 2) return null;
    if (t <= 0) return controls.get(0).p0.get();
    if (t >= 1) return controls.get(controls.size() - 1).p1.get();

    float polylineDistance = 0;
    for (int i = 0; i < numPolylinePoints - 1; i++) {
      if (t * polylineLength < polylineDistance + polylineLengths[i]) {
        float k = (t * polylineLength - polylineDistance) / polylineLengths[i];
        float u = polylineTimes[i] + k * (polylineTimes[i + 1] - polylineTimes[i]);

        return getPointOnCurveNaive(u);
      }
      polylineDistance += polylineLengths[i];
    }

    return null;
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

  private int getPointOnCurveNaiveIndex(float t) {
    if (controls.size() < 1) return -1;
    int len = controls.size() - 1;
    int index = floor(t * len);
    return index;
  }

  private PVector getPointOnCurveNaive(float t) {
    if (controls.size() < 2) return null;
    if (t <= 0) return controls.get(0).p0.get();
    if (t >= 1.0) return controls.get(controls.size() - 1).p1.get();

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

  private void recalculate() {
    if (controls.size() < 2) return;

    numPolylinePoints = controls.size() * POLYLINE_POINTS_PER_CONTROL;
    PVector[] polylinePoints = new PVector[numPolylinePoints];
    int[] polylineControlIndices = new int[numPolylinePoints];
    polylineTimes = new float[numPolylinePoints];
    polylineLengths = new float[numPolylinePoints - 1];
    polylineLength = 0;
    float polylineDistance = 0;

    for (int i = 0; i < numPolylinePoints; i++) {
      polylineTimes[i] = (float)i / (numPolylinePoints - 1);
      polylinePoints[i] = getPointOnCurveNaive(polylineTimes[i]);
      polylineControlIndices[i] = getPointOnCurveNaiveIndex(polylineTimes[i]);

      if (i > 0) {
        PVector d = polylinePoints[i].get();
        d.sub(polylinePoints[i - 1]);
        polylineLengths[i - 1] = d.mag();
        polylineLength += d.mag();
        polylineDistance += polylineLength;
      }
      else {
        polylineLengths[i] = 0;
      }
    }
  }
}
