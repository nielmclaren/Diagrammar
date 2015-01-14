
Quad top;
PImage inputImg, outputImg;
FileNamer folderNamer, fileNamer;

void setup() {
  size(256, 256);
  smooth();

  inputImg = loadImage("assets/dove-evolution-01.jpg");
  outputImg = createImage(inputImg.width, inputImg.height, RGB);

  folderNamer = new FileNamer("output/export", "/");
  fileNamer = new FileNamer(folderNamer.next() + "frame", "gif");

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
  drawQuad(top, top.mean, outputImg, 0, 0, 16);
  outputImg.updatePixels();

  image(outputImg, 0, 0);

  save(fileNamer.next());
}

void draw() {
}

PVector px(PImage img, int x, int y) {
  int i = y * img.width + x;
  return new PVector(
    red(img.pixels[i]),
    green(img.pixels[i]),
    blue(img.pixels[i]));
}

void px(PImage img, int x, int y, color c) {
  img.pixels[y * img.width + x] = c;
}

void px(PImage img, int x, int y, float b) {
  img.pixels[y * img.width + x] = color(b);
}

void px(PImage img, int x, int y, PVector p) {
  img.pixels[y * img.width + x] = color(p.x, p.y, p.z);
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

PVector dumbProduct(PVector a, PVector b) {
  return new PVector(a.x * b.x, a.y * b.y, a.z * b.z);
}

int getSign(float x) {
  return floor(abs(x) / x);
}

PVector getSign(PVector p) {
  return new PVector(
    abs(p.x) / p.x,
    abs(p.y) / p.y,
    abs(p.z) / p.z);
}

PVector getMean(PVector a, PVector b, PVector c, PVector d) {
  PVector mean = new PVector();
  mean.add(a);
  mean.add(b);
  mean.add(c);
  mean.add(d);
  mean.mult(1/4);
  return mean;
}

color jitter(color c, float maxJitter) {
  return color(
    constrain(red(c) + randi(-maxJitter, maxJitter), 0, 255),
    constrain(green(c) + randi(-maxJitter, maxJitter), 0, 255),
    constrain(blue(c) + randi(-maxJitter, maxJitter), 0, 255));
}

PVector jitter(PVector p, float maxJitter) {
  return new PVector(
    jitter(p.x, maxJitter),
    jitter(p.y, maxJitter),
    jitter(p.z, maxJitter));
}

float jitter(float x, float maxJitter) {
  return x + randf(-maxJitter, maxJitter);
}

float meanJitter(float mean, float deviation, float x) {
  float j = 0.2;
  return getSign(x - mean) * deviation * j   +   (x - mean) * (1 - j);
}

PVector meanJitter(PVector mean, PVector deviation, PVector p) {
  return new PVector(
    meanJitter(mean.x, deviation.x, p.x),
    meanJitter(mean.y, deviation.y, p.y),
    meanJitter(mean.z, deviation.z, p.z));
}

Quad quadJitter(Quad original, Quad adj0, Quad adj1, Quad opp, int scale) {
  if (random(1) < 0.9  +  0.1 * scale / 256) return original;
  if (random(1) < 0.7) {
    return random(1) < 0.5 ? adj0 : adj1;
  }
  return opp;
}

PVector quadJitter(PVector original, PVector adj0, PVector adj1, PVector opp, int scale) {
  if (random(1) < 1) return original;
  if (random(1) < 0.7) {
    return random(1) < 0.5 ? adj0 : adj1;
  }
  return opp;
}

float getDeviation(float mean, float a, float b, float c, float d) {
  return ((a - mean) + (b - mean) + (c - mean) + (d - mean)) / 4;
}

PVector getDeviation(PVector mean, PVector a, PVector b, PVector c, PVector d) {
  return new PVector(
    ((a.x - mean.x) + (b.x - mean.x) + (c.x - mean.x) + (d.x - mean.x)) / 4,
    ((a.y - mean.y) + (b.y - mean.y) + (c.y - mean.y) + (d.y - mean.y)) / 4,
    ((a.y - mean.y) + (b.y - mean.y) + (c.y - mean.y) + (d.y - mean.y)) / 4);
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

void drawQuad(Quad q, PVector mean, PImage img, int offsetX, int offsetY, int maxJitter) {
  if (q.scale == 2) {
    px(img, offsetX, offsetY, PVector.add(mean, q.topLeft));
    px(img, offsetX + 1, offsetY, PVector.add(mean, q.topRight));
    px(img, offsetX, offsetY + 1, PVector.add(mean, q.bottomLeft));
    px(img, offsetX + 1, offsetY + 1, PVector.add(mean, q.bottomRight));
  }
  else {
    drawQuad(q.topLeftChild, jitter(PVector.add(mean, q.topLeft), maxJitter * q.scale / 256), img, offsetX, offsetY, maxJitter);
    drawQuad(q.topRightChild, jitter(PVector.add(mean, q.topRight), maxJitter * q.scale / 256), img, offsetX + q.scale/2, offsetY, maxJitter);
    drawQuad(q.bottomLeftChild, jitter(PVector.add(mean, q.bottomLeft), maxJitter * q.scale / 256), img, offsetX, offsetY + q.scale/2, maxJitter);
    drawQuad(q.bottomRightChild, jitter(PVector.add(mean, q.bottomRight), maxJitter * q.scale / 256), img, offsetX + q.scale/2, offsetY + q.scale/2, maxJitter);
  }
}

private class Quad {
  Quad topLeftChild, topRightChild, bottomLeftChild, bottomRightChild;
  PVector topLeft, topRight, bottomLeft, bottomRight, mean;
  int scale;

  Quad(Quad tl, Quad tr, Quad bl, Quad br, int s) {
    topLeftChild = tl;
    topRightChild = tr;
    bottomLeftChild = bl;
    bottomRightChild = br;

    topLeftChild = quadJitter(tl, tr, bl, br, s);
    topRightChild = quadJitter(tr, tl, br, bl, s);
    bottomLeftChild = quadJitter(bl, br, tl, tr, s);
    bottomRightChild = quadJitter(br, bl, tr, tl, s);

    mean = getMean(topLeftChild.mean, topRightChild.mean, bottomLeftChild.mean, bottomRightChild.mean);
    PVector deviation = getDeviation(mean, topLeftChild.mean, topRightChild.mean, bottomLeftChild.mean, bottomRightChild.mean);
    topLeft = meanJitter(mean, deviation, topLeftChild.mean);
    topRight = meanJitter(mean, deviation, topRightChild.mean);
    bottomLeft = meanJitter(mean, deviation, bottomLeftChild.mean);
    bottomRight = meanJitter(mean, deviation, bottomRightChild.mean);

    topLeft = quadJitter(topLeft, topRight, bottomLeft, bottomRight, s);
    topRight = quadJitter(topRight, topLeft, bottomRight, bottomLeft, s);
    bottomLeft = quadJitter(bottomLeft, topLeft, bottomRight, topRight, s);
    bottomRight = quadJitter(bottomRight, topRight, bottomLeft, topLeft, s);
    scale = s;
  }

  Quad(PVector tl, PVector tr, PVector bl, PVector br, int s) {
    mean = getMean(tl, tr, bl, br);
    PVector deviation = getDeviation(mean, tl, tr, bl, tr);
    topLeft = meanJitter(mean, deviation, tl);
    topRight = meanJitter(mean, deviation, tr);
    bottomLeft = meanJitter(mean, deviation, bl);
    bottomRight = meanJitter(mean, deviation, br);

    topLeft = quadJitter(topLeft, topRight, bottomLeft, bottomRight, s);
    topRight = quadJitter(topRight, topLeft, bottomRight, bottomLeft, s);
    bottomLeft = quadJitter(bottomLeft, topLeft, bottomRight, topRight, s);
    bottomRight = quadJitter(bottomRight, topRight, bottomLeft, topLeft, s);
    scale = s;
  }
}
