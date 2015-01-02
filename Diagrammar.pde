

BezierSequence bs;
float time;

void setup() {
  size(800, 600);
  frameRate(30);

  reset();
}

void draw() {
  time += 0.0125;
  if (time > 1) time = time % 1;

  redraw(this.g, time);
}

void reset() {
  bs = new BezierSequence(5);
  /*
  VectorStepper stepper0 = new VectorStepper(
    new PVector(0, width*0.5), new PVector(1, 0), 50, 75, PI * 0.05, PI * 0.05),
    stepper1;
  LineSegment line;
  for (int i = 0; i < 10; i++) {
    stepper1 = new VectorStepper(stepper0.next(), new PVector(0, -1), 25, 50, PI * 0.1, PI * 0.1);
    line = new LineSegment(stepper1.next(), stepper1.next());
    println("bs.addControl(new LineSegment(" + line.p0.x + ", " + line.p0.y + ", " + line.p1.x + ", " + line.p1.y + "));");
    bs.addControl(line);
  }
  */

  bs.addControl(new LineSegment(45.16468, 347.96848, 17.105837, 309.3488));
  bs.addControl(new LineSegment(122.89366, 357.85144, 122.89366, 321.82938));
  bs.addControl(new LineSegment(194.4061, 373.6504, 194.4061, 343.86325));
  bs.addControl(new LineSegment(258.46652, 380.73953, 258.46652, 335.47012));
  bs.addControl(new LineSegment(285.52515, 388.30923, 263.13983, 357.4985));
  bs.addControl(new LineSegment(374.7312, 406.12653, 374.7312, 364.24716));
  bs.addControl(new LineSegment(409.18533, 395.2421, 393.65805, 373.87064));
  bs.addControl(new LineSegment(498.58636, 386.87125, 525.59424, 349.6981));
  bs.addControl(new LineSegment(573.3299, 367.11798, 573.3299, 335.01013));
  bs.addControl(new LineSegment(632.6387, 349.9786, 632.6387, 301.26776));

  time = 0;
}

void redraw(PGraphics g, float t) {
  float t0, t1;
  PVector p;
  float offset = 0, length = 0.25;

  g.background(255);

  t0 = map((t + offset) % 1, 0, 1, -length, 1);
  t1 = t0 + length;

  t0 = constrain(t0, 0, 1);
  t1 = constrain(t1, 0, 1);

  g.stroke(0);
  g.strokeWeight(1);
  g.noFill();
  bs.draw(this.g, t0, t1);
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

float randf(float low, float high) {
  return low + random(1) * (high - low);
}

int randi(int low, int high) {
  return low + floor(random(1) * (high - low));
}
