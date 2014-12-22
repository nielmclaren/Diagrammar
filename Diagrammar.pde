
int numCurves;
BezierCurve[] curves;

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
  background(255);
  noFill();
  strokeWeight(1);

  LineSegment line;

  numCurves = 4;
  curves = new BezierCurve[numCurves];
  for (int i = 0; i < numCurves; i++) {
    curves[i] = new BezierCurve();

    curves[i].addControl(new LineSegment(
        width * 0.18 + (float)i * width/numCurves - (float)i * 52,
        height * 0.84,
        width * 0.18 + (float)i * width/numCurves - (float)i * 52 - 40,
        height * 0.84 - (float)i * 50 - 150));

    curves[i].addControl(new LineSegment(
        width * 0.18 + (float)i * width/numCurves - (float)i * 52 + (float)i * 39,
        height * 0.26 + (float)i * 41,
        width * 0.18 + (float)i * width/numCurves - (float)i * 52 + (float)i * 39 + 40,
        height * 0.26 + (float)i * 41 - 100));

    stroke(192);
    curves[i].drawControls(this.g);

    stroke(0);
    curves[i].draw(this.g);
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
