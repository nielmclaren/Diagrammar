
PImage img;
PixelStepper stepper;

void setup() {
  size(1000, 1000);
  frameRate(10);

  redraw();
}

void draw() {
}

void redraw() {
  background(0);

  img = loadImage("input.jpg");
  stepper = new PixelStepper(img.width, img.height);

  img.loadPixels();
  for (int i = 0; i < 500000; i++) {
    drip(floor(random(1) * img.width), floor(random(1) * img.height));
  }
  img.updatePixels();

  redrawImage();
}

void redrawImage() {
  image(img, 0, 0);
}

void drip(int x, int y) {
  int[] p = new int[]{x, y};
  color c = getColor(p);
  float momentum = 0.2;
  while (p[0] >= 1 && p[0] < img.width - 1
      && p[1] >= 1 && p[1] < img.height - 1
      && (momentum = dripStep(c, p, momentum)) > 0) {}
}

float dripStep(color c, int[] p, float momentum) {
  int[] s, se, sw;
  float seSimilarity, swSimilarity;
  float threshold = 0.4 + 0.6 * (1 - momentum);

  setColor(p, c);

  if (similarity(c, getColor(s = stepper.se(p))) > threshold) {
    setCoord(p, s);
    return 0.95 * momentum;
  }

  se = stepper.s(p);
  sw = stepper.e(p);

  seSimilarity = similarity(c, getColor(se));
  swSimilarity = similarity(c, getColor(sw));

  if (seSimilarity > swSimilarity) {
    if (seSimilarity > threshold * 0.9) {
      setCoord(p, se);
      return 0.9 * momentum;
    }
  }
  else if (swSimilarity > threshold * 0.9) {
    setCoord(p, sw);
    return 0.9 * momentum;
  }

  return 0;
}

void keyReleased() {
  switch (key) {
    case ' ':
      redraw();
      break;

    case 'r':
      img.save("render.png");
      break;
  }
}

void mouseReleased() {
  if (mouseX >= 0 && mouseX < img.width
      && mouseY >= 0 && mouseY < img.height) {
    img.loadPixels();
    drip(mouseX, mouseY);
    img.updatePixels();
    redrawImage();
  }
}

void setCoord(int[] p, int[] q) {
  p[0] = q[0];
  p[1] = q[1];
}

int[] cloneCoord(int[] p) {
  return new int[]{p[0], p[1]};
}

float similarity(color a, color b) {
  return 1 - (abs(red(b) - red(a)) + abs(green(b) - green(a)) + abs(blue(b) - blue(a))) / 768;
}

color getColor(int[] p) {
  return img.pixels[p[1] * img.width + p[0]];
}

void setColor(int[] p, color c) {
  img.pixels[p[1] * img.width + p[0]] = c;
}

