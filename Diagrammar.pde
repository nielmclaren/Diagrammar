
PImage quarterNoteImg, eighthNoteImg, eighthNotePairImg, sixteenthNotePairImg;
PImage trebleImg, bassImg, splatterImg;
BezierSequence bs;
int numNotes;
Note[] notes;
float time;
float timeDelta;

FileNamer folderNamer;

void setup() {
  size(270, 180, JAVA2D);
  frameRate(30);

  quarterNoteImg = loadImage("quarter_note_dark.png");
  eighthNoteImg = loadImage("eighth_note_dark.png");
  eighthNotePairImg = loadImage("eighth_note_pair_dark.png");
  sixteenthNotePairImg = loadImage("sixteenth_note_pair_dark.png");

  trebleImg = loadImage("treble.png");
  bassImg = loadImage("bass.png");
  splatterImg = loadImage("splatter.png");

  folderNamer = new FileNamer("output/export", "/");

  reset();
}

void draw() {
  time += timeDelta;
  if (time > 1) time = time % 1;

  redraw(this.g, time);
}

void reset() {
  bs = new BezierSequence(5);
  VectorStepper stepper0 = new VectorStepper(
    new PVector(-width*0.25, height*0.75), new PVector(1, 0), 50, 75, PI * 0.05, PI * 0.05),
    stepper1;
  LineSegment line;
  for (int i = 0; i < 10; i++) {
    stepper1 = new VectorStepper(i == 0 ? stepper0.curr() : stepper0.next(), new PVector(0, -1), 25, 50, PI * 0.1, PI * 0.1);
    line = new LineSegment(stepper1.next(), stepper1.next());
    bs.addControl(line);
  }

  resetNotes();

  time = 0;
  timeDelta = 0.0125;
}

void resetNotes() {
  PVector firstPt, lastPt, delta, mid, pos;
  float t, clefT;
  int sign;

  BezierCurve firstCurve = bs.getCurve(0);
  BezierCurve midCurve = bs.getCurve(2);
  BezierCurve lastCurve = bs.getCurve(4);

  numNotes = randi(20, 40);
  notes = new Note[numNotes];

  clefT = 100.0 / midCurve.getLength();
  pos = midCurve.getPoint(clefT);
  pos.x = 25;
  notes[0] = new Note(
    clefT,
    pos,
    random(1) < 0.5 ? bassImg : trebleImg,
    random(1) * PI / 8,
    0.6);

  for (int i = 1; i < numNotes; i++) {
    t = randf(0.2, 1);
    sign = randi(0, 2) * 2 - 1;

    firstPt = firstCurve.getPoint(t);
    lastPt = lastCurve.getPoint(t);
    delta = PVector.sub(lastPt, firstPt);
    delta.mult(0.5);
    delta.mult(1.5);
    mid = PVector.add(firstPt, delta);
    delta.mult(sign * random(1));
    pos = PVector.add(mid, delta);

    notes[i] = new Note(t, pos,
      getNoteImage(),
      random(1) * 2 * PI,
      randf(0.06, 0.12));
  }
}

void redraw(PGraphics g, float t) {
  float t0, t1;
  PVector p0, p1;
  float offset = 0, length = 0.25;

  g.background(255);

  t0 = map((t + offset) % 1, 0, 1, -length, 1);
  t1 = t0 + length;

  t0 = constrain(t0, 0, 1);
  t1 = constrain(t1, 0, 1);

  g.stroke(0);
  g.strokeWeight(1);
  g.noFill();
  bs.draw(g, t0, t1);

  p0 = bs.getCurve(0).getPoint(t0);
  p1 = bs.getCurve(4).getPoint(t0);
  g.line(p0.x, p0.y, p1.x, p1.y);

  p0 = bs.getCurve(0).getPoint(t1);
  p1 = bs.getCurve(4).getPoint(t1);
  g.line(p0.x, p0.y, p1.x, p1.y);

  for (int i = 0; i < numNotes; i++) {
    Note n = notes[i];
    n.draw(g, t0, t1);
  }
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
      reset();
      break;

    case 'r':
      export();
      break;
  }
}

void export() {
  FileNamer fileNamer = new FileNamer(folderNamer.next() + "frame", "gif");

  float offset = random(1);
  for (float t = 0; t < 1; t += timeDelta) {
    float t0 = (t + offset) % 1;
    PGraphics frame = createGraphics(width, height, JAVA2D);
    frame.beginDraw();
    frame.background(255);
    redraw(frame, t0);
    frame.save(fileNamer.next());
    frame.endDraw();
  }
}

float randf(float low, float high) {
  return low + random(1) * (high - low);
}

int randi(int low, int high) {
  return low + floor(random(1) * (high - low));
}

class Note {
  float time;
  PVector position;
  float rotation;
  float scale;
  PImage image;

  Note(float t, PVector p, PImage img, float r, float s) {
    time = t;
    position = p;
    rotation = r;
    scale = s;
    image = img;
  }

  void draw(PGraphics g, float t0, float t1) {
    if (time > t0 && time < t1) {
      float s = min(time - t0, t1 - time);
      s = s < 0.05 ? s / 0.05 : 1;

      g.pushMatrix();
      g.translate(position.x, position.y);
      g.scale(scale * s);
      g.rotate(rotation);
      g.image(image, -image.width/2, -image.height/2);
      g. popMatrix();
    }
  }
}
