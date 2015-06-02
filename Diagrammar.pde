

FileNamer fileNamer;

int X_AXIS = 1;
int Y_AXIS = 2;
color black;
color white;

void setup() {
  size(640, 480);
  smooth();

  fileNamer = new FileNamer("output/export", "png");
  
  black = color(0);
  white = color(255);

  reset(30);
}

void draw() {
}

void reset(int size) {
  background(0);
  noStroke();
  
  int numRows = ceil((float)height / size);
  int numCols = ceil((float)width / size);
  
  int offsetX = (width - numCols * size) / 2;
  int offsetY = (height - numRows * size) / 2;
  
  for (int c = 0; c < numCols; c++) {
    for (int r = 0; r < numRows; r++) {
      drawAt(offsetX, offsetY, c, r, size);
    }
  } 
}

void drawAt(int offsetX, int offsetY, int col, int row, int size) {
  for (int i = 0; i < size/2; i++) {
    fill(lerpColor(black, white, (float)i / size * 2));
    rect(offsetX + col * size + i, offsetY + row * size + i, size - 2 * i, size - 2 * i);
  }
}

void keyReleased() {
  switch (key) {
    case ' ':
      reset(randi(3, 15) * 10);
      break;
    case 'r':
      for (int i = 3; i < 15; i++) {
        reset(i * 10);
        save("output/grid_squares_" + i + ".png");
      }
      reset(50);
      save("render.png");
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

