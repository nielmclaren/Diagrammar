
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
    drawGradientLine(foc0, p, c);
    drawGradientLine(foc1, p, c);

    focusLineIndex++;
  }

  stroke(255, 33);
  strokeWeight(1);

  curve.draw(this.g);
}

void drawGradientLine(PVector from, PVector to, color c) {
  PVector prev = from.get(), curr = new PVector(), d = PVector.sub(to, from);
  float len = d.mag();
  
  int count = 20;
  float t = 0;
  while (t < 1) {
    t += random(1) / count;
    if (t > 1) t = 1;
    curr.set(from.x + d.x * t, from.y + d.y * t);
    stroke(c, 50 * max(0, t - 0.2));
    line(prev.x, prev.y, curr.x, curr.y);
    prev.set(curr);
  }
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
