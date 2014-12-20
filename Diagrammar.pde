
int numCurves;
BezierCurve[] curves;
VectorStepper[] steppers;

ArrayList<Integer> colors;

void setup() {
  size(800, 600);
  frameRate(10);

  colors = new ArrayList<Integer>();
  colors.add(color(210, 169, 229));
  colors.add(color(240, 176, 215));
  colors.add(color(255, 151, 134));
  colors.add(color(255, 187, 142));
  colors.add(color(251, 241, 154));

  redraw();
}

void draw() {
}

void redraw() {
  redrawBackgroundGradient();

  LineSegment line;

  numCurves = 3;
  curves = new BezierCurve[numCurves];
  steppers = new VectorStepper[numCurves];
  for (int i = 0; i < numCurves; i++) {
    curves[i] = new BezierCurve();
    steppers[i] = new VectorStepper(
      new PVector(width/2, height/2), 50, 100);

    int numSegments = randi(6, 16);
    PVector pos, dir;
    for (int j = 0; j < numSegments; j++) {
      pos = steppers[i].next();
      dir = steppers[i].getDirection();
      line = new LineSegment(pos.x, pos.y, pos.x + dir.x, pos.y + dir.y);
      curves[i].addControl(line);
    }

    noFill();
    strokeWeight(2);

    color c;
    float curveLen = curves[i].getLength();
    PVector p, foc0 = null, foc1 = null;
    int numFocusLines = 1024;

    float newFocProbability = 0.001;

    int focusLineIndex = 0;
    while (focusLineIndex < numFocusLines) {
      if (foc0 == null || random(1) < newFocProbability) {
        foc0 = new PVector(width * randf(0.25, 0.75), height * randf(0.25, 0.75));
      }
      if (foc1 == null || random(1) < newFocProbability) {
        foc1 = new PVector(width * randf(0.25, 0.75), height * randf(0.25, 0.75));
      }

      p = curves[i].getPointOnCurve((float)focusLineIndex / numFocusLines);

      c = colors.get(floor((float)focusLineIndex / numFocusLines * colors.size()));
      drawGradientLine(foc0, p, c);
      drawGradientLine(foc1, p, c);

      focusLineIndex++;
    }

    noFill();
    stroke(255, 33);
    strokeWeight(1);

    curves[i].draw(this.g);
  }
}

void redrawBackgroundGradient() {
  color c0 = color(62, 144, 221);
  color c1 = color(0, 99, 191);
  background(c1);
  noStroke();

  float x = width * 0.61;
  float y = height * 0.3;
  float dx = -0.1;
  float dy = 0.125;
  int radius = 2 * width;
  float s = 100;
  float ds = -0.5;
  for (int r = radius; r > 0; --r) {
    fill(lerpColor(c0, c1, (float) r / radius));
    ellipse(x, y, r, r);
    s += ds;
    x += dx;
    y += dy;
  }
}

void drawGradientLine(PVector from, PVector to, color c) {
  PVector prev = from.get(),
      curr = new PVector(),
      d = PVector.sub(to, from),
      temp = new PVector();
  float len = d.mag();

  int count = 100;
  float t = 0;
  while (t < 1) {
    t += random(1) / count;
    if (t > 1) t = 1;
    curr.set(from.x + d.x * t, from.y + d.y * t);
    temp.set(curr.x - prev.x, curr.y - prev.y);
    temp.mult(1.25);
    temp.rotate(random(1) * 2 * PI * 0.2);
    stroke(c, 50 * max(0, t - 0.2));
    line(prev.x, prev.y, prev.x + temp.x, prev.y + temp.y);
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
