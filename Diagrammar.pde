

BezierCurve bc;
PVector p0, p1, p2, p3;
float t, d;

void setup() {
  size(800, 600);
  frameRate(30);
  noFill();

  background(255);
  d = random(1);
  redraw();
}

void draw() {
  background(255);
  t += 0.0125;
  if (t > 1) {
    d = random(1);
    t = -d;
  }

  float t0 = constrain(t, 0, 1);
  float t1 = constrain(t + d, 0, 1);

  stroke(0);
  strokeWeight(2);
  bc.draw(this.g, t0,t1);

  PVector p;
  p = bc.getPoint(t0);
  ellipse(p.x, p.y, 10, 10);
  p = bc.getPoint(t1);
  ellipse(p.x, p.y, 10, 10);
}

void redraw() {
  bc = new BezierCurve();
  bc.addControl(new LineSegment(100, 300, 300, 300));
  bc.addControl(new LineSegment(400, 150, 500, 150));
  bc.addControl(new LineSegment(700, 300, 700, 350));
  bc.addControl(new LineSegment(500, 450, 450, 450));

  t = 0;
}

void keyReleased() {
  switch (key) {
    case ' ':
      redraw();
      break;

    case 'r':
      saveFrame("render####.png");
      break;
  }
}

float randf(float low, float high) {
  return low + random(1) * (high - low);
}

int randi(int low, int high) {
  return low + floor(random(1) * (high - low));
}
