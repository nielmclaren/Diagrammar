

BezierSegment bs;
PVector p0, p1, p2, p3;
float t;

void setup() {
  size(800, 600);
  frameRate(30);
  noFill();

  redraw();
}

void draw() {
  background(255);
  t += 0.0125;
  if (t > 1) t = 0;

  PVector p = bs.getPoint(t);
  ellipse(p.x, p.y, 10, 10);

  bs.draw(this.g, 0, t);
}

void redraw() {
  p0 = new PVector(100, 300);
  p1 = new PVector(100, 350);
  p2 = new PVector(400, 200);
  p3 = new PVector(450, 200);
  bs = new BezierSegment(p0, p1, p2, p3);

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
