
BezierCurve curve;

ArrayList<Integer> colors;

void setup() {
  size(800, 600);
  frameRate(10);

  curve = new BezierCurve();

  colors = new ArrayList<Integer>();
  colors.add(color(204, 96, 155));
  colors.add(color(182, 180, 227));
  colors.add(color(239, 189, 162));
  colors.add(color(222, 112, 15));

  redraw();
}

void draw() {
}

void redraw() {
  background(161, 6, 24);

  curve = new BezierCurve();

  LineSegment line;

  int numSegments = randi(6, 12);
  for (int i = 0; i < numSegments; i++) {
    line = new LineSegment(random(width), random(height), random(width), random(height));
    curve.addControl(line);
  }

  noFill();
  strokeWeight(2);

  color c;
  float curveLen = curve.getLength();
  PVector p, foc0 = null, foc1 = null;
  int numFocusLines = 4096;

  float newFocProbability = 0.001;

  int focusLineIndex = 0;
  while (focusLineIndex < numFocusLines) {
    if (foc0 == null || random(1) < newFocProbability) {
      foc0 = new PVector(width * randf(0.25, 0.75), height * randf(0.25, 0.75));
    }
    if (foc1 == null || random(1) < newFocProbability) {
      foc1 = new PVector(width * randf(0.25, 0.75), height * randf(0.25, 0.75));
    }

    p = curve.getPointOnCurve((float)focusLineIndex / numFocusLines);

    c = colors.get(floor((float)focusLineIndex / numFocusLines * colors.size()));
    stroke(c, 33);
    line(p.x, p.y, foc0.x, foc0.y);
    line(p.x, p.y, foc1.x, foc1.y);

    focusLineIndex++;
  }

  stroke(255, 33);
  strokeWeight(1);

  curve.draw(this.g);
}

void keyReleased() {
  switch (key) {
    case ' ':
      redraw();
      break;

    case 'r':
      save("render.png");
      break;
  }
}

float randf(float low, float high) {
  return low + random(1) * (high - low);
}

int randi(int low, int high) {
  return low + floor(random(1) * (high - low));
}
