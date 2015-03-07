
import java.util.Iterator;

FileNamer fileNamer;
ArrayList<ControlPoint> points;

void setup() {
  size(1024, 768);
  smooth();

  fileNamer = new FileNamer("output/export", "png");

  reset();
}

void draw() {
}

void redraw() {
  background(0);

  drawGradient();
  drawControlPoints();
}

void drawControlPoints() {
  noFill();

  ControlPoint prevCp = null;
  PVector p;
  Iterator<ControlPoint> i = points.iterator();
  while (i.hasNext()) {
    ControlPoint cp = i.next();

    stroke(0, 0, 255);
    ellipse(cp.pos.x, cp.pos.y, 8, 8);

    p = cp.dir.get();
    p.normalize();
    p.mult(12);
    p.add(cp.pos);
    line(cp.pos.x, cp.pos.y, p.x, p.y);

    stroke(128);
    p = cp.dir.get();
    p.normalize();
    p.rotate(PI/2);
    p.mult(800);
    p.add(cp.pos);
    line(cp.pos.x, cp.pos.y, p.x, p.y);

    p = cp.dir.get();
    p.normalize();
    p.rotate(-PI/2);
    p.mult(800);
    p.add(cp.pos);
    line(cp.pos.x, cp.pos.y, p.x, p.y);

    if (prevCp != null) {
      line(prevCp.pos.x, prevCp.pos.y, cp.pos.x, cp.pos.y);
    }

    prevCp = cp;
  }
}

void drawGradient() {
  loadPixels();

  for (int i = 0; i < width * height; i++) {
    pixels[i] = color(0);
  }

  for (int i = 0; i < points.size() - 1; i++) {
    addGradient(i);
  }

  updatePixels();
}

void addGradient(int i) {
  if (points.size() < 2) return;
  ControlPoint cp0 = points.get(i);
  ControlPoint cp1 = points.get(i + 1);
  PVector p0 = cp0.pos;
  PVector p1 = cp1.pos;
  PVector perp0 = new PVector(-cp0.dir.y, cp0.dir.x);
  PVector perp1 = new PVector(-cp1.dir.y, cp1.dir.x);
  PVector curr = new PVector();
  PVector u, w, v = PVector.sub(p1, p0);
  float d = v.mag();
  float b;
  float startValue = i % 2 == 0 ? 0 : 255;
  float endValue = i % 2 == 0 ? 255 : 0;
  float value;
  PVector intersect0, intersect1;

  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      curr.set(x, y);
      u = PVector.sub(curr, p0);
      u.set(-u.y, u.x);
      w = PVector.mult(v, PVector.dot(u, v) / v.mag() / v.mag());

      intersect0 = findIntersection(
        x, y, x + v.x, y + v.y,
        p0.x, p0.y, p0.x + perp0.x, p0.y + perp0.y);
      intersect1 = findIntersection(
        x, y, x + v.x, y + v.y,
        p1.x, p1.y, p1.x + perp1.x, p1.y + perp1.y);

      float intersectDist = PVector.sub(intersect1, intersect0).mag();
      float intersectDist0 = PVector.sub(curr, intersect0).mag();
      float intersectDist1 = PVector.sub(curr, intersect1).mag();

      if (intersectDist0 < intersectDist && intersectDist1 < intersectDist) {
        b = brightness(pixels[y * width + x]);
        value = map(intersectDist0 / intersectDist, 0, 1, startValue, endValue);
        pixels[y * width + x] = color(max(b, value));
      }
    }
  }
}

void reset() {
  int numPoints = randi(5, 10);
  points = new ArrayList<ControlPoint>();
  VectorStepper stepper = new VectorStepper(
    new PVector(width*0.1, height*0.5),
    new PVector(1, 0),
    100, 300);

  for (int i = 0; i < numPoints; i++) {
    points.add(new ControlPoint(stepper.getPosition(), stepper.getDirection()));
    stepper.next();
  }

  PVector d;
  for (int i = 0; i < numPoints; i++) {
    ControlPoint curr = points.get(i);
    ControlPoint prev = i > 0 ? points.get(i - 1) : null;
    ControlPoint next = i < numPoints - 1 ? points.get(i + 1) : null;

    curr.dir = new PVector();

    if (prev != null) {
      d = curr.pos.get();
      d.sub(prev.pos);
      curr.dir.add(d);
    }

    if (next != null) {
      d = next.pos.get();
      d.sub(curr.pos);
      curr.dir.add(d);
    }

    curr.dir.normalize();
  }

  redraw();
}

void keyReleased() {
  switch (key) {
    case ' ':
      reset();
      break;
    case 'r':
      save(fileNamer.next());
      break;
  }
}

void mousePressed() {
}

void mouseReleased() {
}

void mouseDragged() {
}

float randf(float low, float high) {
  return low + random(1) * (high - low);
}

int randi(int low, int high) {
  return low + floor(random(1) * (high - low));
}

/**
 * Based on code by Marius Watz. Thanks, Marius!
 * @see http://workshop.evolutionzone.com/2007/09/10/code-2d-line-intersection/
 */
PVector findIntersection(
    float p1x, float p1y, float p2x, float p2y,
    float p3x, float p3y, float p4x, float p4y) {
  float xD1,yD1,xD2,yD2,xD3,yD3;
  float dot,deg,len1,len2;
  float ua,ub,div;

  // calculate differences
  xD1=p2x-p1x;
  xD2=p4x-p3x;
  yD1=p2y-p1y;
  yD2=p4y-p3y;
  xD3=p1x-p3x;
  yD3=p1y-p3y;

  // calculate the lengths of the two lines
  len1=sqrt(xD1*xD1+yD1*yD1);
  len2=sqrt(xD2*xD2+yD2*yD2);

  // calculate angle between the two lines.
  dot=(xD1*xD2+yD1*yD2); // dot product
  deg=dot/(len1*len2);

  // if abs(angle)==1 then the lines are parallell,
  // so no intersection is possible
  if(abs(deg)==1) return null;

  // find intersection Pt between two lines
  div=yD2*xD1-xD2*yD1;
  ua=(xD2*yD3-yD2*xD3)/div;
  ub=(xD1*yD3-yD1*xD3)/div;
  return new PVector(p1x+ua*xD1, p1y+ua*yD1);
}

class ControlPoint {
  PVector pos, dir;
  ControlPoint(PVector _pos, PVector _dir) {
    pos = _pos;
    dir = _dir;
  }
}
