
import java.util.Iterator;

FileNamer fileNamer;
ArrayList<EmojiParticle> particles;
PImage scanImg;
float scanScale;
boolean showScan;

void setup() {
  size(1024, 768);
  smooth();

  fileNamer = new FileNamer("output/export", "png");
  scanImg = loadImage("assets/pet.png");
  scanScale = 2;
  showScan = false;

  reset();
}

void draw() {
}

void reset() {
  particles = new ArrayList<EmojiParticle>();

  scanImg.loadPixels();

  int numCols = 70;
  int numRows = 56;
  for (int col = 0; col < numCols; col++) {
    for (int row = 0; row < numRows; row++) {
      int x = floor(col * width/numCols);
      int y = floor(row * height/numRows);
      EmojiParticle p = new EmojiParticle(
        new PVector(x, y),
        getColor(x, y),
        0.25);
      particles.add(p);
    }
  }
  redraw();
}

void redraw() {
  background(0);

  if (showScan) {
    tint(255);
    image(scanImg,
      (width - scanScale * scanImg.width)/2,
      (height - scanScale * scanImg.height)/2,
      scanScale * scanImg.width,
      scanScale * scanImg.height);
  } else {
    Iterator iter = particles.iterator();
    while (iter.hasNext ()) {
      EmojiParticle p = (EmojiParticle) iter.next();
      p.draw(this.g);
    }
  }
}

void keyReleased() {
  switch (key) {
  case ' ':
    reset();
    break;
  case 'r':
    save(fileNamer.next());
    break;
  case 't':
    showScan = !showScan;
    redraw();
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

color getColor(float x, float y) {
  x = (x - (width - scanScale * scanImg.width)/2) / scanScale;
  y = (y - (height - scanScale * scanImg.height)/2) / scanScale;
  if (x < 0 || x >= scanImg.width) return color(0);
  if (y < 0 || y >= scanImg.height) return color(0);
  return scanImg.pixels[floor(y) * scanImg.width + floor(x)];
}

