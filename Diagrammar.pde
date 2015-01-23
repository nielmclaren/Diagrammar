
PImage quarterNoteImg, eighthNoteImg, eighthNotePairImg, sixteenthNotePairImg;
PImage trebleImg, bassImg, splatterImg;

FileNamer folderNamer;

void setup() {
  size(792, 612);
  frameRate(30);

  quarterNoteImg = loadImage("quarter_note_dark.png");
  eighthNoteImg = loadImage("eighth_note_dark.png");
  eighthNotePairImg = loadImage("eighth_note_pair_dark.png");
  sixteenthNotePairImg = loadImage("sixteenth_note_pair_dark.png");

  trebleImg = loadImage("treble.png");
  bassImg = loadImage("bass.png");
  splatterImg = loadImage("splatter.png");

  folderNamer = new FileNamer("output/export", "/");

  redraw(this.g);
}

void draw() {
}

void redraw(PGraphics g) {
  g.background(255);
  for (int i = 0; i < 10; i++) {
    drawBezierSequence(g, 100 + i * 70);
  }

  g.noStroke();
  g.fill(255);
  int numPanels = 5;
  for (int i = 0; i < numPanels; i++) {
    g.rect(i * width/numPanels, 0, width/numPanels/2, height);
  }
}

void drawBezierSequence(PGraphics g, int yOffset) {
  PVector p0, p1, delta, mid, pos;
  PImage img;
  float t;
  int sign;

  BezierSequence bs = getBezierSequence(yOffset);
  BezierCurve firstCurve = bs.getCurve(0);
  BezierCurve midCurve = bs.getCurve(2);
  BezierCurve lastCurve = bs.getCurve(4);

  g.stroke(0);
  g.strokeWeight(1);
  g.noFill();
  bs.draw(g);

  p0 = firstCurve.getPoint(0);
  p1 = lastCurve.getPoint(0);
  g.line(p0.x, p0.y, p1.x, p1.y);

  p0 = firstCurve.getPoint(1);
  p1 = lastCurve.getPoint(1);
  g.line(p0.x, p0.y, p1.x, p1.y);

  int numNotes = randi(60, 120);
  for (int i = 0; i < numNotes; i++) {
    t = randf();
    sign = randi(0, 2) * 2 - 1;

    p0 = firstCurve.getPoint(t);
    p1 = lastCurve.getPoint(t);
    delta = PVector.sub(p1, p0);
    delta.mult(0.5);
    delta.mult(1.5);
    mid = PVector.add(p0, delta);
    delta.mult(sign * random(1));
    pos = PVector.add(mid, delta);

    img = getNoteImage();

    g.pushMatrix();
    g.translate(pos.x, pos.y);
    g.scale(randf(0.05, 0.125));
    g.image(img, -img.width/2, -img.height/2);
    g.popMatrix();
  }

  int numMeasures = randi(6, 18);
  for (int i = 0; i < numMeasures; i++) {
    t = (float)i / numMeasures;

    p0 = firstCurve.getPoint(t);
    p1 = lastCurve.getPoint(t);
    g.line(p0.x, p0.y, p1.x, p1.y);
  }
}

BezierSequence getBezierSequence(int yOffset) {
  BezierSequence bs = new BezierSequence(5);
  VectorStepper stepper0 = new VectorStepper(
    new PVector(-100, yOffset),
    new PVector(1, 0), 50, 75, PI * 0.005, PI * 0.005),
    stepper1;
  LineSegment line;
  for (int i = 0; i < 30; i++) {
    stepper1 = new VectorStepper(i == 0 ? stepper0.curr() : stepper0.next(), new PVector(0, -1), 25, 50, PI * 0.1, PI * 0.1);
    line = new LineSegment(stepper1.next(), stepper1.next());
    bs.addControl(line);
  }
  return bs;
}

PImage getNoteImage() {
  float x = random(1);
  if (x < 0.15) return sixteenthNotePairImg;
  if (x < 0.3) return eighthNotePairImg;
  if (x < 0.6) return eighthNoteImg;
  return quarterNoteImg;
}

void keyReleased() {
  switch (key) {
    case ' ':
      redraw(this.g);
      break;

    case 'r':
      saveFrame("render.png");
      break;
  }
}

float randf() {
  return random(1);
}

float randf(float low, float high) {
  return low + random(1) * (high - low);
}

int randi(int low, int high) {
  return low + floor(random(1) * (high - low));
}
