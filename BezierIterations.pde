/**
 * Draws a bunch of line segments between two line segments.
 */

BezierSegment seedLine0, seedLine1;
BezierSegment controlLine0, controlLine1;

int numSegments;

void setup() {
  size(800, 600);
  
  numSegments = 30;
  regenerateSeedLines();
}

void draw() {
  background(102);
  stroke(255);
  
  seedLine0.draw(g);
  seedLine1.draw(g);
  
  stroke(128);
  
  seedLine0.drawControl(g);
  seedLine1.drawControl(g);

  controlLine0.draw(g);
  controlLine1.draw(g);

  controlLine0.drawControl(g);
  controlLine1.drawControl(g);
  
  stroke(255);
  noFill();
  
  PVector m0, m1, cm0, cm1;
  for (int i = 0; i < numSegments; i++) {
    float t = (float)i / (numSegments - 1);
    m0 = seedLine0.getPointOnCurve(t);
    m1 = seedLine1.getPointOnCurve(t);
    
    cm0 = controlLine0.getPointOnCurve(t);
    cm1 = controlLine1.getPointOnCurve(t);
    
    bezier(m0.x, m0.y, cm0.x, cm0.y,
      cm1.x, cm1.y, m1.x, m1.y);
  }
}

void regenerateSeedLines() {
  seedLine0 = new BezierSegment(
    random(1) * width/2, random(1) * height/2,
    random(1) * width/2, random(1) * height/2,
    random(1) * width/2 + width/2, random(1) * height/2,
    random(1) * width/2 + width/2, random(1) * height/2);
  
  seedLine1 = new BezierSegment(
    random(1) * width/2, random(1) * height/2 + height/2,
    random(1) * width/2, random(1) * height/2 + height/2,
    random(1) * width/2 + width/2, random(1) * height/2 + height/2,
    random(1) * width/2 + width/2, random(1) * height/2 + height/2);
    
  controlLine0 = new BezierSegment(
    random(1) * width/2, random(1) * height/2,
    random(1) * width/2, random(1) * height/2,
    random(1) * width/2 + width/2, random(1) * height/2,
    random(1) * width/2 + width/2, random(1) * height/2);

  controlLine1 = new BezierSegment(
    random(1) * width/2, random(1) * height/2 + height/2,
    random(1) * width/2, random(1) * height/2 + height/2,
    random(1) * width/2 + width/2, random(1) * height/2 + height/2,
    random(1) * width/2 + width/2, random(1) * height/2 + height/2);
}

void mouseReleased() {
  regenerateSeedLines();
}
