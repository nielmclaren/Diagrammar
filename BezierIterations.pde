/**
 * Draws a bunch of line segments between two line segments.
 */

PVector p0, p1, p2, p3;
int numSegments;

void setup() {
  size(800, 600);
  
  numSegments = 30;
  regenerateSeedLines();
}

void draw() {
  background(102);
  stroke(255);
  
  line(p0.x, p0.y, p1.x, p1.y);
  line(p2.x, p2.y, p3.x, p3.y);
  
  PVector m0, m1;
  for (int i = 0; i < numSegments; i++) {
    m0 = getPointOnLine(p0, p1, (float)i / (numSegments - 1));
    m1 = getPointOnLine(p2, p3, (float)i / (numSegments - 1));
    
    line(m0.x, m0.y, m1.x, m1.y);
  }
}

void regenerateSeedLines() {
  p0 = new PVector(random(1) * width/2, random(1) * height/2);
  p1 = new PVector(random(1) * width/2 + width/2, random(1) * height/2);
  p2 = new PVector(random(1) * width/2, random(1) * height/2 + height/2);
  p3 = new PVector(random(1) * width/2 + width/2, random(1) * height/2 + height/2);
}

PVector getPointOnLine(PVector p0, PVector p1, float t) {
  return PVector.add(p0, PVector.mult(PVector.sub(p1, p0), t));
}

void mouseReleased() {
  regenerateSeedLines();
}
