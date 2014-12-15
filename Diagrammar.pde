/**
 * Draws a bunch of line segments between two line segments.
 */

BezierSequence bs;

boolean showControls;

void setup() {
  size(800, 600);
  frameRate(20);

  regenerateSeedLines();

  showControls = false;
}

void draw() {
  background(255);

  if (showControls) {
    noFill();
    stroke(128);

    bs.drawControls(this.g);
  }

  noFill();
  stroke(64);

  bs.draw(this.g);
}

void regenerateSeedLines() {
  BezierSegment seedLine0 = new BezierSegment(
    random(1) * width/2, random(1) * height/2,
    random(1) * width/2, random(1) * height/2,
    random(1) * width/2 + width/2, random(1) * height/2,
    random(1) * width/2 + width/2, random(1) * height/2);

  BezierSegment seedLine1 = new BezierSegment(
    random(1) * width/2, random(1) * height/2 + height/2,
    random(1) * width/2, random(1) * height/2 + height/2,
    random(1) * width/2 + width/2, random(1) * height/2 + height/2,
    random(1) * width/2 + width/2, random(1) * height/2 + height/2);

  BezierSegment controlLine0 = new BezierSegment(
    random(1) * width/2, random(1) * height/2,
    random(1) * width/2, random(1) * height/2,
    random(1) * width/2 + width/2, random(1) * height/2,
    random(1) * width/2 + width/2, random(1) * height/2);

  BezierSegment controlLine1 = new BezierSegment(
    random(1) * width/2, random(1) * height/2 + height/2,
    random(1) * width/2, random(1) * height/2 + height/2,
    random(1) * width/2 + width/2, random(1) * height/2 + height/2,
    random(1) * width/2 + width/2, random(1) * height/2 + height/2);

  bs = new BezierSequence(30, seedLine0, seedLine1, controlLine0, controlLine1);
}

void keyReleased() {
  switch (key) {
    case 'c':
      showControls = !showControls;
      break;

    case ' ':
      regenerateSeedLines();
      break;

    case 'r':
      save("render.png");
      break;
  }
}
