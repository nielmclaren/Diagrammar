

ArrayList<Integer> colors;

void setup() {
  size(1024, 768);
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

  VectorStepper stepper;

  stepper = new VectorStepper(new PVector(randf(0, width), randf(0, height)));
  BezierSegment b0 = new BezierSegment(
    stepper.next(), stepper.next(), stepper.next(), stepper.next());

  stepper = new VectorStepper(new PVector(randf(0, width), randf(0, height)));
  BezierSegment b1 = new BezierSegment(
    stepper.next(), stepper.next(), stepper.next(), stepper.next());

  stepper = new VectorStepper(new PVector(randf(0, width), randf(0, height)));
  BezierSegment b2 = new BezierSegment(
    stepper.next(), stepper.next(), stepper.next(), stepper.next());

  stepper = new VectorStepper(new PVector(randf(0, width), randf(0, height)));
  BezierSegment b3 = new BezierSegment(
    stepper.next(), stepper.next(), stepper.next(), stepper.next());

  BezierSequence s0 = new BezierSequence(5, b0, b1, b2, b3);

  stroke(192);
  b0.draw(this.g);
  b1.draw(this.g);
  b2.draw(this.g);
  b3.draw(this.g);

  stroke(0);
  b0.draw(this.g);
  b3.draw(this.g);
  s0.draw(this.g);
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
