
FileNamer fileNamer;

void setup() {
  size(1024, 768);

  fileNamer = new FileNamer("output/render", "png");

  reset();
}

void reset() {
  int numCols = 7;
  int numRows = 8;
  CloudRenderer cloud;

  background(255);

  for (int c = 0; c < numCols; c++) {
    for (int r = 0; r < numRows; r++) {
      cloud = new CloudRenderer((0.5 + c) * width/numCols, (0.5 + r) * width/numRows, "cartoon", randi(6, 14), 10, 20, 0.85);
      cloud.draw(this.g);
    }
  }
}

void draw() {
}

void keyReleased() {
  switch (key) {
    case 'e':
    case ' ':
      reset();
      break;
    case 'r':
      save(fileNamer.next());
      break;
  }
}

float randf(float low, float high) {
  return low + random(1) * (high - low);
}

int randi(int low, int high) {
  return low + floor(random(1) * (high - low));
}
