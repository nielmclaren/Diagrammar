
import java.util.Collections;
import megamu.mesh.*;

class CloudRenderer {
  PVector _position;
  ArrayList<Puff> _puffs;
  String _style;
  float _minRadius, _maxRadius;
  float _innerRadiusFactor;
  float _minDistanceFactor;

  CloudRenderer(float x, float y) {
    init(x, y, "cartoon", 50, 100, 0.8);
  }

  CloudRenderer(float x, float y, String style, float minRadius, float maxRadius) {
    init(x, y, "cartoon", minRadius, maxRadius, 0.8);
  }

  void init(
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

    lostCause();
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
    g.strokeWeight(3);
    for (Puff puff : _puffs) {
      if (puff.failed) continue;
      g.ellipse(_position.x + puff.x, _position.y + puff.y, 2*puff.r, 2*puff.r);
    }

    g.fill(242);
    g.noStroke();
    for (Puff puff : _puffs) {
      if (puff.failed) continue;
      g.ellipse(_position.x + puff.x, _position.y + puff.y, 2*puff.r*_innerRadiusFactor, 2*puff.r*_innerRadiusFactor);
    }

    g.noStroke();
    g.fill(255, 196, 196, 64);
    for (Puff puff : _puffs) {
      if (!puff.failed) continue;
      g.ellipse(_position.x + puff.x, _position.y + puff.y, 2*puff.r*_innerRadiusFactor, 2*puff.r*_innerRadiusFactor);
    }

    if (_style == "concentrics") {
      g.fill(255);
      g.stroke(128);
      g.strokeWeight(1);
      for (Puff puff : _puffs) {
        if (puff.failed) continue;
        for (int i = 0; i < 10; i++) {
          g.ellipse(_position.x + puff.x, _position.y + puff.y, 2*puff.r * (1 - (float)i/10), 2*puff.r * (1 - (float)i/10));
        }
      }
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


