
float noiseScale;
color[] palette;
PImage inputImg, outputImg;
boolean showInputImg;
FileNamer fileNamer;

int _radius;
int _maxAttempts;
float _attemptThreshold;
float _maxBrightnessIncrease;
int _numPanels;

void setup() {
  size(1024, 768);
  smooth();

  noiseScale = 0.004;

  PImage paletteImg = loadImage("assets/blob_colors.png");
  palette = new color[paletteImg.width];
  paletteImg.loadPixels();
  for (int i = 0; i < paletteImg.width; i++) {
    palette[i] = paletteImg.pixels[i];
  }

  showInputImg = false;

  fileNamer = new FileNamer("output/export", "png");

  _radius = 32;
  _maxAttempts = 3;
  _attemptThreshold = 0.575;
  _maxBrightnessIncrease = 16;
  _numPanels = 6;

  inputImg = createImage(width/4, height, RGB);
  outputImg = createImage(width/4, height, RGB);
  reset();
}

void reset() {
  updateInputImage(inputImg);

  int w = _radius;
  int r = floor(w * cos(PI/6));
  int h = floor(w * tan(PI/3)/2);
  for (int i = 0; i < _maxAttempts; i++) {
    float noiseOffset = random(1) * 100000;
    for (int x = -1; x <= (width/_numPanels) + 1; x += 3*w/2) {
      int row = 0;
      for (int y = -1; y <= height + 1; y += h/2) {
        switch (row) {
          case 0: case 1: case 2:
          case 9: case 10: case 11: case 12:
          case 26: case 27: case 28: case 29:
          case 33: case 34: case 35: case 36:
          case 40: case 41: case 42: case 43:
          case 57: case 58: case 59: case 60:
            row++;
            continue;
        }

        float p;
        switch (row) {
          case 3: case 4: case 5: case 6: case 7: case 8:
            if (i > 1) continue;
            p = 0.8;
            break;
          case 30: case 31: case 32:
          case 37: case 38: case 39:
            if (i > 1) continue;
            p = 0.6;
            break;
          default:
            p = 0.9;
        }

        int newX = row % 2 == 0 ? x : x + floor(1.5 * w/2);
        float noiseVal = random(1); //noise(newX * noiseScale + noiseOffset, y * noiseScale + noiseOffset);
        if (noiseVal > p) {
          drawAt(newX + jitter(), y + jitter());
        }
        row++;
      }
    }
  }

  updateOutputImage(inputImg, outputImg);

  redraw();
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

  for (int i = 0; i < _numPanels/2; i++) {
    image(showInputImg ? inputImg : outputImg, i * outputImg.width*2, 0);
  }

  pushMatrix();
  scale(-1, 1);
  for (int i = 0; i < _numPanels/2; i++) {
    image(showInputImg ? inputImg : outputImg, -2 * (i + 1) * outputImg.width, 0);
  }
  popMatrix();
}

void draw() {
}

void toggleInputOutput() {
  showInputImg = !showInputImg;
  redraw();
}

int jitter() {
  return random(1) < 0.5 ? 2 : 0;
}

void keyReleased() {
  switch (key) {
    case 'e':
    case ' ':
      reset();
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
  int w = _radius;
  int r = floor(w * cos(PI/6));
  int h = floor(w * tan(PI/3)/2);
  int x = round(round(mouseX / (0.75*w)) * 0.75 * w);
  int y = round(round(mouseY / (1*h)) * 1 * h);
  drawAt(x, y);
  redraw();
}

void drawAt(int targetX, int targetY) {
  color c;
  int i, r = _radius;
  float hr = r * cos(PI/6);
  float rSq = r*r, d;
  inputImg.loadPixels();
  for (int baseX = 0; baseX < width; baseX += floor(width/_numPanels)) {
    for (int x = -r; x <= r; x++) {
      if (baseX + targetX + x < 0 || baseX + targetX + x >= inputImg.width) continue;
      for (int y = -r; y <= r; y++) {
        if (targetY + y < 0 || targetY + y >= inputImg.height) continue;
        d = hexDistance(x, y);
        if (d > hr) continue;
        i = (targetY + y) * inputImg.width + (baseX + targetX + x);
        c = inputImg.pixels[i];
        inputImg.pixels[i] = color(map(d, hr, 0, brightness(c), brightness(c) + _maxBrightnessIncrease));
      }
    }
  }
  inputImg.updatePixels();
}

float hexDistance(float x, float y) {
  if (x == 0) {
    return abs(y);
  }
  if (y == 0) {
    return abs(x) * cos(PI/6);
  }

  float sixthTan = tan(PI/3);
  if (y/x < sixthTan && y/x > -sixthTan) {
    return sqrt(x*x + y*y) * cos(abs(y/x) * x/y * PI/6 - atan(y/x));
  }
  return sqrt(x*x + y*y) * cos(PI/2 - abs(atan(y/x)));
}

void updateInputImage(PImage img) {
  float offset = random(1) * 100000;
  img.loadPixels();
  for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++) {
      float noiseVal = noise(x * noiseScale + offset, y * noiseScale + offset);
      img.pixels[y * img.width + x] = color(0);
    }
  }
  img.updatePixels();
}

void updateOutputImage(PImage in, PImage out) {
  if (in.width != out.width || in.height != out.height) {
    throw new Error("Input and output images must have the same dimensions.");
  }

  in.loadPixels();
  out.loadPixels();
  for (int x = 0; x < in.width; x++) {
    for (int y = 0; y < in.height; y++) {
      out.pixels[y * out.width + x] = translationFunction(in.pixels[y * in.width + x]);
    }
  }
  out.updatePixels();
}

color translationFunction(color c) {
  float b = brightness(c);
  float maxB = _maxBrightnessIncrease * _maxAttempts * 2;
  if (b % 5 < 1) {
    return color(2, 64, 89);
  }
  else if (b % 5 < 2) {
    return color(217, 115, 26);
  }
  else if (b % 5 < 3) {
    return color(115, 108, 14);
  }
  else if (b % 5 < 4) {
    return color(2, 103, 115);
  }
  else {
    return color(191, 57, 27);
  }
}

float randf(float low, float high) {
  return low + random(1) * (high - low);
}

int randi(int low, int high) {
  return low + floor(random(1) * (high - low));
}
