
PImage inputImg, outputImg;
PImage[] buffers;
int currBuffer;
FileNamer folderNamer, fileNamer;
int outputScale;

void setup() {
  size(1024, 512);
  frameRate(10);

  folderNamer = new FileNamer("output/export", "/");
  fileNamer = new FileNamer(folderNamer.next() + "frame", "gif");

  reset();
  redraw();
}

void reset() {
  buffers = new PImage[2];
  currBuffer = 0;
  outputScale = 4;

  inputImg = loadImage("assets/shroomer.png");
  outputImg = createImage(inputImg.width * outputScale, inputImg.height * outputScale, RGB);

  int w = inputImg.width;
  int h = inputImg.height;

  buffers[0] = createImage(w, h, RGB);
  buffers[1] = createImage(w, h, RGB);
  buffers[0].loadPixels();
  buffers[1].loadPixels();
  inputImg.loadPixels();
  for (int x = 0; x < w; x++) {
    for (int y = 0; y < h; y++) {
      int i = y * w + x;
      buffers[0].pixels[i] = color(random(1) < 0.2 ? 255 : 0);
      buffers[1].pixels[i] = 0;
    }
  }
  buffers[0].updatePixels();
  buffers[1].updatePixels();

  fileNamer = new FileNamer(folderNamer.next() + "frame", "gif");
}

void draw() {
  step();
  redraw();
  outputImg.save(fileNamer.next());
}

void step() {
  int w = buffers[0].width;
  int h = buffers[0].height;

  buffers[currBuffer].loadPixels();
  for (int x = 0; x < w; x++) {
    for (int y = 0; y < h; y++) {
      step(x, y, w, h);
    }
  }
  buffers[1 - currBuffer].updatePixels();
  inputImg.updatePixels();

  currBuffer = 1 - currBuffer;
}

void step(int cx, int cy, int w, int h) {
  color c = px(buffers[currBuffer], cx, cy);
  boolean alive = brightness(c) > 0;
  int x0, y0, count = 0;
  color[] neighborColors = new color[3];
  neighborColors[0] = neighborColors[1] = neighborColors[2] = 0;

  for (int x = cx - 1; x <= cx + 1; x++) {
    x0 = x;
    if (x0 < 0) x0 += w;
    if (x0 >= w) x0 -= w;
    for (int y = cy - 1; y <= cy + 1; y++) {
      if (x == cx && y == cy) continue;
      y0 = y;
      if (y0 < 0) y0 += h;
      if (y0 >= h) y0 -= h;

      if (brightness(px(buffers[currBuffer], x0, y0)) > 0) {
        if (count < 3) {
          neighborColors[count] = px(inputImg, x0, y0);
        }
        count++;
      }
    }
  }

  boolean result = rule(alive, count);
  px(buffers[1 - currBuffer], cx, cy, result ? color(255) : color(0));

  if (alive && !result) {
  }
  else if (!alive && result) {
    c = neighborColors[randi(count)];
    px(inputImg, cx, cy, c);
  }
}

boolean rule(boolean alive, int count) {
  if (alive) return count > 1 && count < 4;
  return count == 3;
}

void redraw() {
  inputImg.loadPixels();
  for (int x = 0; x < outputImg.width; x++) {
    for (int y = 0; y < outputImg.height; y++) {
      int x0 = floor(x/outputScale);
      int y0 = floor(y/outputScale);
      outputImg.pixels[y * outputImg.width + x] = lerpColor(inputImg.pixels[y0 * inputImg.width + x0], buffers[currBuffer].pixels[y0 * inputImg.width + x0], 0.05);
    }
  }
  outputImg.updatePixels();

  image(outputImg, 0, 0);

  pushMatrix();
  scale(8);
  image(buffers[currBuffer], 64, 0);
  popMatrix();
}

color px(PImage img, int x, int y) {
  return img.pixels[y * img.width + x];
}

void px(PImage img, int x, int y, color c) {
  if (x < 0 || x >= width || y < 0 || y >= height) return;
  img.pixels[y * img.width + x] = c;
}

float randf(float max) {
  return random(max);
}

float randf(float min, float max) {
  return min + random(1) * (max - min);
}

int randi(int max) {
  return floor(random(max));
}

int randi(int min, int max) {
  return floor(min + random(1) * (max - min));
}

void keyReleased() {
  switch (key) {
    case 'e':
      reset();
      redraw();
      break;
    case ' ':
      step();
      redraw();
      break;
    case 'r':
      save(fileNamer.next());
      break;
  }
}
