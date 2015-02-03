
color[] palette;
PImage inputImg, outputImg;

Brush brush;
int brushSize;
color brushColor;
int brushStep;
int prevStepX;
int prevStepY;

boolean showInputImg;

FileNamer fileNamer;



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

  inputImg = createImage(width, height, RGB);
  outputImg = createImage(width, height, RGB);

  brushSize = 40;
  brushColor = color(0, 255, 0);
  brushStep = 15;
  brush = new Brush(this.g, width, height);

  reset();
  redraw();
}

void draw() {
}

void reset() {
  background(0);
  for (int i = 0; i < 100; i++) {
    drawBrush((int)random(width), (int)random(height));
  }
}

void clear() {
  inputImg.loadPixels();
  for (int i = 0; i < inputImg.pixels.length; i++) {
    inputImg.pixels[i] = color(0);
  }
  inputImg.updatePixels();
}

void redraw() {
  if (showInputImg) {
    image(inputImg, 0, 0);
  }
  else {
    image(outputImg, 0, 0);
  }
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
  drawBrush(mouseX, mouseY);
  stepped(mouseX, mouseY);
}

void mouseDragged() {
  if (stepCheck(mouseX, mouseY)) {
    drawBrush(mouseX, mouseY);
    stepped(mouseX, mouseY);
  }
}
void drawBrush(int x, int y) {
  //brush.squareBrush(inputImg, x, y, brushSize, brushColor);
  //brush.squareFalloffBrush(inputImg, x, y, brushSize, brushColor);
  //brush.circleBrush(inputImg, x, y, brushSize, brushColor);
  brush.circleFalloffBrush(x, y, brushSize, brushColor);
  //brush.voronoiBrush(inputImg, x, y, brushSize, brushColor);
}

boolean stepCheck(int x, int y) {
  float dx = x - prevStepX;
  float dy = y - prevStepY;
  return brushStep * brushStep < dx * dx  +  dy * dy;
}

void stepped(int x, int y) {
  prevStepX = x;
  prevStepY = y;
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
