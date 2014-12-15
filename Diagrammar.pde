
BezierCurve curve;
PVector mousePressedPoint;

boolean showControls;

void setup() {
  size(800, 600);
  frameRate(20);

  curve = new BezierCurve();

  showControls = false;
}

void draw() {
  background(255);

  if (showControls) {
    noFill();
    stroke(128);

    curve.drawControls(this.g);
  }

  noFill();
  stroke(64);

  curve.draw(this.g);
  
  if (curve.numSegments() > 0) {
    for (int i = 0; i < 16; i++) {
      PVector p = curve.getPointOnCurve(i / 16.0);
      ellipse(p.x, p.y, 2 * i, 2 * i);
    }
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
  curve.addControl(new LineSegment(
    mousePressedPoint.x, mousePressedPoint.y, mouseX, mouseY));
}
