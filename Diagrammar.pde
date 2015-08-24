
import java.util.Collections;
import java.util.Iterator;

FileNamer fileNamer;

ArrayList<Wave> waves;

PGraphics canvas;
PShape crest;

float diamondWidth;
float diamondHeight;
float overlapAmount;

void setup() {
  size(1024, 768);
  smooth();

  fileNamer = new FileNamer("output/export", "png");

  diamondWidth = 350;
  diamondHeight = 200;
  overlapAmount = 10;

  crest = loadShape("assets/crest.svg");
  crest.disableStyle();

  reset();
}

void clear() {
  waves = new ArrayList<Wave>();
  canvas = createGraphics(width, height);
}

void reset() {
  clear();
  generateWaves();
  redraw();
}

void redraw() {
  canvas.beginDraw();
  canvas.background(0);

  canvas.stroke(#cdddff);
  canvas.strokeWeight(2);
  canvas.fill(#444a91);

  Iterator<Wave> iter = waves.iterator();
  while (iter.hasNext()) {
    Wave wave = iter.next();
    canvas.pushMatrix();
    canvas.translate(wave.point.x, wave.point.y);
    drawWave(canvas, wave.direction);
    canvas.popMatrix();
  }
  canvas.endDraw();

  background(0);
  image(canvas, 0, 0);
}

void draw() {
}

void generateWaves() {
  float y = height;
  while (y > height * 0.1) {
    y = generateWave();
  }
}

void generateWaves(int count) {
  for (int i = 0; i < count; i++) {
    generateWave();
  }
}

float generateWave() {
  return generateWave(random(width));
}

float generateWave(float x) {
  float y = -2 * diamondHeight;
  while (y + diamondHeight/2 < height && !canPlaceDiamond(x, y)) {
    y += random(10);
  }

  PVector p = new PVector(x, y);
  while (p.y < height && !isBelow(p)) {
    p.y += 10;
  }

  if (p.y - y > diamondHeight/4) {
    int direction = random(1) < 0.5 ? -1 : 1;
    waves.add(0, new Wave(new PVector(x, y), direction));
  }

  return y;
}

void drawWave(PGraphics g, int direction) {
  float slope = 0.5;
  for (int i = 0; i < 30; i++) {
    float x = i * 10;
    float y = x * slope;
    g.pushMatrix();
    g.translate(direction * x + jitter(6), y + jitter(6));
    drawDiamond(g);
    g.popMatrix();
  }

  if (random(1) < 0.7) {
    int count = floor(random(2, 6));
    for (int i = 0; i < count; i++) {
      float x = (i + 1) * 25 + jitter(20);
      float y = x * slope;
      g.shape(crest, direction * x, y, direction * crest.width, crest.height);
    }
  }
}

void drawDiamond(PGraphics g) {
  float s = sqrt(diamondWidth * diamondWidth * 2) / 2;
  g.pushMatrix();
  g.scale(1, diamondHeight / diamondWidth);
  g.rotate(PI/4 + (random(1) - 0.5) * 0.05);
  g.rect(0, 0, 1000, 1000, 20); // Arbitrarily large.
  g.popMatrix();
}

float jitter(float x) {
  return (random(1) - 0.5) * x;
}

boolean canPlaceDiamond(float x, float y) {
  PVector mid = new PVector(x, y + diamondHeight/2);
  PVector midLeft = new PVector(x - diamondWidth/4, y + diamondHeight/2);
  PVector left = new PVector(x - diamondWidth/2, y + diamondHeight/2);
  PVector midRight = new PVector(x + diamondWidth/4, y + diamondHeight/2);
  PVector right = new PVector(x + diamondWidth/2, y + diamondHeight/2);

  boolean midOverlap = false;
  boolean midLeftOverlap = false;
  boolean leftOverlap = false;
  boolean midRightOverlap = false;
  boolean rightOverlap = false;

  Iterator<Wave> iter = waves.iterator();
  while (iter.hasNext()) {
    Wave wave = iter.next();
    midOverlap = midOverlap || isOutside(mid) || isBelow(mid, wave);
    midLeftOverlap = midLeftOverlap || isOutside(midLeft) || isBelow(midLeft, wave);
    leftOverlap = leftOverlap || isOutside(left) || isBelow(left, wave);
    midRightOverlap = midRightOverlap || isOutside(midRight) || isBelow(midRight, wave);
    rightOverlap = rightOverlap || isOutside(right) || isBelow(right, wave);

    if (midOverlap && midLeftOverlap && leftOverlap && midRightOverlap && rightOverlap) {
      return true;
    }
  }

  return false;
}

boolean isOutside(PVector p) {
  return p.x < -overlapAmount || p.x > width + overlapAmount;
}

boolean isBelow(PVector p) {
  Iterator<Wave> iter = waves.iterator();
  while (iter.hasNext()) {
    Wave wave = iter.next();
    if (isBelow(p, wave)) {
      return true;
    }
  }
  return false;
}

boolean isBelow(PVector p, Wave w) {
  PVector left = new PVector(w.point.x - diamondWidth/2, w.point.y + diamondHeight/2);
  if (p.x < left.x) return false;

  PVector right = new PVector(w.point.x + diamondWidth/2, w.point.y + diamondHeight/2);
  if (p.x > right.x) return false;

  float leftSign = (w.point.x - left.x) * (p.y - overlapAmount - left.y) - (w.point.y - left.y) * (p.x - left.x);
  leftSign = floor(leftSign / abs(leftSign));
  float rightSign = (w.point.x - right.x) * (p.y - overlapAmount - right.y) - (w.point.y - right.y) * (p.x - right.x);
  rightSign = floor(rightSign / abs(rightSign));
  return leftSign > 0 && rightSign < 0;
}

void keyReleased() {
  switch (key) {
    case 'c':
      clear();
      redraw();
      break;
    case ' ':
      reset();
      generateWaves();
      redraw();
      break;
    case 'w':
      generateWaves(50);
      redraw();
      break;
    case 'r':
      save(fileNamer.next());
      break;
  }
}

void mousePressed() {
}

void mouseReleased() {
  generateWave(mouseX);
  redraw();
}

void mouseDragged() {
}

float randf(float low, float high) {
  return low + random(1) * (high - low);
}

int randi(int low, int high) {
  return low + floor(random(1) * (high - low));
}

class Wave {
  PVector point;
  int direction;

  Wave(PVector p, int d) {
    point = p;
    direction = d;
  }
}

