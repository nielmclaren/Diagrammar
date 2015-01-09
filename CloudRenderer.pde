
import java.util.Collections;
import megamu.mesh.*;

class CloudRenderer {
  PVector _position;
  ArrayList<Puff> _puffs;
  String _style;
  float _minRadius, _maxRadius;
  float _innerRadiusFactor;
  float _minDistanceFactor;
  int[] _extrema;
  PVector _prospect0, _prospect1, _prospectMid;
  PVector _nextPuffPoint;
  PVector _centroid;

  Puff _longestLinePuff0, _longestLinePuff1;

  CloudRenderer(float x, float y) {
    init(x, y, "cartoon", 40, 80, 0.8);
  }

  CloudRenderer(float x, float y, String style, float minRadius, float maxRadius) {
    init(x, y, "cartoon", minRadius, maxRadius, 0.8);
  }

  private void init(
      float posX,
      float posY,
      String style,
      float minRadius,
      float maxRadius,
      float innerRadiusFactor) {
    _position = new PVector(posX, posY);
    _style = style; // "cartoon" or "concentrics"
    _minRadius = minRadius;
    _maxRadius = maxRadius;
    _innerRadiusFactor = innerRadiusFactor;
    _minDistanceFactor = 0.5;

    float r = map(random(1), 0, 1, _minRadius, _maxRadius),
      r2 = map(random(1), 0, 1, _minRadius, _maxRadius);
    PVector d = new PVector(r, 0);
    d.rotate(2 * PI * random(1));
    Puff puff0 = new Puff(0, 0, r),
         puff1 = new Puff(d.x, d.y, r2);
    _puffs = new ArrayList<Puff>();
    _puffs.add(puff0);
    _puffs.add(puff1);

    _longestLinePuff0 = puff0;
    _longestLinePuff1 = puff1;
    _extrema = new int[0];
    _prospect0 = null;
    _prospect1 = null;
    _prospectMid = null;
    _centroid = null;
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

  void calculateNextPuff() {
    Puff puff0, puff1;
    PVector p;
    float dx, dy, distSq, sumRadiusSq;

    float[][] points = getPuffPoints();
    int[] extrema = _extrema = getExtremaPuffIndices(points);
    Puff[] puffs = getLongestHullSegmentPuffs(extrema);

    if (extrema.length > 0) {
      puff0 = puffs[0];
      puff1 = puffs[1];
      _longestLinePuff0 = puff0;
      _longestLinePuff1 = puff1;

      dx = puff1.x - puff0.x;
      dy = puff1.y - puff0.y;
      distSq = dx * dx + dy * dy;
      sumRadiusSq = puff0.r + puff1.r;
      sumRadiusSq = sumRadiusSq * sumRadiusSq;

      if (distSq > sumRadiusSq) {
        println("Non-overlapping");
        println(sqrt(distSq) + " > sqrt(" + puff0.r + "^2 + " + puff1.r + "^2) = " + sqrt(sumRadiusSq));
        p = getPointForNonOverlapping(puffs[0], puffs[1]);
      }
      else {
        println("Overlapping");
        p = getPointForOverlapping(puffs[0], puffs[1]);
      }

      _nextPuffPoint = p;
    }
    else {
      _nextPuffPoint = null;
    }
  }

  void addPuff() {
    if (_nextPuffPoint != null) {
      float r = map(random(1), 0, 1, _minRadius, _maxRadius);
      _puffs.add(new Puff(_nextPuffPoint.x, _nextPuffPoint.y, r));
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

    _centroid = centroid;
    _prospectMid = p;
    _prospect0 = p0;
    _prospect1 = p1;

    if (PVector.sub(p1, centroid).mag() > PVector.sub(p0, centroid).mag()) {
      return p1;
    }
    else {
      return p0;
    }
  }

  private PVector getPointForOverlapping(Puff puff0, Puff puff1) {
    PVector centroid = getCentroid();
    _centroid = centroid;
    _prospectMid = new PVector(puff0.x + (puff1.x - puff0.x)/2, puff0.y + (puff1.y - puff0.y)/2);
    PVector[] intersections = intersect(puff0.x, puff0.y, puff0.r, puff1.x, puff1.y, puff1.r);
    if (intersections.length >= 2) {
      if (PVector.sub(intersections[0], centroid).mag() > PVector.sub(intersections[1], centroid).mag()) {
        _prospect0 = intersections[0];
        _prospect1 = intersections[1];
        return intersections[0];
      }
      else {
        _prospect0 = intersections[1];
        _prospect1 = intersections[0];
        return intersections[1];
      }
    }
    else if (intersections.length >= 1) {
      _prospect0 = intersections[0];
      _prospect1 = null;
      return intersections[0];
    }
    else {
      _prospect0 = null;
      _prospect1 = null;
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

  void lostCause() {
    int fails = 0;
    int maxFails = 10000;
    float r, r0 = 0;
    PVector d = new PVector(), p;
    _puffs = new ArrayList<Puff>();
    for (int i = 0; i < 10; i++) {
      r = map(random(1), 0, 1, _minRadius, _maxRadius);
      if (i == 0) {
        _puffs.add(new Puff(0, 0, r));
      }
      else {
        p = getSeedPoint();
        d.set(1, 0);
        d.rotate(2 * PI * random(1));
        p.add(d.x * (r0 + r) * _minDistanceFactor, d.y * (r0 + r) * _minDistanceFactor, 0);
        d.mult(4);

        while (hasMinDistanceOverlap(p.x, p.y, r) || !hasOuterRadiusOverlap(p.x, p.y, r) || hasShyOverlap(p.x, p.y, r)) {
          p.add(d.x, d.y, 0);
          if (!hasOuterRadiusOverlap(p.x, p.y, r)) {
            break;
          }
        }

        if (!hasOuterRadiusOverlap(p.x, p.y, r)) {
          if (++fails > maxFails) {
            println("Mega fail!");
            break;
          }
          else {
            _puffs.add(new Puff(p.x, p.y, r, true));
            i--;
            continue;
          }
        }

        _puffs.add(new Puff(p.x, p.y, r));
      }

      r0 = r;
    }
    Collections.shuffle(_puffs);

    println(fails);
  }

  void draw(PGraphics g) {
    g.fill(255);
    g.stroke(0);
    g.strokeWeight(2);
    for (Puff puff : _puffs) {
      g.ellipse(_position.x + puff.x, _position.y + puff.y, 2*puff.r, 2*puff.r);
    }

    g.fill(255);
    g.noStroke();
    for (Puff puff : _puffs) {
      g.ellipse(_position.x + puff.x, _position.y + puff.y, 2*puff.r*_innerRadiusFactor, 2*puff.r*_innerRadiusFactor);
    }
  }

  void drawLines(PGraphics g) {
    g.stroke(0, 64);
    g.strokeWeight(1);
    for (int i = 0; i < _puffs.size(); i++) {
      Puff puff = _puffs.get(i);
      for (int j = i + 1; j < _puffs.size(); j++) {
        Puff puffy = _puffs.get(j);
        g.line(
          _position.x + puff.x, _position.y + puff.y,
          _position.x + puffy.x, _position.y + puffy.y);
      }
    }
  }

  void drawConvexHull(PGraphics g) {
    g.stroke(0, 128);
    g.strokeWeight(2);
    for (int i = 0; i < _extrema.length; i++) {
      Puff puff0 = _puffs.get(_extrema[i]);
      Puff puff1 = _puffs.get(_extrema[(i + 1) % _extrema.length]);
      g.line(
        _position.x + puff0.x,
        _position.y + puff0.y,
        _position.x + puff1.x,
        _position.y + puff1.y);
    }

    if (_centroid != null) {
      g.noStroke();
      g.fill(64);
      g.ellipse(_position.x + _centroid.x, _position.y + _centroid.y, 10, 10);
    }
  }

  void drawLongestHullLine(PGraphics g) {
    g.stroke(0, 158, 224);
    g.strokeWeight(3);
    g.line(
      _position.x + _longestLinePuff0.x,
      _position.y + _longestLinePuff0.y,
      _position.x + _longestLinePuff1.x,
      _position.y + _longestLinePuff1.y);

    g.noStroke();
    g.fill(0, 140, 227, 32);
    g.ellipse(_position.x + _longestLinePuff0.x, _position.y + _longestLinePuff0.y, 2*_longestLinePuff0.r, 2*_longestLinePuff0.r);
    g.ellipse(_position.x + _longestLinePuff1.x, _position.y + _longestLinePuff1.y, 2*_longestLinePuff1.r, 2*_longestLinePuff1.r);

    if (_centroid != null) {
      g.noStroke();
      g.fill(64);
      g.ellipse(_position.x + _centroid.x, _position.y + _centroid.y, 10, 10);
    }
  }

  void drawProspectivePoints(PGraphics g) {
    color centroidLineColor = color(255, 0, 0);
    color midpointLineColor = color(232, 140, 12);

    if (_prospect0 != null) {
      g.strokeWeight(2);
      g.noFill();

      g.stroke(centroidLineColor);
      g.line(
        _position.x + _centroid.x, _position.y + _centroid.y,
        _position.x + _prospect0.x, _position.y + _prospect0.y);

      g.stroke(midpointLineColor);
      g.line(
        _position.x + _prospectMid.x, _position.y + _prospectMid.y,
        _position.x + _prospect0.x, _position.y + _prospect0.y);

      g.stroke(64);
      g.fill(255, 252, 13);
      g.ellipse(_position.x + _prospect0.x, _position.y + _prospect0.y, 10, 10);
    }

    if (_prospect1 != null) {
      g.stroke(0, 0, 255);
      g.strokeWeight(2);
      g.noFill();

      g.stroke(centroidLineColor);
      g.line(
        _position.x + _centroid.x, _position.y + _centroid.y,
        _position.x + _prospect1.x, _position.y + _prospect1.y);

      g.stroke(midpointLineColor);
      g.line(
        _position.x + _prospectMid.x, _position.y + _prospectMid.y,
        _position.x + _prospect1.x, _position.y + _prospect1.y);

      g.stroke(64);
      g.strokeWeight(1);
      g.fill(255, 252, 13);
      g.ellipse(_position.x + _prospect1.x, _position.y + _prospect1.y, 10, 10);
    }

    if (_prospectMid != null) {
      g.stroke(64);
      g.strokeWeight(1);
      g.fill(45, 228, 110);
      g.ellipse(_position.x + _prospectMid.x, _position.y + _prospectMid.y, 10, 10);
    }

    if (_centroid != null) {
      g.noStroke();
      g.fill(64);
      g.ellipse(_position.x + _centroid.x, _position.y + _centroid.y, 10, 10);
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
      if (puff.failed) continue;
      d = new PVector(puff.x, puff.y);
      d.sub(p);
      if (d.mag() < puff.r) {
        return true;
      }
    }
    return false;
  }

  /**
   * Returns true iff the given puff is within the minimum distance from any other puff.
   */
  private boolean hasMinDistanceOverlap(float x, float y, float r) {
    PVector d, p = new PVector(x, y);
    for (Puff puff : _puffs) {
      if (puff.failed) continue;
      d = new PVector(puff.x, puff.y);
      d.sub(p);
      if (d.mag() < _minDistanceFactor * (puff.r + r)) {
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
      if (puff.failed) continue;
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
      if (puff.failed) continue;
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
      if (puff.failed) continue;
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
    boolean failed;

    Puff(float xArg, float yArg, float rArg) {
      x = xArg;
      y = yArg;
      r = rArg;
      failed = false;
    }

    Puff(float xArg, float yArg, float rArg, boolean f) {
      x = xArg;
      y = yArg;
      r = rArg;
      failed = f;
    }
  }
}


