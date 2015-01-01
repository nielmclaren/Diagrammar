
import gifAnimation.*;

int numCurves;
BezierCurve[] curves;
float[] offsets;
float[] lengths;
float[] colors;
PVector[] foc0;
PVector[] foc1;
float time;


void setup() {
  size(800, 600);
  frameRate(30);

  reset();
}

void draw() {
  time += 0.005;
  if (time > 1) time = time % 1;
  redraw(this.g, time);
  saveFrame("render####.tif");
}

void reset() {
  numCurves = 4;
  curves = new BezierCurve[numCurves];
  offsets = new float[numCurves];
  lengths = new float[numCurves];
  colors = new float[numCurves];
  foc0 = new PVector[numCurves];
  foc1 = new PVector[numCurves];

  ArrayList<Integer> colorChoices = new ArrayList<Integer>();
  colorChoices.add(color(90, 87, 154, 60));
  colorChoices.add(color(3, 66, 137, 60));
  colorChoices.add(color(90, 87, 154, 60));
  colorChoices.add(color(3, 66, 137, 60));
  colorChoices.add(color(90, 87, 154, 60));
  colorChoices.add(color(3, 66, 137, 60));
  colorChoices.add(color(241, 46, 43, 60));

  for (int i = 0; i < numCurves; i++) {
    curves[i] = createBezierCurve();

    offsets[i] = random(1);
    lengths[i] = 150 / curves[i].getLength();
    colors[i] = colorChoices.get(floor(random(1) * colorChoices.size()));
    foc0[i] = null;
    foc1[i] = null;
  }

  time = 0;
}

void redraw(PGraphics g, float t) {
  float t0, t1;
  PVector p;
  int numFocusLines = 32;
  float newFocProbability = 0.0;

  g.background(21, 12, 51);

  for (int i = 0; i < numCurves; i++) {
    t0 = map((t + offsets[i]) % 1, 0, 1, -lengths[i], 1);
    t1 = t0 + lengths[i];

    t0 = constrain(t0, 0, 1);
    t1 = constrain(t1, 0, 1);

    g.stroke(255, 33);
    g.strokeWeight(2);
    g.noFill();
    curves[i].draw(g, t0, t1);

    g.stroke((color)colors[i]);
    g.strokeWeight(2);
    for (int j = 0; j < numFocusLines; j++) {
      if (foc0[i] == null || random(1) < newFocProbability) {
        foc0[i] = new PVector(width * 0.5, height * 0.1);
      }
      if (foc1[i] == null || random(1) < newFocProbability) {
        foc1[i] = new PVector(width * 0.5, height * 0.9);
      }

      p = curves[i].getPoint(floor(map((float)j / numFocusLines, 0, 1, t0, t1) * 1000) / 1000.0);
      g.line(p.x, p.y, foc0[0].x, foc0[0].y);
      g.line(p.x, p.y, foc1[0].x, foc1[0].y);
    }
  }
}

BezierCurve createBezierCurve() {
  BezierCurve bc = new BezierCurve();
  VectorStepper stepper;

  int numControls = 7;
  for (int i = 0; i < numControls; i++) {
    stepper = new VectorStepper(new PVector(randf(width/6, width*5/6), randf(height/6, height*5/6)), 50, 100);
    bc.addControl(new LineSegment(stepper.next(), stepper.next()));
  }

  return bc;
}

void keyReleased() {
  switch (key) {
    case ' ':
      reset();
      break;

    case 'r':
      save("render.png");
      break;
  }
}

void saveRender() {
  GifMaker gif = new GifMaker(this, "render.gif");
  gif.setRepeat(0); // Endless animation.

  int numFrames = 30;
  for (float t = 0; t <= 1; t += 1.0/numFrames) {
    PGraphics render = createGraphics(width, height);
    render.beginDraw();
    redraw(render, t);
    render.endDraw();

    gif.setDelay(1);
    gif.addFrame(render);
  }

  gif.finish();
}

float randf(float low, float high) {
  return low + random(1) * (high - low);
}

int randi(int low, int high) {
  return low + floor(random(1) * (high - low));
}
