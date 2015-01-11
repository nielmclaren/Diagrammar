
int numCols;
int numRows;
CloudRenderer[] clouds;
CloudDropping[] droppings;

FileNamer folderNamer;
FileNamer fileNamer;

void setup() {
  size(1024, 768);
  smooth();

  folderNamer = new FileNamer("output/render", "/");

  reset();
}

void reset() {
  CloudRenderer cloud;

  fileNamer = new FileNamer(folderNamer.next() + "frame", "gif");

  numCols = 7;
  numRows = 5;
  clouds = new CloudRenderer[numCols * numRows];
  droppings = new CloudDropping[numCols * numRows];

  for (int c = 0; c < numCols; c++) {
    for (int r = 0; r < numRows; r++) {
      cloud = clouds[c * numRows + r] = new CloudRenderer(
        "cartoon", randi(6, 14), 10, 20, 0.85);
      droppings[c * numRows + r] = new CloudDropping(cloud);
    }
  }

  redraw();
}

void step() {
  for (int i = 0; i < numCols * numRows; i++) {
    droppings[i].step();
  }

  redraw();
}

void redraw() {
  float w = width * 0.9;
  float h = height * 0.925;
  float w0 = (width - w)/2;
  float h0 = height * 0.0075;

  CloudRenderer cloud;
  CloudDropping dropping;

  background(248);

  for (int c = 0; c < numCols; c++) {
    for (int r = 0; r < numRows; r++) {
      pushMatrix();
      translate(
        w0 + (0.5 + c) * w/numCols,
        h0 + (0.5 + r) * h/numRows);

      cloud = clouds[c * numRows + r];
      dropping = droppings[c * numRows + r];

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
      reset();
      break;
    case ' ':
      step();
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
