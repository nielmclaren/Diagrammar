
float noiseScale;
color[] palette;
PImage inputImg, outputImg;
boolean showInputImg;
FileNamer fileNamer;

int _radius;
int _maxAttempts;
float _attemptThreshold;
float _maxBrightnessIncrease;

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

  _radius = 64;
  _maxAttempts = 3;
  _attemptThreshold = 0.575;
  _maxBrightnessIncrease = 16;

  inputImg = createImage(width, height, RGB);
  outputImg = createImage(width, height, RGB);
  reset();

  println(cos(PI/6));
}

void reset() {
  updateInputImage(inputImg);

  int w = _radius;
  int r = floor(w * cos(PI/6));
  int h = floor(w * tan(PI/3)/2);
  for (int i = 0; i < _maxAttempts; i++) {
    float noiseOffset = random(1) * 100000;
    for (int x = -1; x <= width + 1; x += 3*w/2) {
      int row = 0;
      for (int y = -1; y <= height + 1; y += h/2) {
        int newX = row % 2 == 0 ? x : x + floor(1.5 * w/2);
        float noiseVal = noise(newX * noiseScale + noiseOffset, y * noiseScale + noiseOffset);
        if (noiseVal > _attemptThreshold) {
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
  image(showInputImg ? inputImg : outputImg, 0, 0);
}

void draw() {
}

void toggleInputOutput() {
  showInputImg = !showInputImg;
  redraw();
}

int jitter() {
  return random(1) < 0.1 ? 1 : 0;
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
  drawAt(mouseX, mouseY);
  redraw();
}

void drawAt(int targetX, int targetY) {
  color c;
  int i, r = _radius;
  float hr = r * cos(PI/6);
  float rSq = r*r, d;
  inputImg.loadPixels();
  for (int x = -r; x <= r; x++) {
    if (targetX + x < 0 || targetX + x >= inputImg.width) continue;
    for (int y = -r; y <= r; y++) {
      if (targetY + y < 0 || targetY + y >= inputImg.height) continue;
      d = hexDistance(x, y);
      if (d > hr) continue;
      i = (targetY + y) * inputImg.width + (targetX + x);
      c = inputImg.pixels[i];
      inputImg.pixels[i] = color(map(d, hr, 0, brightness(c), brightness(c) + _maxBrightnessIncrease));
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
  if (b > maxB) println(b + " > " + maxB);
  if (b % 4 < 2) {
    return palette[floor(map(b, 0, maxB, 0, palette.length/2 - 1))];
  }
  else {
    return palette[floor(map(b, 0, maxB, palette.length/2, palette.length - 1))];
  }
}

float randf(float low, float high) {
  return low + random(1) * (high - low);
}

int randi(int low, int high) {
  return low + floor(random(1) * (high - low));
}
