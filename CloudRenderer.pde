
import java.util.Collections;
import megamu.mesh.*;

class CloudRenderer {
  PVector _position;
  ArrayList<Puff> _puffs;
  String _style;
  int _numPuffs;
  float _minRadius, _maxRadius;
  float _innerRadiusFactor;

  CloudRenderer(float x, float y) {
    init(x, y, "cartoon", 10, 40, 80, 0.8);
  }

  CloudRenderer(float x, float y, String style, int numPuffs, float minRadius, float maxRadius) {
    init(x, y, "cartoon", numPuffs, minRadius, maxRadius, 0.8);
  }

  CloudRenderer(float x, float y, String style, int numPuffs, float minRadius, float maxRadius, float innerRadiusFactor) {
    init(x, y, "cartoon", numPuffs, minRadius, maxRadius, innerRadiusFactor);
  }

  void draw(PGraphics g) {
    PVector offset = _position.get();
    offset.sub(getBoundsCenter());

    g.fill(255);
    g.stroke(0);
    g.strokeWeight(2);
    for (Puff puff : _puffs) {
      g.ellipse(offset.x + puff.x, offset.y + puff.y, 2*puff.r, 2*puff.r);
    }

    g.fill(255);
    g.noStroke();
    for (Puff puff : _puffs) {
      g.ellipse(offset.x + puff.x, offset.y + puff.y, 2*puff.r*_innerRadiusFactor, 2*puff.r*_innerRadiusFactor);
    }
  }

  float[][] getBounds() {
    float[][] bounds = new float[2][2];
    bounds[0][0] = Float.MAX_VALUE;
    bounds[1][0] = -Float.MAX_VALUE;
    bounds[0][1] = Float.MAX_VALUE;
    bounds[1][1] = -Float.MAX_VALUE;

    for (Puff puff : _puffs) {
      if (puff.x < bounds[0][0]) bounds[0][0] = puff.x;
      if (puff.x > bounds[1][0]) bounds[1][0] = puff.x;
      if (puff.y < bounds[0][1]) bounds[0][1] = puff.y;
      if (puff.y > bounds[1][1]) bounds[1][1] = puff.y;
    }

    return bounds;
  }

  PVector getBoundsCenter() {
    float minX = Float.MAX_VALUE;
    float maxX = -Float.MAX_VALUE;
    float minY = Float.MAX_VALUE;
    float maxY = -Float.MAX_VALUE;

    for (Puff puff : _puffs) {
      if (puff.x < minX) minX = puff.x;
      if (puff.x > maxX) maxX = puff.x;
      if (puff.y < minY) minY = puff.y;
      if (puff.y > maxY) maxY = puff.y;
    }

    return new PVector(minX + (maxX - minX)/2, minY + (maxY - minY)/2);
  }

  private void init(
      float posX,
      float posY,
      String style,
      int numPuffs,
      float minRadius,
      float maxRadius,
      float innerRadiusFactor) {
    _position = new PVector(posX, posY);
    _style = style; // "cartoon" or "concentrics"
    _numPuffs = numPuffs;
    _minRadius = minRadius;
    _maxRadius = maxRadius;
    _innerRadiusFactor = innerRadiusFactor;

    float r = map(random(1), 0, 1, _minRadius, _maxRadius),
      r2 = map(random(1), 0, 1, _minRadius, _maxRadius);
    PVector d = new PVector(r, 0);
    d.rotate(2 * PI * random(1));
    Puff puff0 = new Puff(0, 0, r),
         puff1 = new Puff(d.x, d.y, r2);
    _puffs = new ArrayList<Puff>();
    _puffs.add(puff0);
    _puffs.add(puff1);

    for (int i = 0; i < numPuffs; i++) {
      addPuff();
    }
  }

  private float[][] getPuffPoints() {
    int numPuffs = _puffs.size();
    float[][] points = new float[numPuffs][2];
    for (int i = 0; i < numPuffs; i++) {
      Puff puff = _puffs.get(i);
      points[i][0] = puff.x;
      points[i][1] = puff.y;
    }
    return points;
  }

  private PVector getCentroid() {
    int numPuffs = _puffs.size();
    PVector centroid = new PVector();
    for (int i = 0; i < numPuffs; i++) {
      Puff puff = _puffs.get(i);
      centroid.x += puff.x;
      centroid.y += puff.y;
    }
    centroid.mult(1.0 / numPuffs);
    return centroid;
  }

  private int[] getExtremaPuffIndices(float[][] points) {
    return (new Hull(points)).getExtrema();
  }

  private Puff[] getLongestHullSegmentPuffs(int[] extrema) {
    float[][] points = getPuffPoints();
    int candidateIndex = -1;
    Puff puff0, puff1;
    float dx, dy, distSq, candidateDistSq = 0;
    int numExtrema = extrema.length;
    for (int i = 0; i < numExtrema; i++) {
      puff0 = _puffs.get(extrema[i]);
      puff1 = _puffs.get(extrema[(i + 1) % numExtrema]);
      dx = puff1.x - puff0.x;
      dy = puff1.y - puff0.y;
      distSq = dx * dx + dy * dy;
      if (distSq > candidateDistSq) {
        candidateDistSq = distSq;
        candidateIndex = i;
      }
    }

    if (candidateIndex >= 0) {
      Puff[] result = new Puff[2];
      result[0] = _puffs.get(extrema[candidateIndex]);
      result[1] = _puffs.get(extrema[(candidateIndex + 1) % numExtrema]);
      return result;
    }
    return null;
  }

  private void addPuff() {
    Puff puff0, puff1;
    PVector p;
    float dx, dy, distSq, sumRadiusSq;

    float[][] points = getPuffPoints();
    int[] extrema = getExtremaPuffIndices(points);
    Puff[] puffs = getLongestHullSegmentPuffs(extrema);

    if (extrema.length > 0) {
      puff0 = puffs[0];
      puff1 = puffs[1];

      dx = puff1.x - puff0.x;
      dy = puff1.y - puff0.y;
      distSq = dx * dx + dy * dy;
      sumRadiusSq = puff0.r + puff1.r;
      sumRadiusSq = sumRadiusSq * sumRadiusSq;

      if (distSq > sumRadiusSq) {
        p = getPointForNonOverlapping(puffs[0], puffs[1]);
      }
      else {
        p = getPointForOverlapping(puffs[0], puffs[1]);
      }

      float r = map(random(1), 0, 1, _minRadius, _maxRadius);
      _puffs.add(new Puff(p.x, p.y, r));
    }
  }

  private PVector getPointForNonOverlapping(Puff puff0, Puff puff1) {
    float dx = puff1.x - puff0.x,
      dy = puff1.y - puff0.y;
    PVector centroid = getCentroid();
    PVector p = new PVector(puff0.x + (puff1.x - puff0.x)/2, puff0.y + (puff1.y - puff0.y)/2);
    PVector p0 = p.get();
    p0.add(-dy*0.25, dx*0.25, 0);
    PVector p1 = p.get();
    p1.add(dy*0.25, -dx*0.25, 0);

    if (PVector.sub(p1, centroid).mag() > PVector.sub(p0, centroid).mag()) {
      return p1;
    }
    else {
      return p0;
    }
  }

  private PVector getPointForOverlapping(Puff puff0, Puff puff1) {
    PVector centroid = getCentroid();
    PVector[] intersections = intersect(puff0.x, puff0.y, puff0.r, puff1.x, puff1.y, puff1.r);
    if (intersections.length >= 2) {
      if (PVector.sub(intersections[0], centroid).mag() > PVector.sub(intersections[1], centroid).mag()) {
        return intersections[0];
      }
      else {
        return intersections[1];
      }
    }
    else if (intersections.length >= 1) {
      return intersections[0];
    }
    else {
      println("Zero intersections.");
      return new PVector(puff0.x + (puff1.x - puff0.x)/2, puff0.y + (puff1.y - puff0.y)/2);
    }
  }

  /**
   * @author SAMARAS
   * @see https://gsamaras.wordpress.com/code/determine-where-two-circles-intersect-c/
   */
  PVector[] intersect(float x1, float y1, float r1, float x2, float y2, float r2) {
    float dx = x2 - x1;
    float dy = y2 - y1;
    float d = sqrt(dx*dx + dy*dy);

    // find number of solutions
    if (d > r1 + r2) {
      // circles are too far apart, no solution(s)
      println("Circles are too far apart");
      return new PVector[0];
    }
    else if (d == 0 && r1 == r2) {
      // circles coincide
      println("Circles coincide");
      return new PVector[0];
    }
    else if (d + min(r1, r2) < max(r1, r2)) {
      // one circle contains the other
      println("One circle contains the other");
      return new PVector[0];
    }
    else {
      float a = (r1*r1 - r2*r2 + d*d)/ (2.0*d);
      float h = sqrt(r1*r1 - a*a);

      // find p2
      PVector p2 = new PVector(x1 + (a * dx) / d, y1 + (a * dy) / d);

      // find intersection points p3
      PVector intersection1 = new PVector(p2.x + (h * dy / d), p2.y - (h * dx / d));
      PVector intersection2 = new PVector(p2.x - (h * dy / d), p2.y + (h * dx / d));

      PVector[] result;
      if(d == r1 + r2) {
        result = new PVector[1];
        result[0] = intersection1;
      }
      else {
        result = new PVector[2];
        result[0] = intersection1;
        result[1] = intersection2;
      }
      return result;
    }
  }

  private PVector getSeedPoint() {
    Puff puff = _puffs.get(floor(_puffs.size() * random(1)));
    PVector p = new PVector(_minRadius, 0);
    p.rotate(2 * PI * random(1));
    p.add(puff.x, puff.y, 0);
    return p;
  }

  /**
   * Returns true iff the given point overlaps any puff's outer radius.
   */
  private boolean hitTestPoint(float x, float y) {
    PVector d, p = new PVector(x, y);
    for (Puff puff : _puffs) {
      d = new PVector(puff.x, puff.y);
      d.sub(p);
      if (d.mag() < puff.r) {
        return true;
      }
    }
    return false;
  }

  /**
   * Returns true iff the given puff overlaps any other puff's inner radius by a certain amount.
   */
  private boolean hasInnerRadiusOverlap(float x, float y, float r) {
    PVector d, p = new PVector(x, y);
    for (Puff puff : _puffs) {
      d = new PVector(puff.x, puff.y);
      d.sub(p);
      if (d.mag() < _innerRadiusFactor * (puff.r + r) * 0.8) {
        return true;
      }
    }
    return false;
  }

  /**
   * Returns true iff the given puff overlaps any other puff's outer radius by a certain amount.
   */
  private boolean hasOuterRadiusOverlap(float x, float y, float r) {
    PVector d, p = new PVector(x, y);
    for (Puff puff : _puffs) {
      d = new PVector(puff.x, puff.y);
      d.sub(p);
      if (d.mag() < (puff.r + r) * 1) {
        return true;
      }
    }
    return false;
  }

  /**
   * Returns true iff the given puff overlaps any other puff's outer radius but not its inner radius.
   */
  private boolean hasShyOverlap(float x, float y, float r) {
    PVector d, p = new PVector(x, y);
    for (Puff puff : _puffs) {
      d = new PVector(puff.x, puff.y);
      d.sub(p);
      if (d.mag() < (puff.r + r) * 1 && d.mag() > _innerRadiusFactor * (puff.r + r) * 0.8) {
        return true;
      }
    }
    return false;
  }

  private class Puff {
    float x, y;
    float r;

    Puff(float xArg, float yArg, float rArg) {
      x = xArg;
      y = yArg;
      r = rArg;
    }

    Puff(float xArg, float yArg, float rArg, boolean f) {
      x = xArg;
      y = yArg;
      r = rArg;
    }
  }
}


