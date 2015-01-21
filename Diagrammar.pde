
import java.lang.System;
import java.util.LinkedList;
import java.util.Queue;

PImage inputImg, outputImg;
int outputScale;
int currStep;
int prevScore;

ArrayList<int[]> cells;
ArrayList<int[]> brink;
int[] newCell;
int newCellBrinkIndex;

final color CELL_COLOR = color(0, 0, 255);
final color EMPTY_COLOR = color(255, 255, 255);
final color BRINK_COLOR = color(0, 255, 0);

FileNamer folderNamer, fileNamer;

void setup() {
  size(640 + 4, 640 + 4);
  frameRate(10);

  outputScale = 8;

  folderNamer = new FileNamer("output/export", "/");

  reset();
  step();
  redraw();
}

void draw() {
}

void reset() {
  inputImg = createImage(80, 80, RGB);
  outputImg = createImage(
    inputImg.width * outputScale,
    inputImg.height * outputScale, RGB);

  for (int i = 0; i < inputImg.width * inputImg.height; i++) {
    inputImg.pixels[i] = color(255);
  }

  cells = new ArrayList<int[]>();
  brink = new ArrayList<int[]>();

  newCell = point(floor(inputImg.width/2), floor(inputImg.height/2));

  newCellBrinkIndex = 0;
  brink.add(newCell);

  currStep = 0;
  prevScore = 0;

  fileNamer = new FileNamer(folderNamer.next() + "frame", "gif");
}

void step() {
  ArrayList<int[]> newBrink = filterEmpty(inputImg, getRookNeighbors(inputImg, newCell));

  int score = brink.size() + newBrink.size() - 1;
  if (score > prevScore) {
    cells.add(newCell);
    px(inputImg, newCell, CELL_COLOR);

    brink.remove(newCellBrinkIndex);
    for (int[] p : newBrink) {
      brink.add(p);
      px(inputImg, p, BRINK_COLOR);
    }

    prevScore = score;
    println(score);
  }

  if (newCellBrinkIndex >= 0) {
    newCellBrinkIndex = randi(brink.size());
    newCell = brink.get(newCellBrinkIndex);
  }
}

void redraw() {
  background(128);

  for (int x = 0; x < outputImg.width; x++) {
    for (int y = 0; y < outputImg.height; y++) {
      px(outputImg, x, y, px(inputImg, floor(x/outputScale), floor(y/outputScale)));
    }
  }
  outputImg.updatePixels();

  image(outputImg, 2, 2);
}

ArrayList<int[]> getQueenNeighbors(PImage img, int[] p) {
  ArrayList<int[]> neighbors = new ArrayList<int[]>();
  for (int x = p[0] - 1; x <= p[0] + 1; x++) {
    if (x < 0 || x >= img.width) continue;
    for (int y = p[1] - 1; y <= p[1] + 1; y++) {
      if (y < 0 || y >= img.height) continue;
      if (x == p[0] && y == p[1]) continue;
      neighbors.add(point(x, y));
    }
  }
  return neighbors;
}

ArrayList<int[]> getRookNeighbors(PImage img, int[] p) {
  ArrayList<int[]> neighbors = new ArrayList<int[]>();
  if (p[0] + 1 < img.width) neighbors.add(point(p[0] + 1, p[1]));
  if (p[0] - 1 >= 0) neighbors.add(point(p[0] - 1, p[1]));
  if (p[1] + 1 < img.height) neighbors.add(point(p[0], p[1] + 1));
  if (p[1] - 1 >= 0) neighbors.add(point(p[0], p[1] - 1));
  return neighbors;
}

ArrayList<int[]> filterCell(PImage img, ArrayList<int[]> points) {
  ArrayList<int[]> result = new ArrayList<int[]>();
  for (int[] p : points) {
    if (isCell(px(img, p))) {
      result.add(p);
    }
  }
  return result;
}

ArrayList<int[]> filterEmpty(PImage img, ArrayList<int[]> points) {
  ArrayList<int[]> result = new ArrayList<int[]>();
  for (int[] p : points) {
    if (isEmpty(px(img, p))) {
      result.add(p);
    }
  }
  return result;
}

ArrayList<int[]> filterBrink(PImage img, ArrayList<int[]> points) {
  ArrayList<int[]> result = new ArrayList<int[]>();
  for (int[] p : points) {
    if (isBrink(px(img, p))) {
      result.add(p);
    }
  }
  return result;
}

boolean isCell(color c) {
  return c == CELL_COLOR;
}

boolean isEmpty(color c) {
  return c == EMPTY_COLOR;
}

boolean isBrink(color c) {
  return c == BRINK_COLOR;
}

color px(PImage img, int x, int y) {
  return img.pixels[y * img.width + x];
}

color px(PImage img, int[] p) {
  return img.pixels[p[1] * img.width + p[0]];
}

void px(PImage img, int x, int y, color c) {
  if (x < 0 || x >= width || y < 0 || y >= height) return;
  img.pixels[y * img.width + x] = c;
}

void px(PImage img, int[] p, color c) {
  if (p[0] < 0 || p[0] >= width || p[1] < 0 || p[1] >= height) return;
  img.pixels[p[1] * img.width + p[0]] = c;
}

int[] point(int x, int y) {
  int[] p = new int[2];
  p[0] = x;
  p[1] = y;
  return p;
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
    case '1':
      for (int i = 0; i < 10; i++) step();
      redraw();
      break;
    case '2':
      for (int i = 0; i < 100; i++) step();
      redraw();
      break;
    case '3':
      for (int i = 0; i < 1000; i++) step();
      redraw();
      break;
    case 'r':
      inputImg.save(fileNamer.next());
      save("render.png");
      break;
  }
}
