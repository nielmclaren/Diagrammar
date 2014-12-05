/**
 * Draws a bunch of line segments between two line segments.
 */

// Seed line endpoints.
PVector p0, p1, p2, p3;

// Control line endpoints.
PVector c0, c1, c2, c3;

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
  
  stroke(128);
  
  line(c0.x, c0.y, c1.x, c1.y);
  line(c2.x, c2.y, c3.x, c3.y);
  
  stroke(255);
  noFill();
  
  PVector m0, m1, cm0, cm1;
  for (int i = 0; i < numSegments; i++) {
    float t = (float)i / (numSegments - 1);
    m0 = getPointOnLine(p0, p1, t);
    m1 = getPointOnLine(p2, p3, t);
    
    cm0 = getPointOnLine(c0, c1, t);
    cm1 = getPointOnLine(c2, c3, t);
    
    bezier(m0.x, m0.y, cm0.x, cm0.y,
      cm1.x, cm1.y, m1.x, m1.y);
  }
}

void regenerateSeedLines() {
  p0 = new PVector(random(1) * width/2, random(1) * height/2);
  p1 = new PVector(random(1) * width/2 + width/2, random(1) * height/2);
  p2 = new PVector(random(1) * width/2, random(1) * height/2 + height/2);
  p3 = new PVector(random(1) * width/2 + width/2, random(1) * height/2 + height/2);
  
  c0 = new PVector(random(1) * width/2, random(1) * height/2);
  c1 = new PVector(random(1) * width/2 + width/2, random(1) * height/2);
  c2 = new PVector(random(1) * width/2, random(1) * height/2 + height/2);
  c3 = new PVector(random(1) * width/2 + width/2, random(1) * height/2 + height/2);
}

PVector getPointOnLine(PVector p0, PVector p1, float t) {
  return PVector.add(p0, PVector.mult(PVector.sub(p1, p0), t));
}

void mouseReleased() {
  regenerateSeedLines();
}
