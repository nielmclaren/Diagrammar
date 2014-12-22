
class BezierSegment {
  PVector p0, p1;
  PVector c0, c1;

  BezierSegment(
      float startX, float startY,
      float startControlX, float startControlY,
      float endX, float endY,
      float endControlX, float endControlY) {
    p0 = new PVector(startX, startY);
    c0 = new PVector(startControlX, startControlY);
    p1 = new PVector(endX, endY);
    c1 = new PVector(endControlX, endControlY);
  }

  BezierSegment(LineSegment start, LineSegment end) {
    p0 = new PVector(start.p0.x, start.p0.y);
    c0 = new PVector(start.p1.x, start.p1.y);
    p1 = new PVector(end.p0.x, end.p0.y);
    c1 = new PVector(end.p1.x, end.p1.y);
  }

  void draw(PGraphics g) {
    g.bezier(p0.x, p0.y, c0.x, c0.y, p1.x, p1.y, c1.x, c1.y);
  }

  void drawControl(PGraphics g) {
    g.line(p0.x, p0.y, c0.x, c0.y);
    g.line(p1.x, p1.y, c1.x, c1.y);
  }

  PVector getPointOnCurve(float t) {
    return new PVector(
      bezierInterpolation(p0.x, c0.x, p1.x, c1.x, t),
      bezierInterpolation(p0.y, c0.y, p1.y, c1.y, t));
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
}
