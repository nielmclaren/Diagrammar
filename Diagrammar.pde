
ArrayList<Particle> particles;
PImage inputImg, outputImg;
FileNamer folderNamer, fileNamer;

int frame;

void setup() {
  size(540, 405);
  smooth();

  inputImg = loadImage("assets/eagle_nebula_hubble_crop.jpg");
  outputImg = loadImage("assets/eagle_nebula_hubble_crop.jpg");

  folderNamer = new FileNamer("output/export", "/");
  fileNamer = new FileNamer(folderNamer.next() + "frame", "gif");

  reset();
}

void reset() {
  color c;
  PVector pos, vel, acc;

  particles = new ArrayList<Particle>();
  outputImg = loadImage("assets/eagle_nebula_hubble_crop.jpg");
  image(outputImg, 0, 0);

  int numParticles = 100000;
  for (int i = 0; i < numParticles; i++) {
    pos = new PVector(randf(width), randf(height));
    c = px(inputImg, floor(pos.x), floor(pos.y));
    vel = new PVector(map(brightness(c), 0, 255, 1, 8), 0);
    vel.rotate(randf(2 * PI));

    Particle p = new Particle(pos, vel, c);
    particles.add(p);
  }

  frame = 0;
  fileNamer = new FileNamer(folderNamer.next() + "frame", "gif");
}

void clear() {
}

void draw() {
  redraw();
}

void redraw() {
  if (frame > 10) {
    step();
  }
  else {
    frame++;
  }
  //save(fileNamer.next());
}

void step() {
  outputImg.loadPixels();
  for (int i = 0; i < particles.size(); i++) {
    Particle p = particles.get(i);
    p.step();
    if (!p.isActive()) {
      particles.remove(i);
      i--;
    }
    else {
      px(outputImg, floor(p._position.x), floor(p._position.y), p._color);
    }
  }
  outputImg.updatePixels();

  pushMatrix();
  scale(1);
  image(outputImg, 0, 0);
  popMatrix();
}

color px(PImage img, int x, int y) {
  return img.pixels[y * img.width + x];
}

void px(PImage img, int x, int y, color c) {
  if (x < 0 || x >= width || y < 0 || y >= height) return;
  color b = px(img, x, y);
  img.pixels[y * img.width + x] = lerpColor(b, c, 1);
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
      redraw();
      break;
    case 'r':
      save(fileNamer.next());
      break;
  }
}
