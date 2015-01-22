
import java.lang.System;
import java.util.LinkedList;
import java.util.Queue;

PImage inputImg, dataImg, outputImg;
int outputScale;
int currStep;
int prevScore;

ArrayList<int[]> cells;
ArrayList<int[]> brink;
int[] newCell;
int newCellBrinkIndex;

PFont titleFont, captionFont;

final color CELL_COLOR = color(0, 0, 255);
final color EMPTY_COLOR = color(0);
final color BRINK_COLOR = color(0, 255, 0);

final int BRIGHTNESS_THRESHOLD = 128;

FileNamer folderNamer, fileNamer;

void setup() {
  size(500, 400);
  frameRate(10);

  outputScale = 4;

  titleFont = createFont("Times New Roman", 32);
  captionFont = createFont("Times New Roman", 18);

  folderNamer = new FileNamer("output/export", "/");

  reset();
  redraw();
}

void draw() {
  int numSteps = floor(constrain(map(brink.size(), 150, 2500, 25, 800), 25, 800));
  for (int i = 0; i < numSteps; i++) step();
  println(brink.size() + " " + numSteps);
  redraw();
  //saveFrame(fileNamer.next());
}

void reset() {
  inputImg = loadImage("assets/earth2.png");
  dataImg = createImage(inputImg.width, inputImg.height, RGB);
  outputImg = createImage(
    inputImg.width * outputScale,
    inputImg.height * outputScale, RGB);

  cells = new ArrayList<int[]>();
  brink = new ArrayList<int[]>();

  inputImg.loadPixels();
  for (int x = 0; x < inputImg.width; x++) {
    for (int y = 0; y < inputImg.height; y++) {
      int[] p = point(x, y);
      if (brightness(px(inputImg, x, y)) > BRIGHTNESS_THRESHOLD) {
        px(dataImg, p, CELL_COLOR);
        cells.add(p);
      }
      else if (filterBright(inputImg, getRookNeighbors(inputImg, p)).size() > 0) {
        px(dataImg, p, BRINK_COLOR);
        brink.add(p);
      }
      else {
        px(dataImg, p, EMPTY_COLOR);
      }
    }
  }

  for (int[] p : cells) {
    px(dataImg, p, CELL_COLOR);
  }
  for (int[] p : brink) {
    px(dataImg, p, BRINK_COLOR);
  }
  dataImg.updatePixels();

  println("Cells # " + cells.size());
  println("Brink # " + brink.size());

  currStep = 0;
  prevScore = 0;

  fileNamer = new FileNamer(folderNamer.next() + "frame", "gif");
}

void step() {
  newCellBrinkIndex = randi(brink.size());
  newCell = brink.get(newCellBrinkIndex);

  ArrayList<int[]> newBrink = filterEmpty(dataImg, getRookNeighbors(dataImg, newCell));

  int score = brink.size() + newBrink.size() - 1;
  if (score > prevScore) {
    cells.add(newCell);
    px(dataImg, newCell, CELL_COLOR);
    px(inputImg, newCell, getNeighborColor(inputImg, newCell));

    brink.remove(newCellBrinkIndex);
    for (int[] p : newBrink) {
      brink.add(p);
      px(dataImg, p, BRINK_COLOR);
    }

    prevScore = score;
  }
}

void redraw() {
  String s;
  int margin = 30;
  int bottomMargin = 90;

  background(44, 45, 77);

  dataImg.loadPixels();
  for (int x = 0; x < outputImg.width; x++) {
    for (int y = 0; y < outputImg.height; y++) {
      px(outputImg, x, y, px(inputImg, floor(x/outputScale), floor(y/outputScale)));
    }
  }
  outputImg.updatePixels();
  image(outputImg,
    (width - outputImg.width) / 2,
    margin + (height - bottomMargin - margin - outputImg.height)/2);

  noStroke();
  fill(0);
  rect(0, 0, width, margin);
  rect(0, 0, margin, height);
  rect(width - margin, 0, width, height);
  rect(0, height - bottomMargin, width, height);

  stroke(255);
  strokeWeight(1);
  noFill();
  rect(
    margin - 4,
    margin - 4,
    width - 2 * margin + 7,
    height - bottomMargin - margin + 7);
  rect(
    margin - 5,
    margin - 5,
    width - 2 * margin + 9,
    height - bottomMargin - margin + 9);

  fill(255);
  s = "Second Law of Thermodynamics";
  textFont(titleFont);
  text(s, (width - textWidth(s)) / 2, height - bottomMargin + 40);

  s = "The sole purpose of life is to dissipate energy.";
  textFont(captionFont);
  text(s, (width - textWidth(s)) / 2, height - bottomMargin + 70);
}

color getNeighborColor(PImage img, int[] p) {
  ArrayList<int[]> neighbors = filterBright(img, getQueenNeighbors(img, p));
  if (neighbors.size() > 0) {
    return px(img, neighbors.get(randi(neighbors.size())));
  }
  else {
    return color(255, 0, 0);
  }
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

ArrayList<int[]> filterCells(PImage img, ArrayList<int[]> points) {
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

ArrayList<int[]> filterBright(PImage img, ArrayList<int[]> points) {
  ArrayList<int[]> result = new ArrayList<int[]>();
  for (int[] p : points) {
    if (brightness(px(img, p)) >= BRIGHTNESS_THRESHOLD) {
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
      outputImg.save(fileNamer.next());
      save("render.png");
      break;
  }
}
