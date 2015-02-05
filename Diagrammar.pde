
int margin;

int nextPaletteIndex;
ArrayList<String> paletteFilenames;
color[] palette;
PGraphics inputImg, outputImg;

Brush brush;
int brushSize;
color brushColor;
int brushStep;
int prevStepX;
int prevStepY;

int imageX;
int imageY;

int chartRow;

boolean showInputImg;

FileNamer fileNamer;



void setup() {
  size(1024, 768);
  smooth();

  margin = 15;

  nextPaletteIndex = 0;
  paletteFilenames = new ArrayList<String>();
  paletteFilenames.add("assets/blobby.png");
  paletteFilenames.add("assets/stripey.png");
  loadNextPalette();

  showInputImg = true;

  fileNamer = new FileNamer("output/export", "png");

  inputImg = createGraphics(939, 400);
  outputImg = createGraphics(inputImg.width, inputImg.height);

  brushColor = color(128);
  brushStep = 15;
  brushSize = 70;
  brush = new Brush(inputImg, inputImg.width, inputImg.height);

  reset();
}

void draw() {
  background(0);

  int paletteWidth = 40;

  imageX = width - inputImg.width - margin;
  imageY = height - inputImg.height - margin;

  if (showInputImg) {
    inputImg.updatePixels();
    image(inputImg, imageX, imageY);
  }
  else {
    updateOutputImg();
    outputImg.updatePixels();
    image(outputImg, imageX, imageY);
  }

  if (mouseHitTestImage()) {
    chartRow = mouseY - imageY;
  }

  strokeWeight(2);
  stroke(255, 0, 0);
  line(imageX, imageY + chartRow, imageX + inputImg.width, imageY + chartRow);

  drawChart(
    imageX, margin,
    inputImg.width, imageY - margin - margin);
  drawPalette(
    imageX - margin - paletteWidth, margin,
    paletteWidth, imageY - margin - margin);
}

void drawChart(int chartX, int chartY, int chartWidth, int chartHeight) {
  noStroke();
  fill(32);
  rect(chartX, chartY, chartWidth, chartHeight);

  stroke(196);
  strokeWeight(1);
  noFill();
  for (int x = 0; x < inputImg.width; x++) {
    color c = inputImg.pixels[chartRow * inputImg.width + x];
    float b = brightness(c);

    if (!showInputImg) {
      stroke(translatePixel(c));
    }

    line(
      chartX + x,
      chartY + chartHeight,
      chartX + x,
      chartY + chartHeight - map(b, 0, 255, 0, chartHeight));
  }
}

void drawPalette(int paletteX, int paletteY, int paletteWidth, int paletteHeight) {
  noStroke();
  fill(32);
  rect(paletteX, paletteY, paletteWidth, paletteHeight);

  for (int i = 0; i < palette.length; i++) {
    fill(palette[i]);
    rect(
      paletteX, paletteY,
      paletteWidth, paletteHeight * (1 - (float) i / palette.length));
  }
}

void reset() {
  clear();

  for (int i = 0; i < 150; i++) {
    int x = randi(0, inputImg.width);
    int y = randi(0, inputImg.height);
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

void toggleInputOutput() {
  showInputImg = !showInputImg;
}

void updateOutputImg() {
  outputImg.loadPixels();
  for (int i = 0; i < outputImg.width * outputImg.height; i++) {
    outputImg.pixels[i] = translatePixel(inputImg.pixels[i]);
  }
}

void loadNextPalette() {
  String paletteFilename = paletteFilenames.get(nextPaletteIndex);
  nextPaletteIndex = (nextPaletteIndex + 1) % paletteFilenames.size();

  PImage paletteImg = loadImage(paletteFilename);
  palette = new color[paletteImg.width];
  paletteImg.loadPixels();
  for (int i = 0; i < paletteImg.width; i++) {
    palette[i] = paletteImg.pixels[i];
  }
}

void keyReleased() {
  switch (key) {
    case 'e':
    case ' ':
      reset();
      break;
    case 'c':
      clear();
      break;
    case 'p':
      loadNextPalette();
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
  if (mouseHitTestImage()) {
    drawBrush(mouseX - imageX, mouseY - imageY);
    stepped(mouseX - imageX, mouseY - imageY);
  }
}

void mouseDragged() {
  if (mouseHitTestImage() && stepCheck(mouseX, mouseY)) {
    drawBrush(mouseX - imageX, mouseY - imageY);
    stepped(mouseX - imageX, mouseY - imageY);
  }
}

void drawBrush(int x, int y) {
  //brush.squareBrush(x, y, brushSize, brushColor);
  //brush.squareFalloffBrush(x, y, brushSize, brushColor);
  //brush.circleBrush(x, y, brushSize, brushColor);
  brush.circleFalloffBrush(x, y, brushSize, brushColor);
  //brush.voronoiBrush(x, y, brushSize, brushColor);
}

boolean mouseHitTestImage() {
  return mouseX > imageX && mouseX < imageX + inputImg.width
      && mouseY > imageY && mouseY < imageY + inputImg.height;
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
