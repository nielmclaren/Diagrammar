
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

  showInputImg = true;

  fileNamer = new FileNamer("output/export", "png");

  inputImg = createGraphics(width, height);
  outputImg = createGraphics(width, height);

  brushStep = 15;
  brush = new Brush(inputImg, width, height);

  reset();
  redraw();
}

void draw() {
}

void reset() {
  clear();

  ArrayList<Integer> brushColors = new ArrayList<Integer>();
  brushColors.add(color(32, 32, 128));
  brushColors.add(color(96, 32, 64));

  float noiseScale = 0.03;
  for (int i = 0; i < 2500; i++) {
    int x = (int)random(inputImg.width);
    int y = (int)random(inputImg.height);
    float n = noise(x * noiseScale, y * noiseScale);
    if (random(1) < n) {
      brushSize = floor(randf(30, 60) * 0.25 + map(n, 1, 0, 30, 60) * 0.75);
      brushColor = brushColors.get(floor(random(brushColors.size())));
      drawBrush(x, y);
    }
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
    outputImg.updatePixels();
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
