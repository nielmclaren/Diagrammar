
import java.util.Iterator;


FileNamer folderNamer;
FileNamer fileNamer;

int numSlices = 35;
int numCols = 50;
int numRows = 50;

boolean data[][][];

int numBytes;
byte[][] buffers;

int spacing;
int currSlice;
int revolutionDuration;
int prevStepTime;
float stepRemainder;

boolean isPaused;
boolean isRendering;


void setup() {
  size(550, 400, P3D);
  smooth();

  folderNamer = new FileNamer("output/export", "/");

  numBytes = 8 * numRows * numSlices + 2;

  spacing = 6;
  currSlice = 0;
  revolutionDuration = 1400;
  prevStepTime = millis();
  stepRemainder = 0;

  isPaused = false;
  isRendering = false;

  reset();
}

void draw() {
  camera(mouseX, mouseY, (height/2) / tan(PI/6), width/2, height/2, 0, 0, 1, 0);
  background(0);

  lights();
  noStroke();
  fill(255);
  pushMatrix();
  translate(width/2, height/2, 0);
  rotateY(currSlice * 2 * PI / numSlices  +  PI * 0.4);

  for (int col = 0; col < numCols; ++col) {
    int x = col;
    if (x >= 25) x += 32 - 25;
    int byteIndex = x / 8;
    int bitIndex = x % 8;

    assert(byteIndex <= 8);
    assert(bitIndex <= 8);

    for (int row = 0; row < numRows; ++row) {
      if ((buffers[currSlice][row * 8 + byteIndex] & 1 << bitIndex) == 0) continue;
      pushMatrix();
      translate((col - numCols / 2) * spacing, (row - numRows / 2) * spacing, 0);
      box(5);
      popMatrix();
    }
  }
  popMatrix();

  if (isRendering) {
    save(fileNamer.next());
    currSlice++;
    if (currSlice >= numSlices) {
      isRendering = false;
      currSlice = 0;
    }
  }
  else if (!isPaused) step();
}

void reset() {
  currSlice = 0;
  data = generateData();
  buffers = dataToBuffer(data);
}

void step() {
  int now = millis();
  float delta = float(now - prevStepTime)  *  numSlices / revolutionDuration  +  stepRemainder;
  int deltaFloor = floor(delta);
  stepRemainder = delta - deltaFloor;
  currSlice += deltaFloor;
  while (currSlice >= numSlices) currSlice -= numSlices;
  prevStepTime = now;
}

void keyReleased() {
  switch (key) {
    case 'p':
      isPaused = !isPaused;
      break;
    case 's':
      if (++currSlice >= numSlices) currSlice = 0;
      break;
    case ' ':
      reset();
      break;
    case 'r':
      fileNamer = new FileNamer(folderNamer.next() + "frame", "gif");
      isRendering = true;
      currSlice = 0;
      break;
  }
}

void mousePressed() {
}

void mouseReleased() {
}

void mouseDragged() {
}

float randf(float low, float high) {
  return low + random(1) * (high - low);
}

int randi(int low, int high) {
  return low + floor(random(1) * (high - low));
}

boolean[][][] generateData() {
  boolean[][][] result = new boolean[numSlices][numCols][numRows];
  int j;
  for (int i = 0; i < numSlices * 2; ++i) { // Run through it twice to get more stable forms.
    for (int c = 0; c < numCols; ++c) {
      for (int r = 0; r < numRows; ++r) {
        result[i % numSlices][c][r] = i == 0 ? random(1) < 0.1 : generateData(result, (i - 1) % numSlices, c, r);
      }
    }
  }
  return result;
}

// Less than 2 neighbors it dies.
// If 2-3 neighbors a cell lives on.
// More than 3 neighbors it dies.
// Dead cell with exactly 3 neighbors comes alive.
boolean generateData(boolean[][][] d, int prevSlice, int c, int r) {
  int numNeighbors = countNeighbors(d, prevSlice, c, r);
  if (!d[prevSlice][c][r]) return numNeighbors == 3;
  if (numNeighbors < 2) return false;
  if (numNeighbors < 4) return true;
  return false;
}

int countNeighbors(boolean[][][] d, int slice, int col, int row) {
  int result = 0;
  for (int c = max(0, col - 1); c <= min(numCols - 1, col + 1); ++c) {
    for (int r = max(0, row - 1); r <= min(numRows - 1, row + 1); ++r) {
      if ((c != col || r != row) && d[slice][c][r]) result++;
    }
  }
  return result;
}

byte[][] dataToBuffer(boolean[][][] d) {
  byte[][] result = new byte[numSlices][numBytes];
  for (int i = 0; i < numSlices; ++i) {
    for (int b = 0; b < numBytes; ++b) {
      result[i][b] = 0;
    }
  }
  for (int i = 0; i < numSlices; ++i) {
    for (int c = 0; c < numCols; ++c) {
      int x = c;
      if (x >= 25) x += 32 - 25;
      int byteIndex = x / 8;
      int bitIndex = x % 8;

      assert(byteIndex <= 8);
      assert(bitIndex <= 8);

      for (int r = 0; r < numRows; ++r) {
        if (d[i][c][r]) {
          result[i][r * 8 + byteIndex] |= 1 << bitIndex;
        }
      }
    }
  }
  return result;
}

byte randomByte(float p) {
  byte b = 0;
  for (int i = 0; i < 8; ++i) {
    if (random(1) < p) {
      b |= 1 << i;
    }
  }
  return b;
}
