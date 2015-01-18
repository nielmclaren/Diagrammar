
PImage[] buffers;
int currBuffer;
FileNamer folderNamer, fileNamer;

void setup() {
  size(500, 405);
  frameRate(10);

  folderNamer = new FileNamer("output/export", "/");

  reset();
  redraw();
}

void reset() {
  buffers = new PImage[2];
  buffers[0] = loadImage("assets/earring.jpg");
  buffers[1] = loadImage("assets/earring.jpg");
  currBuffer = 0;

  fileNamer = new FileNamer(folderNamer.next() + "frame", "gif");
}

void draw() {
  step();
  step();
  step();
  step();
  image(buffers[currBuffer], 0, 0);
  saveFrame(fileNamer.next());
}

void step() {
  PVector pos = new PVector();
  color c;
  int w = buffers[0].width;
  int h = buffers[0].height;

  buffers[currBuffer].loadPixels();
  for (int x = 0; x < w; x++) {
    for (int y = 0; y < h; y++) {
      c = px(buffers[currBuffer], x, y);
      pos.set(x, y);
      updatePos(pos, c);
      px(buffers[1 - currBuffer], floor(pos.x), floor(pos.y), c);
    }
  }
  buffers[1 - currBuffer].updatePixels();
  currBuffer = 1 - currBuffer;
}

PVector updatePos(PVector pos, color c) {
  float h = hue(c);
  if (h < 64) pos.x++;
  else if (h < 128) pos.x--;
  else if (h < 192) pos.y--;
  else pos.y++;
  return pos;
}

color px(PImage img, int x, int y) {
  return img.pixels[y * img.width + x];
}

void px(PImage img, int x, int y, color c) {
  if (x < 0 || x >= width || y < 0 || y >= height) return;
  img.pixels[y * img.width + x] = c;
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
      break;
    case ' ':
      step();
      break;
    case 'r':
      save(fileNamer.next());
      break;
  }
}
