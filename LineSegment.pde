
class LineSegment { 
  PVector p0, p1;
  
  LineSegment(
      float startX, float startY,
      float endX, float endY) {
    p0 = new PVector(startX, startY);
    p1 = new PVector(endX, endY);
  }
  
  void draw(PGraphics g) {
    g.line(p0.x, p0.y, p1.x, p1.y);
  }

  PVector getPointOnLine(float t) {
    return PVector.add(p0, PVector.mult(PVector.sub(p1, p0), t));
  }
} 
