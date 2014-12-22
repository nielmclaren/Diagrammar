
int numCurves;
BezierSegment[] posts;
BezierSequence[] treble, bass;
PImage trebleImg, bassImg;

ArrayList<Integer> colors;

void setup() {
  size(800, 600);
  frameRate(10);

  trebleImg = loadImage("treble.png");
  bassImg = loadImage("bass.png");

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

  LineSegment line;

  float t, w, x, y0, y1,r ;

  numCurves = 22;
  posts = new BezierSegment[numCurves];
  treble = new BezierSequence[floor(numCurves / 3)];
  bass = new BezierSequence[floor(numCurves / 3)];
  for (int i = 0; i < numCurves; i++) {
    t = (float)i / numCurves;
    w = width/numCurves;
    x = width * 0.06 + (float)i * w * 0.8;
    y0 = height * 0.74;
    y1 = height * 0.16;
    r = w * (i % 3 == 0 ? 0.3 : 1.7);
    posts[i] = new BezierSegment(
        x + random(r) - r/2,
        y0 + random(r) - r/2,
        x - w * 0.20 - t * w * 0.40 + random(r) - r/2,
        y0 - t * w * 1.20 - w * 1.25 + random(r) - r/2,

        x + t * w * 1.6 + random(r) - r/2,
        y1 + t * w * 6.6 + random(r) - r/2,
        x + t * w * 2.0 + w * 1.6 + random(r) - r/2,
        y1 + t * w * 6.2 - w * 0.7 + random(r) - r/2);

    if (i % 3 == 0 && i > 0) {
      treble[i % 3] = new BezierSequence(5,
        posts[i - 3], posts[i - 2], posts[i - 1], posts[i],
        0.07 + t * 0.2 + random(0.1),
        0.24 + t * 0.2 + random(0.1),
        0.07 + t * 0.2 + random(0.1),
        0.24 + t * 0.2 + random(0.1));

      bass[i % 3] = new BezierSequence(5,
        posts[i - 3], posts[i - 2], posts[i - 1], posts[i],
        0.45 + t * 0.2 + random(0.1),
        0.6 + t * 0.2 + random(0.1),
        0.45 + t * 0.2 + random(0.1),
        0.6 + t * 0.2 + random(0.1));

        stroke(0);
        treble[i % 3].draw(this.g);
        bass[i % 3].draw(this.g);
    }
  }

  for (int i = 0; i < numCurves; i++) {
    if (i % 3 == 0) {
      stroke(255);
      strokeWeight(5);
      posts[i].draw(this.g);

      stroke(0);
      strokeWeight(1);
      posts[i].draw(this.g);
    }
  }
  pushMatrix();
  translate(40, 120);
  image(trebleImg, 0, 0);
  popMatrix();

  pushMatrix();
  translate(30, 350);
  image(bassImg, 0, 0);
  popMatrix();
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
