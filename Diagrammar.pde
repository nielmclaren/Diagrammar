
import gifAnimation.*;

int numCurves;
BezierCurve[] curves;
float[] offsets;
float[] lengths;
float[] colors;
float time;


void setup() {
  size(640, 480);
  frameRate(30);

  reset();
}

void draw() {
  time += 0.0125;
  if (time > 1) time = time % 1;
  redraw(this.g, time);
}

void reset() {
  numCurves = randi(41, 79);
  curves = new BezierCurve[numCurves];
  offsets = new float[numCurves];
  lengths = new float[numCurves];
  colors = new float[numCurves];

  ArrayList<Integer> colorChoices = new ArrayList<Integer>();
  colorChoices.add(color(90, 87, 154));
  colorChoices.add(color(3, 66, 137));
  colorChoices.add(color(90, 87, 154));
  colorChoices.add(color(3, 66, 137));
  colorChoices.add(color(90, 87, 154));
  colorChoices.add(color(3, 66, 137));
  colorChoices.add(color(241, 46, 43));

  for (int i = 0; i < numCurves; i++) {
    curves[i] = createBezierCurve();

    offsets[i] = random(1);
    lengths[i] = 30 / curves[i].getLength();
    colors[i] = colorChoices.get(floor(random(1) * colorChoices.size()));
  }

  time = 0;
}

void redraw(PGraphics g, float t) {
  float t0, t1;
  PVector p;

  g.background(21, 12, 51);
  g.strokeWeight(8);

  for (int i = 0; i < numCurves; i++) {
    t0 = map((t + offsets[i]) % 1, 0, 1, -lengths[i], 1);
    t1 = t0 + lengths[i];

    t0 = constrain(t0, 0, 1);
    t1 = constrain(t1, 0, 1);

    g.stroke((color)colors[i]);
    g.noFill();
    curves[i].draw(g, t0, t1);
  }
}

BezierCurve createBezierCurve() {
  BezierCurve bc = new BezierCurve();
  VectorStepper stepper;

  int numControls = 3;
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
      saveRender();
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
