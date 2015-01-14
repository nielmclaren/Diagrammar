
Quad top;
PImage inputImg, outputImg;
FileNamer fileNamer;

void setup() {
  size(512, 256);
  smooth();

  inputImg = loadImage("assets/isntit.jpg");
  outputImg = createImage(inputImg.width, inputImg.height, RGB);

  fileNamer = new FileNamer("output/export", "png");
  reset();
  redraw();
}

void reset() {
  inputImg.loadPixels();
  int size = 4;
  top = getQuad(inputImg, 256, 0, 0);
  inputImg.updatePixels();
}

void clear() {
}

void redraw() {
  background(0);

  outputImg.loadPixels();
  drawQuad(top, top.mean, outputImg, 0, 0, 32);
  outputImg.updatePixels();

  image(inputImg, 0, 0);
  image(outputImg, inputImg.width, 0);
}

void draw() {
}

color px(PImage img, int x, int y) {
  return img.pixels[y * img.width + x];
}

void px(PImage img, int x, int y, color c) {
  img.pixels[y * img.width + x] = c;
}

void keyReleased() {
  switch (key) {
    case 'e':
    case ' ':
      reset();
      redraw();
      break;
    case 'c':
      clear();
      redraw();
      break;
    case 'r':
      save(fileNamer.next());
      break;
  }
}

color jitter(color c, float maxJitter) {
  return color(
    constrain(red(c) + randi(-maxJitter, maxJitter), 0, 255),
    constrain(green(c) + randi(-maxJitter, maxJitter), 0, 255),
    constrain(blue(c) + randi(-maxJitter, maxJitter), 0, 255));
}

float randf(float low, float high) {
  return low + random(1) * (high - low);
}

int randi(float low, float high) {
  return floor(low + random(1) * (high - low));
}

Quad getQuad(PImage img, int scale, int offsetX, int offsetY) {
  if (scale == 2) {
    return new Quad(
      px(img, offsetX, offsetY),
      px(img, offsetX + 1, offsetY),
      px(img, offsetX, offsetY + 1),
      px(img, offsetX + 1, offsetY + 1),
      scale);
  }

  return new Quad(
    getQuad(img, scale/2, offsetX, offsetY),
    getQuad(img, scale/2, offsetX + scale/2, offsetY),
    getQuad(img, scale/2, offsetX, offsetY + scale/2),
    getQuad(img, scale/2, offsetX + scale/2, offsetY + scale/2),
    scale);
}

void drawQuad(Quad q, color mean, PImage img, int offsetX, int offsetY, int maxJitter) {
  if (q.scale == 2) {
    px(img, offsetX, offsetY, mean + q.topLeft);
    px(img, offsetX + 1, offsetY, mean + q.topRight);
    px(img, offsetX, offsetY + 1, mean + q.bottomLeft);
    px(img, offsetX + 1, offsetY + 1, mean + q.bottomRight);
  }
  else {
    drawQuad(q.topLeftChild, jitter(mean + q.topLeft, maxJitter * q.scale / 256), img, offsetX, offsetY, maxJitter);
    drawQuad(q.topRightChild, jitter(mean + q.topRight, maxJitter * q.scale / 256), img, offsetX + q.scale/2, offsetY, maxJitter);
    drawQuad(q.bottomLeftChild, jitter(mean + q.bottomLeft, maxJitter * q.scale / 256), img, offsetX, offsetY + q.scale/2, maxJitter);
    drawQuad(q.bottomRightChild, jitter(mean + q.bottomRight, maxJitter * q.scale / 256), img, offsetX + q.scale/2, offsetY + q.scale/2, maxJitter);
  }
}

private class Quad {
  Quad topLeftChild, topRightChild, bottomLeftChild, bottomRightChild;
  color topLeft, topRight, bottomLeft, bottomRight, mean;
  int scale;

  Quad(Quad tl, Quad tr, Quad bl, Quad br, int s) {
    topLeftChild = tl;
    topRightChild = tr;
    bottomLeftChild = bl;
    bottomRightChild = br;
    mean = (topLeftChild.mean + topRightChild.mean + bottomLeftChild.mean + bottomRightChild.mean) / 4;
    topLeft = topLeftChild.mean - mean;
    topRight = topRightChild.mean - mean;
    bottomLeft = bottomLeftChild.mean - mean;
    bottomRight = bottomRightChild.mean - mean;
    scale = s;
  }

  Quad(color tl, color tr, color bl, color br, int s) {
    mean = (tl  + tr + bl + br) / 4;
    topLeft = tl - mean;
    topRight = tr - mean;
    bottomLeft = bl - mean;
    bottomRight = br - mean;
    scale = s;
  }
}
