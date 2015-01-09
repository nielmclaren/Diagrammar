
CloudRenderer[] clouds;
int currStep;

FileNamer folderNamer, fileNamer;

void setup() {
  size(540, 405);

  currStep = 0;
  folderNamer = new FileNamer("output/export", "/");

  reset();
}

void reset() {
  currStep = 0;

  int numClouds = 1;
  clouds = new CloudRenderer[numClouds];
  for (int i = 0; i < numClouds; i++) {
    clouds[i] = new CloudRenderer(width/2, height/2);
  }

  background(255);
  clouds[0].draw(this.g);

  fileNamer = new FileNamer(folderNamer.next() + "frame", "gif");
}

void draw() {
}

void step() {
  background(255);

  CloudRenderer cloud = clouds[0];
  switch (currStep) {
    case 0:
      // Draw the cloud and the points that make it.
      cloud.calculateNextPuff();
      cloud.draw(this.g);
      cloud.drawLines(this.g);
      currStep = 1;
      break;
    case 1:
      // Draw the convex hull.
      cloud.draw(this.g);
      cloud.drawLines(this.g);
      cloud.drawConvexHull(this.g);
      currStep = 2;
      break;
    case 2:
      // Draw longest line in the convex hull.
      cloud.draw(this.g);
      cloud.drawConvexHull(this.g);
      cloud.drawLongestHullLine(this.g);
      currStep = 3;
      break;
    case 3:
      // Draw prospective points.
      cloud.draw(this.g);
      cloud.drawLongestHullLine(this.g);
      cloud.drawProspectivePoints(this.g);
      currStep = 4;
      break;
    case 4:
      // Draw new puff.
      cloud.addPuff();
      cloud.draw(this.g);
      cloud.drawLongestHullLine(this.g);
      cloud.drawProspectivePoints(this.g);
      currStep = 0;
      break;
  }

  save(fileNamer.next());
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
