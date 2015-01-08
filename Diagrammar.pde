
CloudRenderer[] clouds;

FileNamer fileNamer;

void setup() {
  size(800, 600);

  fileNamer = new FileNamer("output/render", "png");

  reset();
}

void reset() {
  int numClouds = 1;
  clouds = new CloudRenderer[numClouds];
  for (int i = 0; i < numClouds; i++) {
    clouds[i] = new CloudRenderer(width/2, height/2);
  }
}

void draw() {
  background(255);
  int numClouds = clouds.length;
  for (int i = 0; i < numClouds; i++) {
    clouds[i].draw(this.g);
  }
}

void keyReleased() {
  switch (key) {
    case 'e':
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
