/**
 * Draws a bunch of line segments between two line segments.
 */

BezierSegment seedLine0, seedLine1;
BezierSegment controlLine0, controlLine1;
ArrayList<PVector> pointHandles;

int numSegments;

int pointHandleRadius;
PVector dragPoint;

boolean showControls;

void setup() {
  size(800, 600);
  frameRate(20);
  
  numSegments = 30;
  regenerateSeedLines();
  
  pointHandleRadius = 12;
  dragPoint = null;
  
  showControls = false;
}

void draw() {
  background(255);
  
  if (showControls) {
    noFill();
    stroke(128);
    
    seedLine0.draw(g);
    seedLine1.draw(g);
    
    seedLine0.drawControl(g);
    seedLine1.drawControl(g);
  
    controlLine0.draw(g);
    controlLine1.draw(g);
  
    controlLine0.drawControl(g);
    controlLine1.drawControl(g);
  }
  
  noFill();
  stroke(64);
  
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

  if (showControls) {
    fill(224);
    stroke(128);
    
    for (int i = 0; i < pointHandles.size(); i++) {
      PVector p = pointHandles.get(i);
      ellipse(p.x, p.y, pointHandleRadius * 2, pointHandleRadius * 2);
    }
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
    
  pointHandles = new ArrayList<PVector>();
  pointHandles.add(seedLine0.p0);
  pointHandles.add(seedLine0.p1);
  pointHandles.add(seedLine0.c0);
  pointHandles.add(seedLine0.c1);
  pointHandles.add(seedLine1.p0);
  pointHandles.add(seedLine1.p1);
  pointHandles.add(seedLine1.c0);
  pointHandles.add(seedLine1.c1);
  pointHandles.add(controlLine0.p0);
  pointHandles.add(controlLine0.p1);
  pointHandles.add(controlLine0.c0);
  pointHandles.add(controlLine0.c1);
  pointHandles.add(controlLine1.p0);
  pointHandles.add(controlLine1.p1);
  pointHandles.add(controlLine1.c0);
  pointHandles.add(controlLine1.c1);
}

void mousePressed() {
  if (showControls) {
    PVector m = new PVector(mouseX, mouseY);
    for (int i = 0; i < pointHandles.size(); i++) {
      PVector p = pointHandles.get(i);
      println(p.x + "," + p.y + "   " + mouseX + "," + mouseY);
      if (PVector.sub(p, m).mag() < pointHandleRadius) {
        startDrag(p);
        break;
      }
    }
  }
}

void mouseDragged() {
  if (showControls && dragPoint != null) {
    dragPoint.set(new PVector(mouseX, mouseY));
  }
}

void mouseReleased() {
  stopDrag();
}

void keyReleased() {
  switch (key) {
    case 'c':
      showControls = !showControls;
      break;
      
    case ' ':
      regenerateSeedLines();
      break;
      
    case 'r':
      save("render.png");
      break;
  }
}

void startDrag(PVector p) {
  dragPoint = p;
}

void stopDrag() {
  dragPoint = null;
}
