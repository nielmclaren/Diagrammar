
float noiseScale;
color[] palette;
PImage inputImg, outputImg;
boolean showInputImg;
FileNamer fileNamer;

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

  reset();
}

void reset() {
  inputImg = createImage(width, height, RGB);
  outputImg = createImage(width, height, RGB);

  updateInputImage(inputImg);
  for (int i = 0; i < 8; i++) {
    float noiseOffset = random(1) * 100000;
    for (int x = -1; x <= width + 1; x += 32) {
      for (int y = -1; y <= height + 1; y+= 32) {
        float noiseVal = noise(x * noiseScale + noiseOffset, y * noiseScale + noiseOffset);
        if (noiseVal > 0.65) {
          drawAt(x + jitter(), y + jitter());
        }
      }
    }
  }

  updateOutputImage(inputImg, outputImg);

  redraw();
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
  int i, r = 64;
  float rSq = r*r, d, dSq;
  inputImg.loadPixels();
  for (int x = -r; x <= r; x++) {
    if (targetX + x < 0 || targetX + x >= inputImg.width) continue;
    for (int y = -r; y <= r; y++) {
      if (targetY + y < 0 || targetY + y >= inputImg.height) continue;
      dSq = x*x + y*y;
      d = max(abs(x), abs(y));
      i = (targetY + y) * inputImg.width + (targetX + x);
      c = inputImg.pixels[i];
      inputImg.pixels[i] = color(map(d, 0, r, brightness(c), brightness(c) + 16));
    }
  }
  inputImg.updatePixels();
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
  if (b % 4 < 2) {
    b = b / 2;
    return palette[floor(map(b, 0, 255, 0, palette.length - 1))];
  }
  else {
    b = 128 + b / 2;
    return palette[floor(map(b, 0, 255, 0, palette.length - 1))];
  }
}

float randf(float low, float high) {
  return low + random(1) * (high - low);
}

int randi(int low, int high) {
  return low + floor(random(1) * (high - low));
}
