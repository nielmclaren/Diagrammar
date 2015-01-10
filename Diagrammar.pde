
FileNamer fileNamer;

void setup() {
  size(1024, 768);
  smooth();

  fileNamer = new FileNamer("output/render", "png");

  reset();
}

void reset() {
  float w = width * 0.9;
  float h = height * 0.925;
  float w0 = (width - w)/2;
  float h0 = height * 0.0075;

  int numCols = 7;
  int numRows = 5;
  CloudRenderer cloud;
  CloudDropping dropping;

  background(248);

  for (int c = 0; c < numCols; c++) {
    for (int r = 0; r < numRows; r++) {
      pushMatrix();
      translate(
        w0 + (0.5 + c) * w/numCols,
        h0 + (0.5 + r) * h/numRows);

      cloud = new CloudRenderer(
        "cartoon", randi(6, 14), 10, 20, 0.85);

      dropping = new CloudDropping(cloud);
      dropping.draw(this.g);
      cloud.draw(this.g);

      popMatrix();
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
