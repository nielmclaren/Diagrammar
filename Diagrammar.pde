
import java.util.Iterator;

FileNamer folderNamer;
FileNamer fileNamer;

int numSlices = 35;
int numCols = 50;
int numRows = 50;
int numBytes;
byte[][] buffers;

int spacing;
int currSlice;

boolean isPaused;
boolean isRendering;
boolean isRenderStarted;

void setup() {
  size(550, 400, P3D);
  smooth();

  folderNamer = new FileNamer("output/export", "/");

  numBytes = 8 * numRows * numSlices + 2;
  buffers = new byte[numSlices][numBytes];
  for (int i = 0; i < numBytes; ++i) {
    byte b = (byte) floor(random(255));
    for (int j = 0; j < numSlices; ++j) {
      buffers[j][i] = b;
    }
  }

  spacing = 6;
  currSlice = 0;

  isPaused = false;
  isRendering = false;
  isRenderStarted = false;
}

void draw() {
  camera(mouseX, mouseY, (height/2) / tan(PI/6), width/2, height/2, 0, 0, 1, 0);
  background(0);

  lights();
  noStroke();
  fill(255);
  pushMatrix();
  translate(width/2, height/2, 0);
  rotateY(currSlice * 2 * PI / numSlices);

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

  if (!isPaused) step();
  if (isRendering) isRendering = renderSlice();
}

void step() {
  if (++currSlice >= numSlices) currSlice = 0;
}

boolean renderSlice() {
  if (isRenderStarted) {
    if (currSlice == 0) {
      isRenderStarted = false;
      return false;
    }
    else {
      save(fileNamer.next());
    }
  }
  else if (currSlice == 0) {
    isRenderStarted = true;
  }
  return true;
}

void keyReleased() {
  switch (key) {
    case 'p':
      isPaused = !isPaused;
      break;
    case ' ':
      step();
      break;
    case 'r':
      fileNamer = new FileNamer(folderNamer.next() + "frame", "gif");
      isRendering = true;
      isRenderStarted = false;
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

