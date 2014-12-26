

PImage trebleImg, bassImg, splatterImg;

void setup() {
  size(1024, 768);
  frameRate(10);

  trebleImg = loadImage("treble.png");
  bassImg = loadImage("bass.png");
  splatterImg = loadImage("splatter.png");

  redraw();
}

void draw() {
}

void redraw() {
  background(255);
  for (int i = 0; i < 10; i++) {
    drawStuff();
  }
}

void drawStuff() {
  noFill();
  strokeWeight(1);
  stroke(0, 10);

  VectorStepper stepper;
  BezierSequence s = new BezierSequence(24);

  for (int i = 0; i < 20; i++) {
    stepper = new VectorStepper(new PVector(randf(width/8, width*7/8), randf(height/8, height*7/8)), 25, 25);
    s.addControl(new BezierSegment(
      stepper.next(), stepper.next(), stepper.next(), stepper.next()));
  }

  s.draw(this.g);
}

void drawPosts(BezierSegment firstSeg, BezierSegment lastSeg) {
  (new LineSegment(firstSeg.getPoint(0.125), lastSeg.getPoint(0.125))).draw(this.g);
  (new LineSegment(firstSeg.getPoint(0.25), lastSeg.getPoint(0.25))).draw(this.g);
  (new LineSegment(firstSeg.getPoint(0.375), lastSeg.getPoint(0.375))).draw(this.g);
  (new LineSegment(firstSeg.getPoint(0.5), lastSeg.getPoint(0.5))).draw(this.g);
  (new LineSegment(firstSeg.getPoint(0.625), lastSeg.getPoint(0.625))).draw(this.g);
  (new LineSegment(firstSeg.getPoint(0.75), lastSeg.getPoint(0.75))).draw(this.g);
  (new LineSegment(firstSeg.getPoint(0.875), lastSeg.getPoint(0.875))).draw(this.g);
}

void drawClef(PVector p) {
  PImage img = random(1) < 0.5 ? bassImg : trebleImg;
  pushMatrix();
  translate(p.x, p.y);
  rotate(2 * PI * random(1));
  image(img, -img.width/2, -img.height/2);
  popMatrix();
}

void drawSplatter(BezierSegment firstSeg, BezierSegment lastSeg) {
  int numSplats = randi(10, 100);
  for (int i = 0; i < numSplats; i++) {
    float t = random(1);
    int sign = randi(0, 2) * 2 - 1;
    PVector firstPt = firstSeg.getPoint(t);
    PVector lastPt = lastSeg.getPoint(t);
    PVector delta = PVector.sub(lastPt, firstPt);
    delta.mult(0.5);
    delta.mult(1.25);
    PVector mid = PVector.add(firstPt, delta);
    delta.mult(sign * random(1));
    PVector pos = PVector.add(mid, delta);

    pushMatrix();
    translate(pos.x, pos.y);
    scale(randf(0.025, 0.1));
    rotate(2 * PI * random(1));
    image(splatterImg, -splatterImg.width/2, -splatterImg.height/2);
    popMatrix();
  }
}

void keyReleased() {
  switch (key) {
    case ' ':
      redraw();
      break;

    case 'r':
      saveFrame("render##.png");
      break;
  }
}

void mouseReleased() {
  float s = 0.07 * random(1);
  pushMatrix();
  translate(mouseX, mouseY);
  rotate(random(1) * 2 * PI);
  scale(s);
  image(splatterImg, -splatterImg.width/2, -splatterImg.height/2);
  popMatrix();
}

float randf(float low, float high) {
  return low + random(1) * (high - low);
}

int randi(int low, int high) {
  return low + floor(random(1) * (high - low));
}
