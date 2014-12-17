
BezierCurve curve;

PVector mousePressedPoint;

boolean showControls;

void setup() {
  size(800, 600);
  frameRate(10);

  curve = new BezierCurve();

  showControls = false;

  LineSegment line;

  line = new LineSegment(111.0, 547.0, 86.0, 40.0);
  curve.addControl(line);

  line = new LineSegment(367.0, 468.0, 356.0, 327.0);
  curve.addControl(line);

  line = new LineSegment(253.0, 159.0, 696.0, 433.0);
  curve.addControl(line);
}

void draw() {
  background(255);

  if (showControls) {
    noFill();
    stroke(128);

    curve.drawControls(this.g);
  }

  noFill();
  stroke(128);

  curve.draw(this.g);

  fill(64);
  stroke(0);

  int numPoints = 10 * curve.numSegments();
  for (int i = 0; i < numPoints; i++) {
    float t = (float) i / numPoints;
    PVector p = curve.getPointOnCurve(t);
    ellipse(p.x, p.y, 12, 12);
  }
}

void keyReleased() {
  switch (key) {
    case 'c':
      showControls = !showControls;
      break;

    case 'r':
      save("render.png");
      break;
  }
}

void mousePressed() {
  mousePressedPoint = new PVector(mouseX, mouseY);
}

void mouseReleased() {
  LineSegment line = new LineSegment(mousePressedPoint.x, mousePressedPoint.y, mouseX, mouseY);
  curve.addControl(line);

  println(line.p0.x + ", " + line.p0.y + ", " + line.p1.x + ", " + line.p1.y);
}
