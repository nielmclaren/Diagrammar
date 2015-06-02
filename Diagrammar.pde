
PGraphics inputImg;

Brush brush;
int brushSize;
color brushColor;
int brushStep;
int prevStepX;
int prevStepY;

FileNamer fileNamer;

float noiseScale;

void setup() {
  size(1024, 768);
  smooth();

  fileNamer = new FileNamer("output/export", "png");

  inputImg = createGraphics(width, height);

  brushColor = color(64);
  brushStep = 15;
  brushSize = 200;
  brush = new Brush(inputImg, width, height);
  
  noiseScale = 0.012;

  reset();
  redraw();
}

void draw() {
}

void reset() {
  clear();
  
  int x;
  int y;
  for (int i = 0; i < 50; i++) {
    do {
      x = randi(0, width);
      y = randi(0, height);
    }
    while (noise(x*noiseScale, y*noiseScale) < 0.5);
    drawBrush(x, y);
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
  inputImg.updatePixels();
  image(inputImg, 0, 0);
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

float randf(float low, float high) {
  return low + random(1) * (high - low);
}

int randi(int low, int high) {
  return low + floor(random(1) * (high - low));
}

