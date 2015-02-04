
color[] palette;
PGraphics inputImg, outputImg;

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

  inputImg = createGraphics(width, height);
  outputImg = createGraphics(width, height);

  brushColor = color(128);
  brushStep = 15;
  brushSize = 70;
  brush = new Brush(inputImg, width, height);

  reset();
  redraw();
}

void draw() {
}

void reset() {
  clear();

  int num = 8;
  for (int i = 0; i < num; i++) {
    int x = width/(num + 1) + floor(i * width / (num + 1));
    float y = 1   -   (float) i / num;
    y = 200 * y * y * y + 10;
    drawBrush(x, height/2 + floor(y));
    drawBrush(x, height/2 - floor(y));
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
    inputImg.updatePixels();
    image(inputImg, 0, 0);
  }
  else {
    updateOutputImg();
    outputImg.updatePixels();
    image(outputImg, 0, 0);
  }
}

void toggleInputOutput() {
  showInputImg = !showInputImg;
  redraw();
}

void updateOutputImg() {
  outputImg.loadPixels();
  for (int i = 0; i < outputImg.width * outputImg.height; i++) {
    outputImg.pixels[i] = translatePixel(inputImg.pixels[i]);
  }
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
  println("drawBrush(" + mouseX + ", " + mouseY + ")");
  drawBrush(mouseX, mouseY);
  stepped(mouseX, mouseY);
  redraw();
}

void mouseDragged() {
  if (stepCheck(mouseX, mouseY)) {
    println("drawBrush(" + mouseX + ", " + mouseY + ")");
    drawBrush(mouseX, mouseY);
    stepped(mouseX, mouseY);
    redraw();
  }
}
void drawBrush(int x, int y) {
  //brush.squareBrush(x, y, brushSize, brushColor);
  //brush.squareFalloffBrush(x, y, brushSize, brushColor);
  //brush.circleBrush(x, y, brushSize, brushColor);
  brush.circleFalloffBrush(x, y, brushSize, brushColor);
  //brush.voronoiBrush(x, y, brushSize, brushColor);
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

color translatePixel(color c) {
  float b = brightness(c);
  return palette[floor(map(b, 0, 255, 0, palette.length - 1))];
}

float randf(float low, float high) {
  return low + random(1) * (high - low);
}

int randi(int low, int high) {
  return low + floor(random(1) * (high - low));
}
