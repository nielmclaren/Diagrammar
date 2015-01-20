
import java.lang.System;
import java.util.LinkedList;
import java.util.Queue;

PImage inputImg, outputImg;
int outputScale;
ArrayList<int[]> sources;
int currStep;
float prevScore;

ArrayList<int[]> expandables;
int[] newCell;

final color SOURCE_COLOR = color(255, 0, 0);
final color UNVISITED_CELL_COLOR = color(0, 0, 255);
final color UNVISITED_EMPTY_COLOR = color(255, 255, 255);
final color VISITED_EMPTY_COLOR = color(0, 255, 0);

FileNamer folderNamer, fileNamer;

void setup() {
  size(640, 640);
  frameRate(10);

  outputScale = 8;

  folderNamer = new FileNamer("output/export", "/");

  reset();
  step();
  redraw();
}

void draw() {
  for (int i = 0; i < 10; i++) step();
  redraw();
}

void reset() {
  inputImg = createImage(80, 80, RGB);
  outputImg = createImage(
    inputImg.width * outputScale,
    inputImg.height * outputScale, RGB);

  for (int i = 0; i < inputImg.width * inputImg.height; i++) {
    inputImg.pixels[i] = color(255);
  }

  sources = new ArrayList<int[]>();
  sources.add(point(floor(inputImg.width/2), floor(inputImg.height/2)));

  newCell = sources.get(0);
  currStep = 0;
  prevScore = 0;

  fileNamer = new FileNamer(folderNamer.next() + "frame", "gif");
}

void step() {
  float score;

  int w = inputImg.width;
  int h = inputImg.height;

  px(inputImg, newCell, UNVISITED_CELL_COLOR);
  drawSources(inputImg, sources);
  unvisitPixels(inputImg);
  expandables = new ArrayList<int[]>();
  score = traversePixels(inputImg, sources.get(0), expandables);
  if (score < prevScore + 0.5) {
    // Undo adding the last cell. It sucked.
    px(inputImg, newCell, UNVISITED_EMPTY_COLOR);
  }
  else {
    // Indicate which cell we just added.
    px(inputImg, newCell, UNVISITED_CELL_COLOR);
    prevScore = score;
    println(score);
  }
  newCell = expandables.get(randi(expandables.size()));
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

void drawSources(PImage img, ArrayList<int[]> sources) {
  for (int[] p : sources) {
    px(img, p[0], p[1], SOURCE_COLOR);
  }
}

void unvisitPixels(PImage img) {
  img.loadPixels();
  for (int i = 0; i < img.width * img.height; i++) {
    if (isCell(img.pixels[i])) {
      img.pixels[i] = UNVISITED_CELL_COLOR;
    }
    else if (isEmpty(img.pixels[i])) {
      img.pixels[i] = UNVISITED_EMPTY_COLOR;
    }
  }
}

// Traverse from the given source and return any potential new pixels.
float traversePixels(PImage img, int[] source, ArrayList<int[]> expandablesResult) {
  Queue<int[]> brink = new LinkedList<int[]>();
  brink.add(source);

  ArrayList<int[]> newPixels;
  float score = 0;

  while (brink.size() > 0) {
    int[] curr = brink.poll();
    ArrayList<int[]> neighbors = getRookNeighbors(img, curr);
    traversePixel(img, curr, neighbors);

    for (int[] p : neighbors) {
      if (isUnvisitedCell(px(img, p))) {
        brink.add(p);
      }
      else if (isUnvisitedEmpty(px(img, p))) {
        // This method of calculating score is dependent on the order of traversal.
        score += red(px(img, curr)) / 255 + 100;

        expandablesResult.add(p);
        px(img, p, VISITED_EMPTY_COLOR);
      }
    }
  }

  return score;
}

// Traverse the given pixel.
void traversePixel(PImage img, int[] p, ArrayList<int[]> neighbors) {
  ArrayList<int[]> visitedNeighbors = filterVisitedCell(img, neighbors);
  if (visitedNeighbors.size() > 0) {
    int[] q = getMostEnergeticPixel(img, visitedNeighbors);
    px(img, p, color(red(px(img, q)) - 1, 0, 0));
  }
  else {
    //px(img, p, color(254, 0, 0));
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

int[] getMostEnergeticPixel(PImage img, ArrayList<int[]> points) {
  int[] mostEnergeticPixel = null;
  int energy, highestEnergy = 0;
  for (int[] p : points) {
    energy = getPixelEnergy(img, p);
    if (energy > highestEnergy) {
      mostEnergeticPixel = p;
      highestEnergy = energy;
    }
  }
  return mostEnergeticPixel;
}

int getPixelEnergy(PImage img, int[] p) {
  return floor(red(px(img, p)));
}

ArrayList<int[]> filterVisitedCell(PImage img, ArrayList<int[]> points) {
  ArrayList<int[]> result = new ArrayList<int[]>();
  color c;
  for (int[] p : points) {
    c = px(img, p);
    if (red(c) > 0 && green(c) == 0 && blue(c) == 0) {
      result.add(p);
    }
  }
  return result;
}

ArrayList<int[]> filterUnvisitedCell(PImage img, ArrayList<int[]> points) {
  ArrayList<int[]> result = new ArrayList<int[]>();
  for (int[] p : points) {
    if (isUnvisitedCell(px(img, p))) {
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

ArrayList<int[]> filterVisitedEmpty(PImage img, ArrayList<int[]> points) {
  ArrayList<int[]> result = new ArrayList<int[]>();
  for (int[] p : points) {
    if (isVisitedEmpty(px(img, p))) {
      result.add(p);
    }
  }
  return result;
}

boolean isSource(color c) {
  return c == SOURCE_COLOR;
}

boolean isCell(color c) {
  return red(c) < 255 && green(c) == 0 && blue(c) == 0;
}

boolean isUnvisitedCell(color c) {
  return c == UNVISITED_CELL_COLOR;
}

boolean isEmpty(color c) {
  return c == UNVISITED_EMPTY_COLOR || c == VISITED_EMPTY_COLOR;
}

boolean isVisitedEmpty(color c) {
  return c == VISITED_EMPTY_COLOR;
}

boolean isUnvisitedEmpty(color c) {
  return c == UNVISITED_EMPTY_COLOR;
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
    case 'r':
      inputImg.save(fileNamer.next());
      save("render.png");
      break;
  }
}
