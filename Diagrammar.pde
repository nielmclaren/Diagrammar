

PImage charlieImg;
PImage quarterNoteDarkImg, eighthNoteDarkImg, eighthNotePairDarkImg, sixteenthNotePairDarkImg;
PImage quarterNoteLightImg, eighthNoteLightImg, eighthNotePairLightImg, sixteenthNotePairLightImg;
PImage trebleImg, bassImg, splatterImg;

boolean isLight;

void setup() {
  size(1000, 1000);
  frameRate(10);

  charlieImg = loadImage("charlie_parker.jpg");

  quarterNoteDarkImg = loadImage("quarter_note_dark.png");
  eighthNoteDarkImg = loadImage("eighth_note_dark.png");
  eighthNotePairDarkImg = loadImage("eighth_note_pair_dark.png");
  sixteenthNotePairDarkImg = loadImage("sixteenth_note_pair_dark.png");

  quarterNoteLightImg = loadImage("quarter_note_light.png");
  eighthNoteLightImg = loadImage("eighth_note_light.png");
  eighthNotePairLightImg = loadImage("eighth_note_pair_light.png");
  sixteenthNotePairLightImg = loadImage("sixteenth_note_pair_light.png");

  trebleImg = loadImage("treble.png");
  bassImg = loadImage("bass.png");
  splatterImg = loadImage("splatter.png");

  redraw();
}

void draw() {
}

void redraw() {
  background(255);
  tint(255);
  image(charlieImg, 0, 0);

  for (int i = 0; i < 10; i++) {
    drawStuff();
  }
}

void drawStuff() {
  noFill();
  strokeWeight(1);

  isLight = random(1) < 0.25;
  if (isLight) {
    stroke(255);
    tint(255);
  }
  else {
    stroke(27, 19, 20);
    tint(27, 19, 20);
  }

  VectorStepper stepper, lineStepper;
  BezierSequence s = new BezierSequence(5);

  PVector start = new PVector(216, 540);
  stepper = new VectorStepper(start, new PVector(0.3,-1), 50, 75, 0, 2 * PI * 0.1);
  for (int i = 0; i < 10; i++) {
    lineStepper = new VectorStepper(stepper.next(), 25, 50);
    s.addControl(new LineSegment(lineStepper.next(), lineStepper.next()));
  }

  s.draw(this.g);

  BezierCurve firstCurve = s.getCurve(0);
  BezierCurve midCurve = s.getCurve(floor(s.getNumCurves() / 2));
  BezierCurve lastCurve = s.getCurve(s.getNumCurves() - 1);

  drawPosts(firstCurve, lastCurve);

  drawClef(midCurve.getPoint(10 / midCurve.getLength()));
  drawNotes(firstCurve, lastCurve);
}

void drawPosts(BezierCurve firstCurve, BezierCurve lastCurve) {
  float length = firstCurve.getLength();
  for (float t = 0; t < 1; t += (float)75 / length) {
    (new LineSegment(firstCurve.getPoint(t), lastCurve.getPoint(t))).draw(this.g);
  }
  (new LineSegment(firstCurve.getPoint(1), lastCurve.getPoint(1))).draw(this.g);
}

void drawClef(PVector p) {
  PImage img = random(1) < 0.5 ? bassImg : trebleImg;
  pushMatrix();
  translate(p.x, p.y);
  rotate(2 * PI * random(1));
  scale(0.5);
  image(img, -img.width/2, -img.height/2);
  popMatrix();
}

void drawNotes(BezierCurve firstCurve, BezierCurve lastCurve) {
  int numSplats = randi(10, 100);
  PImage img;
  for (int i = 0; i < numSplats; i++) {
    float t = random(1);
    int sign = randi(0, 2) * 2 - 1;
    PVector firstPt = firstCurve.getPoint(t);
    PVector lastPt = lastCurve.getPoint(t);
    PVector delta = PVector.sub(lastPt, firstPt);
    delta.mult(0.5);
    delta.mult(1.25);
    PVector mid = PVector.add(firstPt, delta);
    delta.mult(sign * random(1));
    PVector pos = PVector.add(mid, delta);

    img = getNoteImage();

    pushMatrix();
    translate(pos.x, pos.y);
    scale(0.06);
    rotate(2 * PI * random(1));
    image(img, -img.width/2, -img.height/2);
    popMatrix();
  }
}

PImage getNoteImage() {
  float x = random(1);
  if (isLight) {
    if (x < 0.15) return sixteenthNotePairLightImg;
    if (x < 0.3) return eighthNotePairLightImg;
    if (x < 0.6) return eighthNoteLightImg;
    return quarterNoteLightImg;
  }
  else {
    if (x < 0.15) return sixteenthNotePairDarkImg;
    if (x < 0.3) return eighthNotePairDarkImg;
    if (x < 0.6) return eighthNoteDarkImg;
    return quarterNoteDarkImg;
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
