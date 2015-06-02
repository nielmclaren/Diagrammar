

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

  reset(120, 5);
}

void draw() {
}

void reset(int size, int steps) {
  background(0);
  noStroke();
  
  int numRows = ceil((float)height / size) * 2 + 1;
  int numCols = ceil((float)width / size) + 1;
  
  int offsetX = (width - numCols * size) / 2;
  int offsetY = (2 * height - numRows * size) / 2;
  
  for (int c = 0; c < numCols; c++) {
    for (int r = 0; r < numRows; r++) {
      fill(random(255));
      int x = offsetX + c * size - (r % 2) * size/2;
      int y = offsetY + r * size / 2;
      quad(
        x + size/2, y - 1,
        x + size + 1, y + size/2,
        x + size/2, y + size + 1,
        x - 1, y + size/2);
    }
  }
}

void keyReleased() {
  switch (key) {
    case ' ':
      reset(randi(3, 15) * 10, 5);
      break;
    case 'r':
      for (int i = 3; i < 15; i++) {
        reset(i * 10, 5);
        save("output/grid_diamond_random_" + i + ".png");
      }
      reset(50, 5);
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

