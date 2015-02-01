
float noiseScale;
color[] palette;
PImage inputImg, outputImg;
boolean showInputImg;
FileNamer fileNamer;

int _radius;
int _maxAttempts;
float _attemptThreshold;
float _maxBrightnessIncrease;

int space;

void setup() {
  size(1024, 768);
  smooth();

  PImage paletteImg = loadImage("assets/blob_colors.png");
  palette = new color[paletteImg.width];
  paletteImg.loadPixels();
  for (int i = 0; i < paletteImg.width; i++) {
    palette[i] = paletteImg.pixels[i];
  }

  showInputImg = false;

  fileNamer = new FileNamer("output/export", "png");

  _radius = 128;
  _maxAttempts = 100;
  _attemptThreshold = 0.575;
  _maxBrightnessIncrease = 64;

  inputImg = createImage(width, height, RGB);
  outputImg = createImage(width, height, RGB);

  space = 240;

  reset();
  redraw();
}

void reset() {
  clear();
  updateInputImage(inputImg);
}

void clear() {
  inputImg.loadPixels();
  for (int i = 0; i < inputImg.pixels.length; i++) {
    inputImg.pixels[i] = color(0);
  }
  inputImg.updatePixels();
}

void redraw() {
  background(0);
  updateOutputImage(inputImg, outputImg);
  image(showInputImg ? inputImg : outputImg, 0, 0);

  stroke(226);

  for (int x = 0; x < width; x += space) {
    line(x, 0, x + height, height);
  }
  for (int x = 0; x < 2 * width; x += space) {
    line(x, 0, x - height, height);
  }
  for (int y = space; y < height; y += space) {
    line(0, y, height, y + height);
  }
  for (int x = 0; x < width; x += space/2) {
    line(x, 0, x, height);
  }
}

void draw() {
}

void toggleInputOutput() {
  showInputImg = !showInputImg;
  redraw();
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
    case 't':
      toggleInputOutput();
      break;
    case 'r':
      save(fileNamer.next());
      break;
  }
}

void mouseReleased() {
  drawAt(mouseX, mouseY);
  redraw();
}

void drawAt(int targetX, int targetY) {
  color c;
  int i, r = _radius;
  float hr = r * cos(PI/6);
  float rSq = r*r, dSq;
  inputImg.loadPixels();
  for (int x = -r; x <= r; x++) {
    if (targetX + x < 0 || targetX + x >= inputImg.width) continue;
    for (int y = -r; y <= r; y++) {
      if (targetY + y < 0 || targetY + y >= inputImg.height) continue;
      dSq = x*x + y*y;
      if (dSq > rSq) continue;
      i = (targetY + y) * inputImg.width + (targetX + x);
      c = inputImg.pixels[i];
      inputImg.pixels[i] = color(max(map(sqrt(dSq), sqrt(rSq), 0, 0, 255), brightness(c)));
    }
  }
  inputImg.updatePixels();
}

void updateInputImage(PImage img) {
  img.loadPixels();
  for (int i = 0; i < _maxAttempts; i++) {
    int x = randi(0, width);
    int y = randi(0, height);
    drawAt(x, y);
  }
  img.updatePixels();
}

void updateOutputImage(PImage in, PImage out) {
  if (in.width != out.width || in.height != out.height) {
    throw new Error("Input and output images must have the same dimensions.");
  }

  in.loadPixels();
  out.loadPixels();

  int offsetX = 16;
  int offsetY = 16;
  for (int x = 0; x < in.width; x++) {
    for (int y = 0; y < in.height; y++) {
      int m = floor((x + y) / space);
      int n = x - y > 0 ? floor((x - y) / space) : ceil((x - y) / space) + 1;
      if ((m + n) % 2 == 0) {
        out.pixels[y * out.width + x] = translationFunction(in.pixels[constrain(y + offsetY, 0, in.height - 1) * in.width + constrain(x + offsetX, 0, in.width - 1)]);
      }
      else {
        out.pixels[y * out.width + x] = translationFunction(in.pixels[y * in.width + x]);
      }
    }
  }
  out.updatePixels();
}

color translationFunction(color c) {
  float b = brightness(c);
  return palette[floor(map(b, 0, 255, 0, palette.length - 1))];
}

float randf(float low, float high) {
  return low + random(1) * (high - low);
}

int randi(int low, int high) {
  return low + floor(random(1) * (high - low));
}
