

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

  stepper = new VectorStepper(new PVector(randf(0, width), randf(0, height)), 25, 25);
  BezierSegment b0 = new BezierSegment(
    stepper.next(), stepper.next(), stepper.next(), stepper.next());

  stepper = new VectorStepper(new PVector(randf(0, width), randf(0, height)), 25, 25);
  BezierSegment b1 = new BezierSegment(
    stepper.next(), stepper.next(), stepper.next(), stepper.next());

  stepper = new VectorStepper(new PVector(randf(0, width), randf(0, height)), 25, 25);
  BezierSegment b2 = new BezierSegment(
    stepper.next(), stepper.next(), stepper.next(), stepper.next());

  stepper = new VectorStepper(new PVector(randf(0, width), randf(0, height)), 25, 25);
  BezierSegment b3 = new BezierSegment(
    stepper.next(), stepper.next(), stepper.next(), stepper.next());

  BezierSequence s0 = new BezierSequence(5, b0, b1, b2, b3);

  BezierSegment firstSeg = s0.getBezierSegment(0);
  BezierSegment lastSeg = s0.getBezierSegment(4);

  strokeWeight(1);
  stroke(0);
  b0.draw(this.g);
  b3.draw(this.g);

  s0.draw(this.g);

  (new LineSegment(firstSeg.getPoint(0.125), lastSeg.getPoint(0.125))).draw(this.g);
  (new LineSegment(firstSeg.getPoint(0.25), lastSeg.getPoint(0.25))).draw(this.g);
  (new LineSegment(firstSeg.getPoint(0.375), lastSeg.getPoint(0.375))).draw(this.g);
  (new LineSegment(firstSeg.getPoint(0.5), lastSeg.getPoint(0.5))).draw(this.g);
  (new LineSegment(firstSeg.getPoint(0.625), lastSeg.getPoint(0.625))).draw(this.g);
  (new LineSegment(firstSeg.getPoint(0.75), lastSeg.getPoint(0.75))).draw(this.g);
  (new LineSegment(firstSeg.getPoint(0.875), lastSeg.getPoint(0.875))).draw(this.g);
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
